Add # Claude Code Configuration

## Project Overview
This is a Godot 4 proof-of-concept game featuring a coin collection mechanic with a player character and UI system.

## Key Project Structure
```
├── Main.gd / Main.tscn          # Main game controller and scene management
├── Player/
│   ├── Player.gd                # Player movement and collision logic
│   └── Player.tscn              # Player scene (CharacterBody2D)
├── Coin/
│   ├── Coin.gd                  # Coin pickup detection
│   └── Coin.tscn                # Coin scene (Area2D)
└── UI/
    ├── UI.gd                    # UI controller
    └── UI.tscn                  # Game UI (score, timer, game over)
```

## Development Commands
Since this is a Godot project, most development happens in the Godot editor. Common tasks:

### Testing
- Open project in Godot editor and press F5 to run
- No automated test suite currently configured

### Code Quality
- No linting/formatting tools currently configured for GDScript
- Godot editor provides built-in syntax checking

## Important Notes

### Scene Architecture
- Player scene root must be CharacterBody2D for proper collision detection
- Player gets added to "player" group for collision identification
- Avoid wrapping player in unnecessary Node2D containers

### Collision System
- Coins use Area2D with body_entered signals for pickup detection
- Player movement uses move_and_slide() with viewport boundary clamping
- Player positioning can be set via global_position property

### Game Systems
- Input actions are programmatically defined for cross-platform compatibility
- Game state managed through timer nodes and signal connections
- Coin spawning uses random viewport positioning with safe margins