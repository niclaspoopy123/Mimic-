# ⚡ Optimized TSB Mimic Script

The fastest and most feature-rich mimic script for The Strongest Battlegrounds (TSB) on Roblox. Designed for **maximum performance** with minimal latency and efficient execution.

## 🚀 Features

### Core Mimic System
- **⚡ Ultra-Fast Mimic**: Runs on RenderStepped for frame-perfect synchronization
- **🔮 Kinematic Prediction**: Advanced prediction using velocity and acceleration
- **🎯 Position & Rotation Sync**: Perfect CFrame matching with target
- **💨 Velocity Sync**: Smooth physics synchronization
- **🦘 Jump Sync**: Automatic jump state matching

### Combat Features
- **🛡️ Anti-Stun**: Prevents stun states in combat
- **🛡️ Anti-Ragdoll**: Prevents ragdoll physics effects
- **🛡️ Anti-Launch**: Prevents being knocked back or launched
- **🎯 Lock-On**: Smooth target tracking and rotation locking
- **🥊 Moveset Mimic**: Replicates target's combat animations and moves

### Visual Features
- **📷 Camera Lock-On**: Camera automatically tracks target
- **📊 Range Visualizer**: Visual indicator of attack range (customizable)
- **🎨 Color-Coded Range**: Green when in range, red when out of range

### Performance Optimizations
- **⚡ Cached References**: All frequently accessed objects are cached
- **🔄 Minimal Computations**: Reduced overhead with efficient algorithms
- **📈 RenderStepped/Heartbeat**: Uses appropriate update loops for each feature
- **💾 State Management**: Centralized state system for fast access
- **🎯 Optimized Predictions**: Reuses calculations across frames
- **🧠 Neural Network Optimizer**: AI-powered automatic parameter tuning for optimal performance

## 📦 Installation

```lua
-- Load the script
loadstring(game:HttpGet('https://raw.githubusercontent.com/niclaspoopy123/Mimic-/main/Main'))()
```

## 🎮 Usage

### Quick Start
1. **Select Target**: Click "Select Target" button, then click on any player
2. **Start Mimic**: Toggle "Start Mimic" to begin mimicking
3. **Enable Features**: Toggle any combat or visual features as needed

### Main Controls
- **🎯 Select Target**: Click to enter target selection mode
- **⚡ Start Mimic**: Toggle to start/stop mimicking
- **🔮 Prediction**: Enable kinematic prediction for better accuracy
- **Prediction Factor**: Adjust prediction strength (0-0.5)

### Combat Features
- **Anti-Stun**: Automatically prevents stun states
- **Anti-Ragdoll**: Keeps your character from ragdolling
- **Anti-Launch**: Prevents knockback and launches
- **Lock-On**: Maintains rotation locked to target
- **Moveset Mimic**: Copies target's combat moves

### Visual Features
- **Camera Lock-On**: Camera follows target automatically
- **Range Visualizer**: Shows attack range circle
- **Range Distance**: Adjust visualizer size (10-100 studs)

### Enhanced Deep Neural Network Optimizer
- **AI Optimization**: Enable automatic data collection and analysis
- **Deep Learning**: 4-layer architecture (4→8→8→4→3) with 50 training epochs
- **Pre-trained Network**: Trained on 100 simulated samples for immediate accuracy
- **Apply Optimized Settings**: Apply deep learning-recommended settings for maximum performance
- **Real-time Scoring**: Monitor performance score and training loss during gameplay

## ⚙️ Technical Details

### Neural Network Architecture
The script includes an enhanced deep feedforward neural network for automatic parameter optimization:
- **Architecture**: 4-layer deep network (Input: 4, Hidden1: 8, Hidden2: 8, Hidden3: 4, Output: 3)
- **Inputs**: Prediction factor, range distance, lock-on state, current FPS
- **Outputs**: Optimal prediction factor, optimal range, optimal lock-on state
- **Activation Functions**: 
  - LeakyReLU for hidden layers 1 and 3 (prevents dying neurons)
  - Tanh for hidden layer 2 (improved gradient flow)
  - Sigmoid for output layer (normalization)
- **Weight Initialization**: He initialization for ReLU layers, Xavier for sigmoid output
- **Training**: 50 epochs with backpropagation on 100 simulated samples
- **Performance Scoring**: Combines FPS, target distance, and lock-on accuracy
- **Sample Collection**: Gathers 20 samples at 2-second intervals
- **Minimal Overhead**: ~0.1ms per optimization cycle

### Performance Features
- **Cached Services**: All Roblox services cached at startup
- **Cached Player Data**: Character, HRP, and Humanoid references cached
- **Efficient Loops**: Uses RenderStepped for real-time updates
- **Minimal Allocations**: Reuses Vector3 and CFrame calculations
- **Optimized State Checks**: Fast boolean checks for feature toggles

### Prediction Algorithm
```
Predicted Position = Current Position + Velocity × Time + 0.5 × Acceleration × Time²
```

### Update Rates
- **Mimic Core**: RenderStepped (~60 FPS)
- **Anti-Stun/Ragdoll/Launch**: Heartbeat (~60 FPS)
- **Lock-On**: RenderStepped for smooth rotation
- **Camera Lock**: RenderStepped for smooth camera movement
- **Range Visualizer**: Heartbeat for efficient updates

## 🎨 UI Library

Uses **Rayfield UI Library** for a modern, clean interface with:
- Smooth animations
- Dark theme
- Easy-to-use toggles and sliders
- Notifications for feedback
- Configuration saving

## 🔧 Configuration

Settings are automatically saved using Rayfield's configuration system in:
- File: `TSBMimicOptimized.json`
- All toggles and sliders save automatically

## ⚠️ Important Notes

1. **Target Selection**: Must select a valid target before starting mimic
2. **Anti Features**: Can be used independently of mimic
3. **Performance**: Script is optimized but may impact FPS on low-end devices
4. **Respawn**: All features automatically stop on character respawn

## 🎯 Best Practices

1. **Enable Anti-Features First**: Turn on anti-stun/ragdoll/launch before combat
2. **Use Prediction**: Keep prediction enabled for better accuracy
3. **Adjust Prediction Factor**: Lower for close combat (0.1), higher for ranged (0.3)
4. **Lock-On for Combat**: Enable lock-on when engaging in direct combat
5. **Camera Lock**: Use during combat for better target tracking

## 🐛 Troubleshooting

**Script not working?**
- Ensure you're in The Strongest Battlegrounds
- Try re-executing the script
- Make sure target is valid (has Humanoid)

**Mimic not starting?**
- Select a target first
- Ensure target character exists
- Check if you have a character spawned

**Neural Network Optimizer?**
- See detailed guide: [NEURAL_NETWORK.md](NEURAL_NETWORK.md)
- Enhanced with 4-layer deep architecture (4→8→8→4→3)
- Pre-trained on 100 simulated samples with 50 training epochs
- Requires at least 5 samples before applying (10 recommended)
- Works best with stable FPS and active target

**Performance issues?**
- Disable range visualizer if FPS drops
- Reduce prediction factor
- Disable unused features

## 📝 Credits

Created by the Optimized Performance Team
- Maximum speed optimization
- Feature-rich design
- Modern UI implementation

## 📄 License

This script is provided as-is for educational purposes.
