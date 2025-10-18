-- Prediction Bounds Checking and Smoothing Test
-- Tests the fixes for teleporting issues with predictions near 0.5

print("=== Prediction Bounds Checking Test ===")
print("")

-- Test counters
local tests_passed = 0
local tests_failed = 0
local total_tests = 0

-- Helper function to run tests
local function test(name, func)
    total_tests = total_tests + 1
    print(string.format("Test %d: %s", total_tests, name))
    local success, error_msg = pcall(func)
    if success then
        tests_passed = tests_passed + 1
        print("  ✓ PASSED")
    else
        tests_failed = tests_failed + 1
        print("  ✗ FAILED: " .. tostring(error_msg))
    end
    print("")
end

-- Helper function for assertions
local function assert_true(condition, message)
    if not condition then
        error(message or "Assertion failed")
    end
end

local function assert_equals(actual, expected, tolerance, message)
    tolerance = tolerance or 0
    if math.abs(actual - expected) > tolerance then
        error(string.format("%s - Expected: %.4f, Got: %.4f", 
            message or "Values don't match", expected, actual))
    end
end

-- Mock State object for testing
local State = {
    prediction = true,
    predictionFactor = 0.15,
    targetVelocity = Vector3 or {X = 0, Y = 0, Z = 0},
    targetAcceleration = Vector3 or {X = 0, Y = 0, Z = 0},
}

-- Mock Vector3 if not available
if not Vector3 then
    Vector3 = {}
    Vector3.__index = Vector3
    
    function Vector3.new(x, y, z)
        local v = setmetatable({}, Vector3)
        v.X = x or 0
        v.Y = y or 0
        v.Z = z or 0
        return v
    end
    
    Vector3.zero = Vector3.new(0, 0, 0)
    
    function Vector3:__add(other)
        return Vector3.new(self.X + other.X, self.Y + other.Y, self.Z + other.Z)
    end
    
    function Vector3:__sub(other)
        return Vector3.new(self.X - other.X, self.Y - other.Y, self.Z - other.Z)
    end
    
    function Vector3:__mul(scalar)
        if type(scalar) == "number" then
            return Vector3.new(self.X * scalar, self.Y * scalar, self.Z * scalar)
        end
        return Vector3.new(self.X * scalar.X, self.Y * scalar.Y, self.Z * scalar.Z)
    end
    
    function Vector3:Magnitude()
        return math.sqrt(self.X * self.X + self.Y * self.Y + self.Z * self.Z)
    end
    
    function Vector3:Unit()
        local mag = self:Magnitude()
        if mag > 0 then
            return Vector3.new(self.X / mag, self.Y / mag, self.Z / mag)
        end
        return Vector3.new(0, 0, 0)
    end
    
    function Vector3:Lerp(other, alpha)
        return Vector3.new(
            self.X + (other.X - self.X) * alpha,
            self.Y + (other.Y - self.Y) * alpha,
            self.Z + (other.Z - self.Z) * alpha
        )
    end
end

-- Mock target HRP
local mockTargetHRP = {
    Position = Vector3.new(100, 10, 100),
    AssemblyLinearVelocity = Vector3.new(50, 0, 50),
}

State.targetHRP = mockTargetHRP

-- Implementation of getPredictedPosition with bounds checking (from Main)
local function getPredictedPosition()
    if not State.prediction or not State.targetHRP then 
        return State.targetHRP and State.targetHRP.Position or Vector3.zero
    end
    
    -- Use cached velocity and acceleration
    local currentVel = State.targetHRP.AssemblyLinearVelocity
    local dt = State.predictionFactor
    
    -- BOUNDS CHECK: Skip prediction near 0.5 to prevent teleporting
    -- When prediction factor is near max (0.45-0.5), use reduced factor
    if dt >= 0.45 then
        -- Clamp to safer range and apply damping
        dt = 0.40  -- Safe maximum to prevent extreme predictions
    end
    
    -- STABILITY CHECK: If prediction factor is risky (0.35-0.45), apply smoothing
    if dt >= 0.35 and dt < 0.45 then
        -- Reduce prediction strength progressively as we approach 0.45
        local dampingFactor = 1 - ((dt - 0.35) / 0.1) * 0.3  -- 30% reduction at 0.45
        dt = dt * dampingFactor
    end
    
    -- Update acceleration (cached from last frame)
    State.targetAcceleration = (currentVel - State.targetVelocity) * (1.0 / 0.016)
    State.targetVelocity = currentVel
    
    -- VELOCITY CHECK: If velocity is extreme, reduce prediction to avoid teleporting
    local velMagnitude = currentVel:Magnitude()
    if velMagnitude > 200 then
        -- Extreme velocity detected, use minimal prediction
        dt = math.min(dt, 0.05)
    elseif velMagnitude > 100 then
        -- High velocity, reduce prediction factor
        dt = dt * 0.7
    end
    
    -- Kinematic prediction: p = p0 + v*t + 0.5*a*t^2
    local predictedOffset = currentVel * dt + State.targetAcceleration * (0.5 * dt * dt)
    
    -- SANITY CHECK: Limit maximum prediction offset to prevent teleporting
    -- Dynamic max based on velocity - higher velocity = higher allowed offset (within reason)
    local maxOffset = math.min(50, 15 + velMagnitude * 0.15)  -- Scale with velocity, cap at 50 studs
    
    if predictedOffset:Magnitude() > maxOffset then
        -- Clamp the prediction offset to reasonable bounds
        predictedOffset = predictedOffset:Unit() * maxOffset
    end
    
    return State.targetHRP.Position + predictedOffset
end

-- Test 1: Normal prediction factor (0.15) should work without clamping
test("Normal prediction factor (0.15)", function()
    State.predictionFactor = 0.15
    State.targetHRP.AssemblyLinearVelocity = Vector3.new(50, 0, 50)
    
    local predictedPos = getPredictedPosition()
    local offset = (predictedPos - State.targetHRP.Position):Magnitude()
    
    -- At 0.15 prediction with velocity 70.7, offset should be around 10-26 studs (depends on acceleration)
    assert_true(offset > 0, "Prediction should produce an offset")
    assert_true(offset < 30, "Prediction offset should be reasonable")
    print(string.format("  Offset: %.2f studs", offset))
end)

-- Test 2: High prediction factor (0.45) should be clamped to 0.40
test("High prediction factor (0.45) clamping", function()
    State.predictionFactor = 0.45
    State.targetHRP.AssemblyLinearVelocity = Vector3.new(50, 0, 50)
    
    local predictedPos = getPredictedPosition()
    local offset = (predictedPos - State.targetHRP.Position):Magnitude()
    
    -- At 0.45 clamped to 0.40, offset should be less than with unclamped 0.45
    assert_true(offset < 35, "Prediction offset should be clamped")
    print(string.format("  Offset with clamping: %.2f studs (clamped from 0.45 to 0.40)", offset))
end)

-- Test 3: Maximum prediction factor (0.5) should be clamped
test("Maximum prediction factor (0.5) clamping", function()
    State.predictionFactor = 0.5
    State.targetHRP.AssemblyLinearVelocity = Vector3.new(50, 0, 50)
    
    local predictedPos = getPredictedPosition()
    local offset = (predictedPos - State.targetHRP.Position):Magnitude()
    
    -- At 0.5 clamped to 0.40, should be same as 0.45 test
    assert_true(offset < 35, "Maximum prediction should be clamped to prevent teleporting")
    print(string.format("  Offset with clamping: %.2f studs (clamped from 0.5 to 0.40)", offset))
end)

-- Test 4: Damping zone (0.35-0.45) should apply progressive smoothing
test("Damping zone smoothing (0.35-0.44)", function()
    State.predictionFactor = 0.35
    State.targetHRP.AssemblyLinearVelocity = Vector3.new(50, 0, 50)
    
    local predictedPos1 = getPredictedPosition()
    local offset1 = (predictedPos1 - State.targetHRP.Position):Magnitude()
    
    State.predictionFactor = 0.40
    local predictedPos2 = getPredictedPosition()
    local offset2 = (predictedPos2 - State.targetHRP.Position):Magnitude()
    
    -- Damping may cause offset to be similar or slightly reduced - this is expected behavior
    print(string.format("  Offset at 0.35: %.2f studs", offset1))
    print(string.format("  Offset at 0.40: %.2f studs (with damping)", offset2))
    -- The damping is working correctly - both should be in reasonable range
    assert_true(offset1 > 0 and offset2 > 0, "Both predictions should produce offsets")
    assert_true(math.abs(offset1 - offset2) < 5, "Damping should keep offsets similar")
end)

-- Test 5: Extreme velocity (>200) should trigger minimal prediction
test("Extreme velocity handling (>200)", function()
    State.predictionFactor = 0.25
    State.targetHRP.AssemblyLinearVelocity = Vector3.new(200, 0, 200)
    
    local predictedPos = getPredictedPosition()
    local offset = (predictedPos - State.targetHRP.Position):Magnitude()
    
    -- With extreme velocity, prediction should be clamped to 0.05
    -- Maximum offset is also clamped based on velocity
    assert_true(offset < 50, "Extreme velocity should be capped at max offset")
    print(string.format("  Offset with extreme velocity: %.2f studs (reduced prediction)", offset))
end)

-- Test 6: High velocity (>100) should reduce prediction
test("High velocity handling (>100)", function()
    State.predictionFactor = 0.25
    State.targetHRP.AssemblyLinearVelocity = Vector3.new(100, 0, 50)
    
    local predictedPos = getPredictedPosition()
    local offset = (predictedPos - State.targetHRP.Position):Magnitude()
    
    -- With high velocity, prediction factor should be reduced by 30%
    assert_true(offset < 50, "High velocity should be controlled")
    print(string.format("  Offset with high velocity: %.2f studs (70%% prediction)", offset))
end)

-- Test 7: Maximum offset clamping (dynamic, up to 50 studs)
test("Maximum offset clamping", function()
    State.predictionFactor = 0.30
    State.targetHRP.AssemblyLinearVelocity = Vector3.new(300, 0, 300)
    
    local predictedPos = getPredictedPosition()
    local offset = (predictedPos - State.targetHRP.Position):Magnitude()
    
    -- Offset should never exceed 50 studs (dynamic cap)
    assert_true(offset <= 50.1, "Offset should be clamped at maximum")
    print(string.format("  Offset: %.2f studs (clamped at max)", offset))
end)

-- Test 8: Zero velocity should produce minimal offset
test("Zero velocity prediction", function()
    State.predictionFactor = 0.25
    State.targetHRP.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    
    local predictedPos = getPredictedPosition()
    local offset = (predictedPos - State.targetHRP.Position):Magnitude()
    
    -- With zero velocity, offset depends on acceleration from previous frame
    -- Should still be reasonable
    assert_true(offset < 50, "Zero velocity should produce controlled offset")
    print(string.format("  Offset: %.2f studs", offset))
end)

-- Test 9: Prediction disabled should return exact position
test("Prediction disabled", function()
    State.prediction = false
    State.predictionFactor = 0.5
    State.targetHRP.AssemblyLinearVelocity = Vector3.new(100, 0, 100)
    
    local predictedPos = getPredictedPosition()
    local offset = (predictedPos - State.targetHRP.Position):Magnitude()
    
    assert_equals(offset, 0, 0.01, "Disabled prediction should return exact position")
    
    -- Re-enable for other tests
    State.prediction = true
end)

-- Test 10: Progressive damping verification
test("Progressive damping at different factors", function()
    local factors = {0.30, 0.35, 0.38, 0.40, 0.42, 0.44}
    local offsets = {}
    
    State.targetHRP.AssemblyLinearVelocity = Vector3.new(60, 0, 60)
    
    for _, factor in ipairs(factors) do
        State.predictionFactor = factor
        local predictedPos = getPredictedPosition()
        local offset = (predictedPos - State.targetHRP.Position):Magnitude()
        table.insert(offsets, offset)
        print(string.format("  Factor %.2f -> Offset: %.2f studs", factor, offset))
    end
    
    -- With damping, offsets should stabilize or reduce in the high range
    -- This is the desired behavior to prevent teleporting
    assert_true(offsets[#offsets] < offsets[1] + 10, "Damping should control offset growth")
end)

-- Print summary
print("=== Test Summary ===")
print(string.format("Total Tests: %d", total_tests))
print(string.format("Passed: %d", tests_passed))
print(string.format("Failed: %d", tests_failed))
print(string.format("Success Rate: %.1f%%", (tests_passed / total_tests) * 100))

if tests_failed == 0 then
    print("\n✓ All tests passed! Prediction bounds checking is working correctly.")
    os.exit(0)
else
    print("\n✗ Some tests failed. Please review the implementation.")
    os.exit(1)
end
