# Godot PoC — Top-Down Coin Collector (Godot 4.x)

A tiny, clean proof-of-concept showing movement, collisions, timers, UI, signals, and simple spawning in **Godot 4.x** using **GDScript**. Features a complete game loop with mobile support, centralized logging, and automated deployment to GitHub Pages.

## Features
- WASD / Arrow-key movement (`CharacterBody2D`)
- **Mobile/touch controls** with on-screen D-pad for web and mobile platforms
- Coins spawn at intervals and grant score on pickup
- 60-second round timer with "Game Over" overlay
- UI for score and time (`CanvasLayer`)
- **Centralized logging system** with debug/production configuration
- **Automated GitHub Pages deployment** with CI/CD pipeline
- Cross-platform input handling (desktop, mobile, web)
- Lightweight code, no external assets
- Easy to extend (SFX, difficulty scaling, high score, etc.)

## Requirements
- Godot **4.x** (tested with 4.1.4)
- **Desktop** (Windows/macOS/Linux) and **Mobile/Web** fully supported

## Project Layout
```
├── Main.gd / Main.tscn          # Main game controller and scene
├── Player/
│   ├── Player.gd                # Player movement and collision logic
│   └── Player.tscn              # Player scene (CharacterBody2D)
├── Coin/
│   ├── Coin.gd                  # Coin pickup detection
│   └── Coin.tscn                # Coin scene (Area2D)
├── UI/
│   ├── UI.gd                    # UI controller
│   ├── UI.tscn                  # Game UI (score, timer, game over)
│   ├── MobileControls.gd        # Touch controls for mobile/web
│   └── MobileControls.tscn      # Touch screen D-pad
├── Logger.gd                    # Centralized logging singleton
├── exports/web/                 # Web build output directory
│   └── server.py                # Local development server with CORS headers
├── .github/workflows/deploy.yml # GitHub Actions deployment
└── project.godot               # Project configuration with autoloads
```

> **Note:** This project includes all `.tscn` scene files, making it ready to run immediately in Godot.

## Graphics
- [Leprechaun](https://icons8.com/icon/5StxIRWYEKQI/leprechaun) icon by [Icons8](https://icons8.com)
- [Coin](https://icons8.com/icon/OFHwDWASQWmX/coin) icon by [Icons8](https://icons8.com)
---

## Quick Start (1 minute)

### 1) Clone and Open
1. **Clone this repository** to your local machine
2. **Open in Godot** - The project is pre-configured with all scenes and scripts
3. **Press F5** to run immediately!

### 2) Project Configuration
The project comes pre-configured with:
- All scenes (`.tscn`) included and ready
- **Logger autoload** configured for centralized logging
- **Input actions** automatically defined at runtime
- **Mobile controls** automatically shown on touch devices
- **Main scene** already set to `Main.tscn`

### 3) Testing Mobile Controls
To test mobile controls on desktop:
1. Open `UI/MobileControls.gd`
2. Set `DEBUG_SHOW_MOBILE_CONTROLS = true`
3. Run the project - touch controls will appear with colored backgrounds

---

## Controls

### Desktop
- **Move:** WASD or Arrow keys
- **Restart after Game Over:** Space or Enter

### Mobile/Web
- **Move:** On-screen D-pad (automatically appears on touch devices)
- **Restart after Game Over:** On-screen restart button

> `Main.gd` ensures input actions exist at runtime, so you don't need to pre-configure Input Map. Mobile controls automatically appear on touch devices or can be force-enabled for testing.

---

## How it works (high level)
- **Player.gd** reads input each physics tick, normalizes direction, sets `velocity`, and clamps the position to the viewport to keep the player on-screen.
- **Coin.gd** is an `Area2D` that emits a `picked` signal when the `player` body enters (simple and fast).
- **Main.gd** is a tiny game loop:
  - Starts timers, spawns coins at intervals, and listens for `picked` to increment the score.
  - Counts down from `game_length_seconds`; when it hits zero, it stops spawning and shows the overlay.
  - Handles **restart** on Space / Enter.
- **UI.gd** updates labels and toggles the overlay.
- **MobileControls.gd** automatically shows touch controls on mobile devices and handles input mapping.
- **Logger.gd** provides centralized logging with automatic debug/production configuration.

---

## Logger System

The project includes a centralized logging system (`Logger.gd`) configured as an autoload singleton.

### Features
- **Auto-configuration**: Debug builds show all logs; production builds are less verbose
- **Multiple log levels**: DEBUG, INFO, WARN, ERROR
- **Flexible output**: Console and optional file logging
- **Categorized logging**: Built-in categories for GAME, UI, INPUT, SYSTEM

### Usage Examples
```gdscript
# General logging
Logger.info("GAME", "Game started")
Logger.debug("UI", "Button pressed")
Logger.warn("SYSTEM", "Low memory warning")
Logger.error("INPUT", "Invalid input detected")

# Convenience methods
Logger.game_info("Score updated: %d" % score)
Logger.ui_debug("Mobile controls visible: %s" % visible)
Logger.input_debug("Action pressed: %s" % action_name)
Logger.system_info("Platform: %s" % OS.get_name())
```

### Configuration
- **File logging**: Set `Logger.log_to_file = true` in `_ready()` to enable
- **Log level**: Automatically set based on `OS.is_debug_build()`
- **Log file location**: `user://game.log`

---

## Common Pitfalls (and fixes)
- **No pickups happening:**  
  - Ensure **both** Player and Coin have **CollisionShape2D** nodes.  
  - The Player must be in **group `player`** (Node → Groups).  
  - Collision layers/masks are defaults; if you changed them, make sure the Coin’s `Area2D` can detect the Player’s body.
- **Nothing on screen / black window:**  
  - You likely didn’t set `Main.tscn` as **Main Scene**.
- **Can’t move:**  
  - If you removed the `_ensure_actions()` helper in `Main.gd`, add the actions manually in Project Settings → Input Map.

---

## Web Export and Deployment

### GitHub Pages Deployment (Automatic)

This repository includes automated deployment to GitHub Pages via GitHub Actions:

1. **Push to main branch** - Deployment starts automatically
2. **Manual deployment** - Use "Actions" → "Deploy to GitHub Pages" → "Run workflow"
3. **Live demo** - Available at your GitHub Pages URL after deployment

The deployment workflow:
- Uses Godot 4.1.4 headless for building
- Exports to web with Cross-Origin Isolation support
- Includes COI ServiceWorker for GitHub Pages compatibility
- Caches Godot binary and export templates for faster builds

### Local Development

**Exporting in Godot:**
1. **Project → Export → Web**
2. Set **Export Path** to: `exports/web/index.html`
3. **Export**

**Testing locally:**

```bash
cd exports/web
python3 server.py
```

Then visit **http://localhost:8000** in your browser.

> **Note:** Godot 4 web exports require specific headers (Cross-Origin Isolation). The included `server.py` automatically sets these headers. Regular Python `http.server` won't work.

---

## Customize in minutes
- **Change session length:** set `game_length_seconds` in `Main`.
- **Adjust difficulty:** lower `spawn_interval` over time (e.g., every 10 seconds).
- **Add SFX:** drop an `AudioStreamPlayer` in `Main` and play on `_on_coin_picked()`.
- **Juice:** add a pickup animation (scale tween on Coin), camera shake (`Camera2D`), or particle splashes.
- **Save high score:** use `FileAccess.open("user://highscore.save", ...)` and persist an int.
- **Mobile UI customization:** Edit `MobileControls.tscn` to adjust button positions and sizes.
- **Logging customization:** Modify `Logger.gd` to add custom log categories or change output formats.
- **Deploy to your own GitHub Pages:** Fork this repo and GitHub Actions will automatically deploy to your Pages URL.

---

## Turning this into a platformer (quick guide)
- Swap `Player` root to `CharacterBody2D` with gravity and jump:
  - Add `@export var gravity`, `@export var jump_force`, and handle `is_on_floor()` in `_physics_process`.
- Add a **TileMap** for ground with collisions.
- Keep `Coin.tscn` the same (it’ll still detect the player via `body_entered`).

---

## FAQ

- **Why are `.tscn` files included in the repo?**
  This makes the project ready-to-run immediately. All scenes are pre-configured with proper node hierarchies, making it perfect for quick prototyping, game jams, or learning Godot.

- **How do I disable mobile controls on desktop?**
  Mobile controls automatically hide on desktop. If you want to force-hide them, set `visible = false` in `MobileControls.gd` `_ready()`.

- **Can I customize the logging system?**
  Yes! Edit `Logger.gd` to add new log categories, change output formats, or modify the auto-configuration logic.

- **Random spawns look similar across runs.**
  For varied seeds per run, call `randomize()` (or use `RandomNumberGenerator`) once in `_ready()`.

- **How do I deploy to my own GitHub Pages?**
  Fork this repository and enable GitHub Pages in your fork's settings. The workflow will automatically deploy when you push to main.

---

## Contributing
Issues and PRs welcome. Keep things Godot-idiomatic and beginner-friendly.
