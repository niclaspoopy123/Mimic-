# 📚 Usage Examples & Scenarios

This guide provides practical examples and scenarios for using the Optimized TSB Mimic Script.

## Table of Contents
1. [Basic Usage](#basic-usage)
2. [Combat Scenarios](#combat-scenarios)
3. [Defensive Setups](#defensive-setups)
4. [Advanced Techniques](#advanced-techniques)
5. [Troubleshooting](#troubleshooting)

---

## Basic Usage

### Example 1: Simple Mimic Setup
**Goal**: Basic position mimicking of another player

**Steps**:
1. Execute the script
2. Click "🎯 Select Target (Click Player)"
3. Click on the target player
4. Toggle "⚡ Start Mimic (Ultra Fast)" ON
5. You now perfectly mimic the target's position and rotation

**Use Case**: Training, spectating, or following friends

---

### Example 2: Enhanced Mimic with Prediction
**Goal**: Mimic with predictive positioning for smoother tracking

**Setup**:
```
✅ Start Mimic: ON
✅ Prediction: ON
⚙️ Prediction Factor: 0.15 (default)
```

**Result**: Your character predicts where the target will be, resulting in smoother movement and better combat accuracy.

**Adjust Prediction**:
- **Close Combat**: 0.05-0.10 (less prediction)
- **Medium Range**: 0.15-0.20 (balanced)
- **Long Range**: 0.25-0.35 (more prediction)

---

## Combat Scenarios

### Scenario 1: Aggressive Combat Setup
**Goal**: Maximum combat effectiveness with protection

**Configuration**:
```
Main Tab:
✅ Start Mimic: ON
✅ Prediction: ON
⚙️ Prediction Factor: 0.15

Combat Tab:
✅ Anti-Stun: ON
✅ Anti-Ragdoll: ON
✅ Anti-Launch: ON
✅ Lock-On Target: ON
✅ Moveset Mimic: ON

Visuals Tab:
✅ Camera Lock-On: ON
✅ Range Visualizer: ON
⚙️ Range Distance: 30-40
```

**Why This Works**:
- Anti-features keep you from being disabled
- Lock-on maintains facing toward target
- Moveset mimic copies their attacks
- Camera lock keeps target in view
- Range visualizer shows optimal distance

**Use Case**: 1v1 battles, aggressive playstyle

---

### Scenario 2: Defensive Counter Setup
**Goal**: Survive and counter-attack

**Configuration**:
```
Main Tab:
❌ Start Mimic: OFF
✅ Prediction: OFF

Combat Tab:
✅ Anti-Stun: ON
✅ Anti-Ragdoll: ON
✅ Anti-Launch: ON
✅ Lock-On Target: ON
❌ Moveset Mimic: OFF

Visuals Tab:
❌ Camera Lock-On: OFF
✅ Range Visualizer: ON
⚙️ Range Distance: 50
```

**Why This Works**:
- Anti-features protect you from combos
- Lock-on maintains target tracking
- No mimic = you control your movement
- Large range visualizer helps with positioning

**Use Case**: Defending against aggressive players, learning opponent patterns

---

### Scenario 3: Training Mode
**Goal**: Practice against skilled players

**Configuration**:
```
Main Tab:
✅ Start Mimic: ON
✅ Prediction: ON
⚙️ Prediction Factor: 0.20

Combat Tab:
❌ Anti-Stun: OFF
❌ Anti-Ragdoll: OFF
❌ Anti-Launch: OFF
❌ Lock-On Target: OFF
✅ Moveset Mimic: ON

Visuals Tab:
✅ Camera Lock-On: ON
❌ Range Visualizer: OFF
```

**Why This Works**:
- Mimic their positioning and movements
- Learn their combat patterns
- Experience their perspective
- No anti-features = feel actual combat

**Use Case**: Skill improvement, learning from better players

---

## Defensive Setups

### Setup 1: Full Protection (Tank Mode)
**Goal**: Maximum survivability

**Configuration**:
```
Combat Tab:
✅ Anti-Stun: ON
✅ Anti-Ragdoll: ON
✅ Anti-Launch: ON
✅ Lock-On Target: ON
❌ Moveset Mimic: OFF
```

**Benefits**:
- Nearly impossible to combo
- Maintain control in chaotic fights
- Perfect for outnumbered situations
- Counter-attack opportunities

**Drawbacks**:
- May be detected by anti-cheat
- Reduces challenge/learning

---

### Setup 2: Anti-Combo Protection
**Goal**: Break out of enemy combos

**Configuration**:
```
Combat Tab:
✅ Anti-Stun: ON
✅ Anti-Ragdoll: ON
❌ Anti-Launch: OFF
❌ Lock-On Target: OFF
```

**Benefits**:
- Escape stun locks
- Maintain mobility
- Natural launch behavior (less suspicious)
- Good for learning combo breaks

---

## Advanced Techniques

### Technique 1: Prediction Adjustment for Different Moves

**Fast Attacks** (Punches, Quick Hits):
```
Prediction Factor: 0.05-0.10
```
Target moves less between frames

**Dashing/Movement Abilities**:
```
Prediction Factor: 0.20-0.30
```
Target covers more ground quickly

**Ultimate Abilities**:
```
Prediction Factor: 0.10-0.15
```
Usually telegraphed, medium prediction

---

### Technique 2: Range Management

**Optimal Combat Range**:
```
Range Distance: 25-35 studs
```
- Most moves effective here
- Easy to close gaps
- Quick reaction time

**Safe Distance**:
```
Range Distance: 45-60 studs
```
- Monitor from safety
- Plan approaches
- Avoid surprise attacks

**Close Combat**:
```
Range Distance: 15-25 studs
```
- Aggressive pressure
- Limited escape room
- High-risk, high-reward

---

### Technique 3: Camera Lock Strategies

**For Learning**:
- Use camera lock to study opponent's patterns
- Watch their movement habits
- Identify combo starters

**For Combat**:
- Quick toggle on during engagement
- Toggle off to check surroundings
- Combine with lock-on for tracking

**For Spectating**:
- Full camera lock + mimic
- Perfect for watching skilled players
- Learn positioning and timing

---

### Technique 4: Moveset Mimic Timing

**Best Used When**:
- Learning new character/moveset
- Practicing combo timing
- Synchronized attacks (team fights)

**Avoid Using When**:
- Need independent movement
- Fighting multiple opponents
- Using different character abilities

---

### Technique 5: Neural Network Optimization

**What It Does**:
The neural network automatically analyzes your gameplay performance and suggests optimal settings based on:
- Current FPS (performance metric)
- Distance to target (combat effectiveness)
- Lock-on accuracy (rotation alignment)

**How to Use**:
1. Select a target and start mimic
2. Enable "🤖 Enable AI Optimization" in Settings tab
3. Play normally for 10-20 seconds (let it collect data)
4. Watch the status label for sample count
5. Click "✨ Apply Optimized Settings" when ready (5+ samples)
6. Settings are automatically adjusted for best performance

**Best Practices**:
- Use in different combat scenarios for varied data
- Re-optimize when switching playstyles
- Combine with manual tweaking for fine-tuning
- Check the performance score to track improvements

**When to Re-optimize**:
- After changing major features (anti-features, lock-on)
- When experiencing FPS drops
- When switching between aggressive/defensive play
- After significant target distance changes

---

## Troubleshooting

### Issue 1: Mimic Not Starting
**Symptoms**: Toggle turns on but nothing happens

**Solutions**:
1. Verify target is selected:
   ```
   - Target name should show in notification
   - Click "Select Target" again if unsure
   ```

2. Check target validity:
   ```
   - Target must have Humanoid
   - Target must have HumanoidRootPart
   - Target cannot be yourself
   ```

3. Verify your character spawned:
   ```
   - Reset character
   - Wait for full spawn
   - Try again
   ```

---

### Issue 2: Jittery/Laggy Mimic
**Symptoms**: Position updates are jerky

**Solutions**:
1. Adjust prediction:
   ```
   Lower Prediction Factor: 0.05-0.10
   ```

2. Check network:
   ```
   - High ping causes delays
   - Target might be lagging
   ```

3. Disable heavy features:
   ```
   ❌ Range Visualizer: OFF
   ❌ Moveset Mimic: OFF
   ```

---

### Issue 3: Anti-Features Not Working
**Symptoms**: Still getting stunned/ragdolled

**Solutions**:
1. Verify toggles are ON:
   ```
   Check Combat Tab for green indicators
   ```

2. Server-side anti-cheat:
   ```
   Some servers may patch anti-features
   Try different server
   ```

3. Timing issues:
   ```
   Features activate on next frame
   Wait 1-2 seconds after enabling
   ```

---

### Issue 4: Camera Lock Stuck
**Symptoms**: Can't control camera after disabling

**Solutions**:
1. Toggle camera lock off:
   ```
   Visuals Tab > Camera Lock-On: OFF
   ```

2. Reset camera:
   ```
   Press "Stop All Features" button
   Camera should reset to normal
   ```

3. Manual reset (if needed):
   ```
   Press ESC > Reset Camera option
   ```

---

### Issue 5: FPS Drops
**Symptoms**: Game runs slower with script

**Solutions**:
1. Minimal configuration:
   ```
   ❌ Range Visualizer: OFF
   ❌ Camera Lock-On: OFF
   ❌ Moveset Mimic: OFF
   ✅ Only enable core mimic
   ```

2. Lower graphics settings:
   ```
   Roblox graphics to lower quality
   Close other programs
   ```

3. Reduce prediction:
   ```
   Prediction Factor: 0.05
   Less calculations per frame
   ```

---

## Quick Reference Guide

### Common Configurations

**PvP - Aggressive**:
```
Mimic: ON | Prediction: 0.15 | Anti-Stun: ON | Anti-Ragdoll: ON
Anti-Launch: ON | Lock-On: ON | Moveset: ON | Camera Lock: ON
```

**PvP - Defensive**:
```
Mimic: OFF | Anti-Stun: ON | Anti-Ragdoll: ON | Anti-Launch: ON
Lock-On: ON | Range Viz: ON (50)
```

**Training**:
```
Mimic: ON | Prediction: 0.20 | Moveset: ON | Camera Lock: ON
Anti-Features: OFF
```

**Spectating**:
```
Mimic: ON | Prediction: 0.10 | Camera Lock: ON
All other features: OFF
```

**Maximum Performance**:
```
Mimic: ON | Prediction: 0.15 | Lock-On: ON
All visual features: OFF
```

**AI-Optimized (Recommended)**:
```
Mimic: ON | Enable AI Optimization: ON
Wait 15 seconds | Apply Optimized Settings
Let AI tune for your playstyle
```

---

## Tips & Tricks

1. **Keybind Recommendations**:
   - Quick access to "Stop All" (emergency disable)
   - Toggle anti-stun rapidly in combat
   - Quick camera lock toggle for awareness

2. **Server Selection**:
   - Lower ping servers = smoother mimic
   - Avoid servers with high player count
   - Test in private servers first

3. **Target Selection**:
   - Choose targets at similar skill level
   - Watch their patterns before mimicking
   - Switch targets based on situation

4. **Feature Combinations**:
   - Anti-features work independently
   - Can use lock-on without mimic
   - Range visualizer useful alone

5. **Practice Progression**:
   - Week 1: Basic mimic only
   - Week 2: Add prediction
   - Week 3: Add anti-features
   - Week 4: Full combat configuration

---

## Conclusion

The key to mastering this script is understanding:
- **When** to use each feature
- **How** to combine features effectively
- **Why** certain configurations work better

Experiment with different setups to find what works best for your playstyle!
