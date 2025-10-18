# 🔧 Technical Specification

## System Architecture

### Component Overview

```
┌─────────────────────────────────────────────────────────────┐
│                     Rayfield UI Layer                       │
│  (User Interface, Toggles, Sliders, Notifications)         │
└──────────────────────┬──────────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────────┐
│                   State Management                          │
│  (Centralized state object with all runtime data)          │
└──────────────────────┬──────────────────────────────────────┘
                       │
         ┌─────────────┴──────────────┐
         │                            │
┌────────▼────────┐          ┌────────▼────────┐
│  Core Systems   │          │  Feature Systems│
│  - Mimic Core   │          │  - Anti-Stun    │
│  - Prediction   │          │  - Anti-Ragdoll │
│  - Sync Engine  │          │  - Anti-Launch  │
└────────┬────────┘          │  - Lock-On      │
         │                   │  - Camera Lock  │
         │                   │  - Moveset Mimic│
         │                   │  - Range Viz    │
         │                   └────────┬────────┘
         │                            │
┌────────▼────────────────────────────▼────────┐
│           RunService Event Loops             │
│  - RenderStepped (Visual updates)            │
│  - Heartbeat (State checks)                  │
└──────────────────────────────────────────────┘
```

---

## Core Components

### 1. State Management System

**Purpose**: Centralized storage for all runtime data

**Structure**:
```lua
State = {
    -- Target Data (Updated every frame)
    targetChar: Model | nil
    targetHRP: BasePart | nil
    targetHumanoid: Humanoid | nil
    targetLastPos: Vector3
    targetVelocity: Vector3
    targetAcceleration: Vector3
    
    -- Local Data (Cached references)
    localChar: Model | nil
    localHRP: BasePart | nil
    localHumanoid: Humanoid | nil
    
    -- Connections (Event handlers)
    mimicConn: RBXScriptConnection | nil
    antiStunConn: RBXScriptConnection | nil
    antiRagdollConn: RBXScriptConnection | nil
    antiLaunchConn: RBXScriptConnection | nil
    lockOnConn: RBXScriptConnection | nil
    cameraLockConn: RBXScriptConnection | nil
    movesetConn: RBXScriptConnection | nil
    rangeUpdateConn: RBXScriptConnection | nil
    
    -- Feature Flags (Boolean toggles)
    mimicEnabled: boolean
    antiStun: boolean
    antiRagdoll: boolean
    antiLaunch: boolean
    lockOn: boolean
    cameraLock: boolean
    movesetMimic: boolean
    rangeViz: boolean
    prediction: boolean
    
    -- Configuration (Tunable parameters)
    predictionFactor: number (0-0.5)
    updateRate: number (0 = every frame)
    rangeDistance: number (10-100)
    
    -- Moveset Cache
    movesetData: { [string]: Animation }
    lastMoveTime: number
    moveCooldown: number (0.1)
    
    -- Visual Objects
    rangePart: BasePart | nil
}
```

**Access Pattern**: Direct property access (fastest in Lua)
```lua
if State.mimicEnabled and State.targetHRP then
    -- Process
end
```

---

### 2. Mimic Core System

**Purpose**: Position, rotation, and velocity synchronization

**Algorithm**:
```
1. Validate cached references (exit early if invalid)
2. Calculate predicted position using kinematic equations
3. Apply CFrame transformation (position + rotation)
4. Sync linear velocity for physics matching
5. Sync angular velocity for rotation matching
6. Match jump states for vertical movement
```

**Update Loop**: RenderStepped (highest priority)

**Performance**: ~0.1-0.3ms per frame

**Code Flow**:
```lua
mimicCore() {
    // Validation (early exit)
    if (!State.targetHRP || !State.localHRP) {
        updateCaches()
        return
    }
    
    // Prediction
    predictedPos = getPredictedPosition()
    
    // Transform (single operation)
    State.localHRP.CFrame = 
        CFrame.new(predictedPos) * State.targetHRP.CFrame.Rotation
    
    // Velocity sync
    State.localHRP.AssemblyLinearVelocity = 
        State.targetHRP.AssemblyLinearVelocity
    State.localHRP.AssemblyAngularVelocity = 
        State.targetHRP.AssemblyAngularVelocity
    
    // Jump sync (conditional)
    if (targetJumping && !localJumping) {
        State.localHumanoid:ChangeState(Jumping)
    }
}
```

---

### 3. Prediction System

**Purpose**: Anticipate target movement for smoother tracking

**Algorithm**: Kinematic motion equation with enhanced safety checks
```
P(t) = P₀ + V₀·t + ½·a·t²

Where:
P(t) = Predicted position at time t
P₀ = Current position
V₀ = Current velocity
a = Current acceleration
t = Prediction factor (time delta, with bounds checking)
```

**Enhanced Safety Features**:
1. **Bounds Checking**: Prediction factors ≥0.45 are clamped to 0.40
2. **Progressive Damping**: Factors 0.35-0.45 receive up to 30% damping
3. **Velocity Scaling**: 
   - Extreme velocity (>200): Prediction clamped to 0.05
   - High velocity (>100): Prediction reduced by 30%
4. **Dynamic Offset Clamping**: Maximum offset scales with velocity (15-50 studs)
5. **Teleport Prevention**: Position validation with lerp smoothing for large jumps

**Optimization**: Cached velocity from previous frame
```lua
-- Frame N-1: Store velocity
State.targetVelocity = currentVelocity

-- Frame N: Calculate acceleration (no need to fetch again)
acceleration = (currentVelocity - State.targetVelocity) / dt
```

**Performance**: 2 vector operations + 1 scalar multiply + safety checks

**Accuracy**: ±5 studs at 0.15 prediction factor (with stability improvements)

---

### 4. Anti-Stun System

**Purpose**: Prevent stun states during combat

**Method**: State monitoring and forced reset

**States Blocked**:
- `Enum.HumanoidStateType.Strafing`
- `Enum.HumanoidStateType.FallingDown`
- `Enum.HumanoidStateType.Ragdoll`

**Update Loop**: Heartbeat (after physics)

**Code**:
```lua
antiStunLoop() {
    state = State.localHumanoid:GetState()
    if (state == Strafing || state == FallingDown || state == Ragdoll) {
        State.localHumanoid:ChangeState(Running)
    }
}
```

**Performance**: ~0.05ms per frame

---

### 5. Anti-Ragdoll System

**Purpose**: Prevent ragdoll physics effects

**Method**: Property monitoring and reset

**Properties Monitored**:
- `Humanoid.PlatformStand`
- `Humanoid.Sit`

**Update Loop**: Heartbeat

**Code**:
```lua
antiRagdollLoop() {
    if (State.localHumanoid.PlatformStand && !State.mimicEnabled) {
        State.localHumanoid.PlatformStand = false
    }
    if (State.localHumanoid.Sit) {
        State.localHumanoid.Sit = false
    }
}
```

**Exception**: PlatformStand allowed during mimic (required for positioning)

**Performance**: ~0.05ms per frame

---

### 6. Anti-Launch System

**Purpose**: Prevent excessive knockback/launches

**Method**: Velocity clamping

**Thresholds**:
- Horizontal velocity: 100 studs/second
- Vertical velocity: 50 studs/second

**Update Loop**: Heartbeat

**Code**:
```lua
antiLaunchLoop() {
    vel = State.localHRP.AssemblyLinearVelocity
    
    // Clamp total velocity
    if (vel.Magnitude > 100 && !State.mimicEnabled) {
        State.localHRP.AssemblyLinearVelocity = vel.Unit * 100
    }
    
    // Clamp vertical velocity
    if (vel.Y > 50 && !State.mimicEnabled) {
        State.localHRP.AssemblyLinearVelocity = 
            Vector3.new(vel.X, min(vel.Y, 50), vel.Z)
    }
}
```

**Performance**: ~0.05ms per frame

---

### 7. Lock-On System

**Purpose**: Maintain rotation toward target

**Method**: Lerped rotation blending

**Update Loop**: RenderStepped (smooth visuals)

**Code**:
```lua
lockOnLoop() {
    direction = (State.targetHRP.Position - State.localHRP.Position).Unit
    lookCFrame = CFrame.lookAt(State.localHRP.Position, 
                                State.targetHRP.Position)
    
    // Smooth 30% blend per frame
    State.localHRP.CFrame = 
        CFrame.new(State.localHRP.Position) *
        State.localHRP.CFrame.Rotation:Lerp(lookCFrame.Rotation, 0.3)
}
```

**Lerp Factor**: 0.3 (balance between smooth and responsive)

**Performance**: ~0.1ms per frame

---

### 8. Camera Lock-On System

**Purpose**: Keep camera focused on target

**Method**: Camera CFrame manipulation

**Update Loop**: RenderStepped

**Code**:
```lua
cameraLockLoop() {
    Camera.CameraType = Scriptable
    Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, 
                                   State.targetHRP.Position)
}
```

**Disable**:
```lua
Camera.CameraType = Custom  // Restore player control
```

**Performance**: ~0.15ms per frame

---

### 9. Range Visualizer System

**Purpose**: Display attack range indicator

**Method**: Dynamic part positioning and coloring

**Visual**: Cylinder part with neon material

**Update Loop**: Heartbeat

**Color Logic**:
```lua
distance = (targetPos - localPos).Magnitude
if (distance <= State.rangeDistance) {
    color = Green  // Target in range
} else {
    color = Red    // Target out of range
}
```

**Performance**: ~0.05ms per frame

---

### 10. Moveset Mimic System

**Purpose**: Replicate target's combat animations

**Method**: Animation track detection and replication

**Update Loop**: Heartbeat (with cooldown)

**Detection**:
```lua
targetTracks = State.targetHumanoid:GetPlayingAnimationTracks()
for track in targetTracks {
    animId = track.Animation.AnimationId
    if (animId.contains("punch|kick|attack|skill")) {
        // Cache animation
        if (!State.movesetData[animId]) {
            State.movesetData[animId] = track.Animation
        }
        // Play on local character
        localAnim = State.localHumanoid:LoadAnimation(cached)
        localAnim:Play()
    }
}
```

**Cooldown**: 0.1 seconds (prevents spam)

**Performance**: ~0.1ms per frame (when not playing)

---

### 11. Enhanced Deep Neural Network Optimizer System

**Purpose**: AI-powered automatic parameter optimization using deep learning

**Method**: Enhanced feedforward neural network with advanced training and pre-learning

**Architecture**:
- **Input Layer**: 4 nodes (predictionFactor, rangeDistance, lockOnActive, currentFPS)
- **Hidden Layer 1**: 8 nodes with LeakyReLU activation (increased capacity)
- **Hidden Layer 2**: 8 nodes with Tanh activation (improved gradient flow)
- **Hidden Layer 3**: 4 nodes with LeakyReLU activation (feature condensation)
- **Output Layer**: 3 nodes with Sigmoid activation (optimalPrediction, optimalRange, optimalLockOn)

**Algorithm**:
```lua
// Forward pass
// Layer 1: LeakyReLU
hidden1[j] = LeakyReLU(sum(input[i] * weightsIH1[i][j]) + biasH1[j])

// Layer 2: Tanh
hidden2[j] = Tanh(sum(hidden1[i] * weightsH1H2[i][j]) + biasH2[j])

// Layer 3: LeakyReLU
hidden3[j] = LeakyReLU(sum(hidden2[i] * weightsH2H3[i][j]) + biasH3[j])

// Output: Sigmoid
output[k] = Sigmoid(sum(hidden3[j] * weightsH3O[j][k]) + biasO[k])
```

**Activation Functions**:
```lua
// LeakyReLU (prevents dying neurons)
LeakyReLU(x) = x > 0 ? x : 0.01 * x

// Tanh (improved gradient flow)
Tanh(x) = (exp(2x) - 1) / (exp(2x) + 1)

// Sigmoid (output normalization)
Sigmoid(x) = 1 / (1 + exp(-x))
```

**Weight Initialization**:
```lua
// He initialization for LeakyReLU layers
heScale = sqrt(2.0 / inputSize)
weight = (random() - 0.5) * 2 * heScale

// Xavier initialization for Sigmoid output
xavierScale = sqrt(1.0 / inputSize)
weight = (random() - 0.5) * 2 * xavierScale
```

**Training**:
- **Pre-training**: 100 simulated samples with diverse scenarios
- **Epochs**: 50 iterations with full-batch gradient descent
- **Learning Rate**: 0.02
- **Loss Function**: Mean Squared Error (MSE)
- **Backpropagation**: Full gradient computation through all layers
- **Training Time**: ~1-2 seconds on initialization

**Performance Scoring**:
```lua
score = 0
// FPS component (target 60 FPS)
score += min(fps / 60, 1) * 40

// Distance to target (closer when in range)
if in_range:
    score += 30 + (1 - distance/rangeDistance) * 20
else:
    score += max(0, 20 - (distance - rangeDistance) / 10)

// Lock-on accuracy (rotation alignment)
if lockOn:
    alignment = direction.Dot(forward)
    score += max(0, alignment) * 10
```

**Sample Collection**:
- Interval: Every 2 seconds
- Buffer Size: 20 samples (rolling window)
- Normalization: All inputs normalized to 0-1 range

**Optimization Process**:
1. Pre-train network on 100 simulated samples (initialization)
2. Collect performance samples during gameplay
3. Find best-performing sample based on score
4. Use trained network to predict optimal settings
5. Apply denormalized outputs to game parameters

**UI Controls**:
- Toggle: Enable/Disable AI optimization
- Button: Apply deep learning optimized settings
- Label: Real-time status, score, training loss, and epoch display

**Performance**: ~0.1ms per optimization cycle (minimal overhead)

**Memory**: ~4 KB additional (weights, biases, training data, and samples storage)

**Network Complexity**: 163 total parameters (140 weights + 23 biases)

---

## Event Loop Architecture

### RenderStepped (Before Rendering)
**Priority**: Highest (visual consistency)

**Features**:
- Mimic Core (position/rotation sync)
- Lock-On (rotation tracking)
- Camera Lock (camera positioning)

**Frequency**: ~60 FPS (16.67ms per frame)

**Total Budget**: ~0.5ms per frame

---

### Heartbeat (After Physics)
**Priority**: Medium (state management)

**Features**:
- Anti-Stun (state checking)
- Anti-Ragdoll (property checking)
- Anti-Launch (velocity clamping)
- Moveset Mimic (animation detection)
- Range Visualizer (position update)

**Frequency**: ~60 FPS (16.67ms per frame)

**Total Budget**: ~0.3ms per frame

---

## Memory Management

### Object Lifecycle

**Creation**:
- UI elements: On script load
- State object: On script load
- Range visualizer: On toggle enable

**Caching**:
- Character references: Updated on character added
- Service references: Cached at startup
- Animation data: Cached on first detection

**Destruction**:
- Connections: On feature disable or script end
- Range visualizer: On toggle disable or script end
- UI: On window close

**Memory Footprint**:
- Baseline: ~2-3 MB (UI library)
- Runtime: ~5-6 MB (all features active)
- Peak: ~8 MB (during animation cache building)

---

## Error Handling

### Strategy: Fail-Safe

**Connection Errors**:
```lua
function safeDisconnect(conn)
    if conn then 
        pcall(function() conn:Disconnect() end)
    end
end
```

**Reference Errors**:
```lua
function updateCache()
    // Safe navigation with FindFirstChild
    State.localHRP = char and char:FindFirstChild("HumanoidRootPart")
end
```

**Animation Errors**:
```lua
pcall(function()
    local anim = humanoid:LoadAnimation(animation)
    anim:Play()
end)
// Silently fail if animation invalid
```

---

## Performance Monitoring

### Key Metrics

**Frame Time**:
- Target: < 1ms total overhead
- Mimic Core: 0.1-0.3ms
- All Features: 0.8-1.2ms

**Memory**:
- Target: < 10 MB total
- Current: 5-6 MB typical

**CPU Usage**:
- Target: < 5% additional CPU
- Current: 2-3% typical

---

## API Reference

### State Management

#### `updateLocalCache()`
Updates cached references for local character
- **Returns**: void
- **Side Effects**: Updates State.localChar, State.localHRP, State.localHumanoid

#### `updateTargetCache()`
Updates cached references for target character
- **Returns**: void
- **Side Effects**: Updates State.targetChar, State.targetHRP, State.targetHumanoid

### Core Functions

#### `startMimic(targetChar: Model)`
Initializes and starts mimic system
- **Parameters**: targetChar (Model) - Target character to mimic
- **Returns**: void
- **Side Effects**: Sets up RenderStepped connection, enables PlatformStand

#### `stopAllFeatures()`
Disables all features and cleans up resources
- **Returns**: void
- **Side Effects**: Disconnects all connections, resets character state

#### `getPredictedPosition()`
Calculates predicted target position
- **Returns**: Vector3 - Predicted position
- **Uses**: State.targetVelocity, State.targetAcceleration

### Feature Functions

#### `setupAntiStun()`
Enables anti-stun system
- **Returns**: void
- **Side Effects**: Creates Heartbeat connection

#### `setupLockOn()`
Enables lock-on system
- **Returns**: void
- **Side Effects**: Creates RenderStepped connection

#### `createRangeVisualizer()`
Creates range indicator part
- **Returns**: void
- **Side Effects**: Creates State.rangePart, parents to Workspace

---

## Configuration

### Tunable Parameters

```lua
State = {
    predictionFactor: 0.15,      // 0-0.5, RECOMMENDED: 0.08-0.35
    updateRate: 0,               // 0 = every frame
    rangeDistance: 50,           // 10-100 studs
    moveCooldown: 0.1,          // seconds between move detections
}
```

**Prediction Factor Safe Ranges**:
- **0.08-0.15**: Safe for all conditions (recommended)
- **0.15-0.25**: Good for medium-range tracking with stable FPS
- **0.25-0.35**: High prediction, requires 50+ FPS
- **0.35-0.45**: Damping zone, automatically reduced
- **≥0.45**: Auto-clamped to 0.40 (prevents teleporting)

### Performance Profiles

**Maximum Speed** (Lowest latency):
```lua
predictionFactor = 0.10
rangeViz = false
movesetMimic = false
```

**Maximum Accuracy** (Best tracking):
```lua
predictionFactor = 0.25  // Was 0.20, now safer upper bound
rangeViz = true
movesetMimic = true
```

**Balanced** (Recommended):
```lua
predictionFactor = 0.15
rangeViz = true
movesetMimic = false
```

**High Performance** (60+ FPS systems):
```lua
predictionFactor = 0.30  // Safe with high FPS
rangeViz = true
movesetMimic = true
```

---

## Dependencies

### External Libraries
- **Rayfield UI**: https://sirius.menu/rayfield
  - Version: Latest
  - Purpose: Modern UI interface
  - Size: ~2 MB loaded

### Roblox Services
- `Players`: Player management
- `RunService`: Event loops
- `UserInputService`: Input handling
- `Workspace`: 3D environment access
- `Camera`: Camera manipulation

---

## Version History

### v1.1.0 (Current)
- **Fixed**: Prediction teleporting issue around 0.5 factor
- **Added**: Dynamic bounds checking for prediction factors
- **Added**: Progressive damping for high prediction values (0.35-0.45)
- **Added**: Velocity-based prediction reduction
- **Added**: Dynamic offset clamping (15-50 studs based on velocity)
- **Added**: Teleport prevention with position validation
- **Added**: User warnings for dangerous prediction values
- **Improved**: Neural network training to avoid extreme predictions
- **Improved**: Smooth position updates with lerp for large jumps
- Complete test suite with 10 passing tests

### v1.0.0
- Initial optimized release
- All core features implemented
- Maximum performance optimizations
- Rayfield UI integration
- Complete documentation

---

## Future Enhancements

### Planned Features
1. Custom keybinds for quick toggles
2. Multiple target support (switch between targets)
3. Replay system (record and replay movements)
4. Performance profiler (built-in FPS/latency monitoring)
5. Team integration (sync with team members)

### Performance Improvements
1. SIMD-style vector operations (if exposed by Roblox)
2. Predictive animation caching
3. Adaptive update rate based on FPS
4. WebSocket integration for lower latency

---

## License & Credits

**Created by**: Optimized Performance Team
**License**: Educational purposes
**Based on**: Original TSB mimic concept
**Optimized for**: Maximum performance and minimal latency
