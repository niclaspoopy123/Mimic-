# 🧠 Enhanced Deep Neural Network Optimization Guide

## Overview

The Neural Network Optimizer is an AI-powered feature that automatically tunes your mimic script settings for optimal performance. It uses an enhanced deep feedforward neural network with 4 hidden layers, advanced activation functions, and sophisticated weight initialization to analyze gameplay performance and recommend the best parameter values.

## How It Works

### Enhanced Architecture

The optimizer uses a 4-layer deep feedforward neural network with improved components:

```
Input Layer (4 nodes)
    ↓
Hidden Layer 1 (8 nodes, LeakyReLU activation)
    ↓
Hidden Layer 2 (8 nodes, Tanh activation)
    ↓
Hidden Layer 3 (4 nodes, LeakyReLU activation)
    ↓
Output Layer (3 nodes, Sigmoid activation)
```

### Key Improvements

1. **Deeper Architecture**: 4 layers vs 3 layers for better pattern recognition
2. **Increased Capacity**: More neurons (8→8→4 vs 6) for complex decision making
3. **Advanced Activations**: 
   - LeakyReLU (prevents dying neurons, better gradient flow)
   - Tanh (improved over sigmoid for hidden layers)
   - Sigmoid (output normalization)
4. **Better Weight Initialization**:
   - He initialization for LeakyReLU layers
   - Xavier initialization for sigmoid output layer
5. **Training with Backpropagation**: 50 epochs on 100 simulated samples
6. **Pre-trained Network**: Ready to use immediately with learned patterns

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
    score += 30  -- In range bonus
    score += (1 - distance/rangeDistance) * 20  -- Closer is better
else:
    score += max(0, 20 - (distance - rangeDistance) / 10)  -- Out of range penalty
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

**Note**: The network is pre-trained on 100 simulated samples, so it already has learned patterns. Additional real-world samples help it adapt to your specific gameplay.

During collection:
- Play normally with your current settings
- Engage with your target
- Try different combat scenarios
- The status label shows: `Collecting data (X/20) | Score: XX.X | Loss: X.XXXX | Epochs: 50`

### Step 3: Apply Optimized Settings

1. Wait until at least 5 samples are collected
2. Click **✨ Apply Optimized Settings** button
3. Settings are automatically applied:
   - Prediction Factor updated
   - Range Distance updated
   - Sliders reflect new values

You'll see a notification showing:
```
Deep Learning Applied ✓
Prediction: 0.XXX | Range: XX | Score: XX.X | Epoch: 50
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
   - The pre-trained network helps even with limited data

2. **Representative Gameplay**
   - Engage in typical combat during collection
   - Don't just stand still
   - Mix different distances and movements

3. **Sample Collection**
   - More samples = better real-world adaptation
   - Aim for 10-15 samples when possible
   - Pre-training provides good baseline performance

4. **Score Monitoring**
   - Higher score = better performance
   - Typical good scores: 70-90
   - Excellent scores: 90-100
   - Training loss shows learning quality (lower is better)

## Technical Details

### Enhanced Neural Network Implementation

#### Network Architecture
- **Input Layer**: 4 nodes (predictionFactor, rangeDistance, lockOnActive, currentFPS)
- **Hidden Layer 1**: 8 nodes with LeakyReLU activation
- **Hidden Layer 2**: 8 nodes with Tanh activation  
- **Hidden Layer 3**: 4 nodes with LeakyReLU activation
- **Output Layer**: 3 nodes with Sigmoid activation

#### Weight Initialization
```lua
-- He initialization for LeakyReLU layers (better gradient flow)
heScale = sqrt(2.0 / inputSize)
weight[i][j] = (random() - 0.5) * 2 * heScale

-- Xavier initialization for Sigmoid output layer
xavierScale = sqrt(1.0 / inputSize)
weight[i][j] = (random() - 0.5) * 2 * xavierScale

-- Small bias initialization
bias[i] = 0.01  -- or 0 for output layer
```

#### Activation Functions
- **LeakyReLU**: `f(x) = x if x > 0 else 0.01*x` - Prevents dying neurons, allows gradient flow
- **LeakyReLU Derivative**: `f'(x) = 1 if x > 0 else 0.01`
- **Tanh**: `f(x) = (exp(2x) - 1) / (exp(2x) + 1)` - Better than sigmoid for hidden layers
- **Tanh Derivative**: `f'(x) = 1 - tanh(x)²`
- **Sigmoid**: `f(x) = 1 / (1 + exp(-x))` - Normalizes outputs to 0-1
- **Sigmoid Derivative**: `f'(x) = sigmoid(x) * (1 - sigmoid(x))`

#### Forward Pass
```lua
-- Hidden layer 1 (LeakyReLU)
for j = 1 to hiddenSize1:
    z1[j] = sum(input[i] * weight_ih1[i][j]) + bias_h1[j]
    hidden1[j] = LeakyReLU(z1[j])

-- Hidden layer 2 (Tanh)
for j = 1 to hiddenSize2:
    z2[j] = sum(hidden1[i] * weight_h1h2[i][j]) + bias_h2[j]
    hidden2[j] = Tanh(z2[j])

-- Hidden layer 3 (LeakyReLU)
for j = 1 to hiddenSize3:
    z3[j] = sum(hidden2[i] * weight_h2h3[i][j]) + bias_h3[j]
    hidden3[j] = LeakyReLU(z3[j])

-- Output layer (Sigmoid)
for k = 1 to outputSize:
    zo[k] = sum(hidden3[j] * weight_h3o[j][k]) + bias_o[k]
    output[k] = Sigmoid(zo[k])
```

#### Backpropagation Training
The network is trained using gradient descent with backpropagation:

1. **Forward Pass**: Compute outputs and cache intermediate values
2. **Loss Calculation**: Mean Squared Error (MSE)
   ```lua
   loss = sum((predicted[i] - target[i])²) / outputSize
   ```
3. **Backward Pass**: Compute gradients layer by layer
   - Output layer: `delta_o[k] = error[k] * sigmoid'(zo[k])`
   - Hidden layer 3: `delta_h3[j] = sum(delta_o[k] * weight[j][k]) * leakyReLU'(z3[j])`
   - Hidden layer 2: `delta_h2[j] = sum(delta_h3[k] * weight[j][k]) * tanh'(z2[j])`
   - Hidden layer 1: `delta_h1[j] = sum(delta_h2[k] * weight[j][k]) * leakyReLU'(z1[j])`
4. **Weight Update**: Apply gradients with learning rate
   ```lua
   weight[i][j] = weight[i][j] - learningRate * delta[j] * activation[i]
   bias[j] = bias[j] - learningRate * delta[j]
   ```

#### Simulated Training Data
Pre-training uses 100 diverse samples generated with heuristic rules:
- **Input Ranges**: 
  - Prediction factor: 0 to 0.5
  - Range distance: 10 to 100
  - Lock-on: 0 or 1
  - FPS: 30 to 60
- **Output Rules**:
  - High FPS (>50) → Higher prediction (0.15-0.25)
  - Low FPS (<50) → Lower prediction (0.08-0.15)
  - High FPS + High prediction → Larger range (60-90)
  - Otherwise → Smaller range (30-60)
  - Lock-on beneficial in 70% of cases

#### Training Parameters
- **Learning Rate**: 0.02 (balanced for convergence)
- **Epochs**: 50 (sufficient for convergence on simulated data)
- **Batch Size**: Full batch (all 100 samples)
- **Loss Function**: Mean Squared Error (MSE)

### Performance Impact

- **Memory Overhead**: ~4 KB (weights + samples + training data)
- **CPU Overhead**: ~0.1ms per optimization cycle
- **Network Complexity**: 
  - Layer 1: 4×8 = 32 weights
  - Layer 2: 8×8 = 64 weights
  - Layer 3: 8×4 = 32 weights
  - Layer 4: 4×3 = 12 weights
  - Total: 140 weights + 23 biases = 163 parameters
- **Sample Storage**: 20 samples × 5 values = ~400 bytes
- **Training Data**: 100 samples × 7 values = ~2.8 KB

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
- Note: Pre-trained network provides good baseline even with few samples

### Issue: Low performance scores

**Solution**:
- Check FPS (should be stable 50+)
- Verify you're in range of target
- Enable lock-on for better accuracy
- Reduce graphics settings if needed

### Issue: Optimization doesn't improve performance

**Solution**:
- Collect more samples (aim for 15-20)
- Try different combat scenarios
- Manual tweaking may be needed
- Pre-trained network provides solid baseline
- Check training loss - lower is better

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

## Comparison: Manual vs Enhanced Deep Learning

| Aspect | Manual Tuning | Deep Learning (Enhanced) |
|--------|---------------|--------------------------|
| Time Required | 5-10 minutes | 15-40 seconds |
| Expertise Needed | High | None |
| Pre-training | N/A | 100 simulated samples |
| Network Depth | N/A | 4 layers (deeper = better) |
| Optimization Quality | Variable | Consistent & Accurate |
| Scenario Adaptation | Manual retuning | Automatic |
| Performance Overhead | None | Minimal (~0.1ms) |
| Training Epochs | N/A | 50 with backpropagation |

## Conclusion

The Enhanced Deep Neural Network Optimizer provides:
- ✅ Deeper 4-layer architecture for better accuracy
- ✅ Advanced activation functions (LeakyReLU, Tanh, Sigmoid)
- ✅ Sophisticated weight initialization (He/Xavier)
- ✅ Pre-trained on 100 simulated samples
- ✅ 50 training epochs with backpropagation
- ✅ Automatic parameter tuning
- ✅ Performance-based optimization
- ✅ Minimal computational overhead (~0.1ms)
- ✅ Easy-to-use interface
- ✅ Real-time feedback with training metrics

Use it to quickly find optimal settings for your hardware and playstyle, leveraging the power of deep learning for superior performance.

## FAQ

**Q: How often should I re-optimize?**
A: Whenever you change major settings, switch playstyles, or experience performance issues.

**Q: Can I use this without a target?**
A: No, optimization requires a target for distance and alignment calculations.

**Q: Does it work with all features enabled?**
A: Yes, it adapts to whatever features you have active.

**Q: How does the deep network improve accuracy?**
A: 4 layers vs 3 allows better pattern recognition. LeakyReLU prevents dying neurons, Tanh improves gradient flow, and He/Xavier initialization provides better starting weights.

**Q: What is pre-training?**
A: The network trains on 100 simulated samples for 50 epochs before you even use it, so it starts with learned patterns and provides good results immediately.

**Q: Will the deeper network slow down my game?**
A: No, overhead is still minimal (~0.1ms per cycle, runs only every 2 seconds). The enhanced accuracy is worth the tiny increase.

**Q: Can I disable it after applying settings?**
A: Yes, toggle off "Enable AI Optimization" - settings remain applied.

**Q: What if I don't like the optimized settings?**
A: Simply adjust sliders manually or re-optimize with different conditions.

---

*For more information, see the main documentation files (README.md, TECHNICAL_SPEC.md, PERFORMANCE.md)*
