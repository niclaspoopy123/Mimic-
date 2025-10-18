# 🧠 Neural Network Optimization Guide

## Overview

The Neural Network Optimizer is an AI-powered feature that automatically tunes your mimic script settings for optimal performance. It uses a lightweight feedforward neural network to analyze gameplay performance and recommend the best parameter values.

## How It Works

### Architecture

The optimizer uses a 3-layer feedforward neural network:

```
Input Layer (4 nodes)
    ↓
Hidden Layer (6 nodes, ReLU activation)
    ↓
Output Layer (3 nodes, Sigmoid activation)
```

### Input Features
1. **Prediction Factor** (0-0.5, normalized to 0-1)
2. **Range Distance** (10-100, normalized to 0-1)
3. **Lock-On State** (0 or 1)
4. **Current FPS** (normalized to 60 FPS baseline)

### Output Predictions
1. **Optimal Prediction Factor** (0-0.5)
2. **Optimal Range Distance** (10-100)
3. **Optimal Lock-On State** (enabled/disabled)

### Performance Scoring

The neural network evaluates performance using a composite score (0-100):

#### FPS Component (40 points)
```lua
score += min(currentFPS / 60, 1) * 40
```
- Rewards smooth gameplay (60 FPS or higher)
- Penalizes performance drops

#### Distance Component (50 points)
```lua
if in_range:
    score += 30  // In range bonus
    score += (1 - distance/rangeDistance) * 20  // Closer is better
else:
    score += max(0, 20 - (distance - rangeDistance) / 10)  // Out of range penalty
```
- Rewards being within attack range
- Rewards closer proximity to target
- Penalizes being far from target

#### Lock-On Accuracy (10 points)
```lua
if lockOn:
    alignment = direction.Dot(forward)
    score += max(0, alignment) * 10
```
- Rewards accurate rotation alignment with target
- Only applies when lock-on is enabled

## Usage Guide

### Step 1: Enable Data Collection

1. Navigate to the **⚙️ Settings** tab
2. Locate the **🧠 Neural Network Optimizer** section
3. Toggle **🤖 Enable AI Optimization** to ON

The system will now begin collecting performance samples every 2 seconds.

### Step 2: Collect Samples

**Minimum Required**: 5 samples (10 seconds)
**Recommended**: 10-20 samples (20-40 seconds)

During collection:
- Play normally with your current settings
- Engage with your target
- Try different combat scenarios
- The status label shows: `Collecting data (X/20 samples) | Score: XX.X`

### Step 3: Apply Optimized Settings

1. Wait until at least 5 samples are collected
2. Click **✨ Apply Optimized Settings** button
3. Settings are automatically applied:
   - Prediction Factor updated
   - Range Distance updated
   - Sliders reflect new values

You'll see a notification showing:
```
Optimization Applied
Prediction: 0.XX | Range: XX | Score: XX.X
```

### Step 4: Verify Improvements

- Monitor the performance score
- Check if gameplay feels smoother
- Re-optimize if needed for different scenarios

## Best Practices

### When to Use Optimization

✅ **Good Times to Optimize**:
- After initial script setup
- When experiencing FPS drops
- When changing playstyle (aggressive ↔ defensive)
- After enabling/disabling major features
- When switching to different target types

❌ **Avoid Optimizing**:
- During lag spikes or network issues
- With unstable FPS
- In crowded servers
- When settings already feel perfect

### Optimization Strategies

#### Strategy 1: Baseline Optimization
```
1. Start with default settings
2. Enable AI Optimization
3. Play normally for 30 seconds
4. Apply optimized settings
5. Use as new baseline
```

#### Strategy 2: Scenario-Specific Tuning
```
1. Set up for specific scenario (PvP, training, etc.)
2. Enable AI Optimization
3. Play in that scenario for 20-40 seconds
4. Apply settings
5. Repeat for different scenarios
```

#### Strategy 3: Iterative Refinement
```
1. Apply AI optimization
2. Manually tweak settings slightly
3. Re-run optimization
4. Compare scores
5. Keep higher-scoring configuration
```

### Tips for Best Results

1. **Stable Environment**
   - Use servers with good connection
   - Avoid crowded areas during collection
   - Wait for FPS to stabilize before starting

2. **Representative Gameplay**
   - Engage in typical combat during collection
   - Don't just stand still
   - Mix different distances and movements

3. **Multiple Samples**
   - More samples = better optimization
   - Aim for 15-20 samples when possible
   - Discard data collected during lag

4. **Score Monitoring**
   - Higher score = better performance
   - Typical good scores: 70-90
   - Excellent scores: 90-100

## Technical Details

### Neural Network Implementation

#### Weight Initialization
```lua
-- Small random weights (-0.25 to 0.25)
weight[i][j] = (math.random() - 0.5) * 0.5

-- Small biases (-0.05 to 0.05)
bias[i] = (math.random() - 0.5) * 0.1
```

#### Activation Functions
- **ReLU** (Hidden Layer): `max(0, x)` - Fast, prevents vanishing gradients
- **Sigmoid** (Output Layer): `1 / (1 + exp(-x))` - Normalizes outputs to 0-1

#### Forward Pass
```lua
// Hidden layer
hidden[j] = ReLU(sum(input[i] * weight_ih[i][j]) + bias_h[j])

// Output layer
output[k] = Sigmoid(sum(hidden[j] * weight_ho[j][k]) + bias_o[k])
```

### Performance Impact

- **Memory Overhead**: ~2 KB (weights + samples)
- **CPU Overhead**: ~0.05ms per optimization cycle
- **Network Complexity**: 4×6 + 6×3 = 42 total weights + 9 biases = 51 parameters
- **Sample Storage**: 20 samples × 5 values = ~400 bytes

### Sample Collection

```lua
Sample Structure:
{
    inputs: [4 normalized values],
    score: float (0-100)
}

Buffer: Ring buffer, max 20 samples
Collection Rate: Every 2 seconds
Optimization Trigger: Minimum 5 samples
```

## Troubleshooting

### Issue: "Need more samples" message

**Solution**: 
- Wait longer (at least 10 seconds)
- Ensure target is selected
- Verify mimic is running

### Issue: Low performance scores

**Solution**:
- Check FPS (should be stable 50+)
- Verify you're in range of target
- Enable lock-on for better accuracy
- Reduce graphics settings if needed

### Issue: Optimization doesn't improve performance

**Solution**:
- Collect more samples (aim for 20)
- Try different combat scenarios
- Manual tweaking may be needed
- Your current settings might already be optimal

### Issue: Settings feel worse after optimization

**Solution**:
- Collect samples during poor gameplay
- Re-optimize with better conditions
- Manually revert to previous settings
- Try iterative refinement approach

## Advanced Usage

### Custom Scoring

Want to prioritize certain aspects? The scoring formula is in the code:
- **FPS Priority**: 40% of total score
- **Distance Priority**: 50% of total score  
- **Accuracy Priority**: 10% of total score

### Combining with Manual Tuning

Best results come from combining AI optimization with manual refinement:

1. **AI First Approach**:
   ```
   AI Optimize → Test → Minor Manual Tweaks → Done
   ```

2. **Manual First Approach**:
   ```
   Manual Setup → AI Optimize → Compare → Choose Best
   ```

3. **Hybrid Approach**:
   ```
   AI Optimize → Manual Tweak → Re-optimize → Compare Scores
   ```

### Performance Tracking

Monitor these metrics during optimization:
- **Score Trend**: Should increase over time
- **FPS Stability**: Should remain consistent
- **Combat Effectiveness**: Subjective feel

## Comparison: Manual vs AI Optimization

| Aspect | Manual Tuning | AI Optimization |
|--------|---------------|-----------------|
| Time Required | 5-10 minutes | 15-40 seconds |
| Expertise Needed | High | None |
| Optimization Quality | Variable | Consistent |
| Scenario Adaptation | Manual retuning | Automatic |
| Performance Overhead | None | Minimal (~0.05ms) |

## Conclusion

The Neural Network Optimizer provides:
- ✅ Automatic parameter tuning
- ✅ Performance-based optimization
- ✅ Minimal computational overhead
- ✅ Easy-to-use interface
- ✅ Real-time feedback

Use it to quickly find optimal settings for your hardware and playstyle, then fine-tune manually if needed for perfection.

## FAQ

**Q: How often should I re-optimize?**
A: Whenever you change major settings, switch playstyles, or experience performance issues.

**Q: Can I use this without a target?**
A: No, optimization requires a target for distance and alignment calculations.

**Q: Does it work with all features enabled?**
A: Yes, it adapts to whatever features you have active.

**Q: Will it slow down my game?**
A: No, overhead is minimal (~0.05ms per cycle, runs only every 2 seconds).

**Q: Can I disable it after applying settings?**
A: Yes, toggle off "Enable AI Optimization" - settings remain applied.

**Q: What if I don't like the optimized settings?**
A: Simply adjust sliders manually or re-optimize with different conditions.

---

*For more information, see the main documentation files (README.md, TECHNICAL_SPEC.md, PERFORMANCE.md)*
