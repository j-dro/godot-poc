# Godot PoC — Top-Down Coin Collector (Godot 4.x)

A tiny, clean proof-of-concept showing movement, collisions, timers, UI, signals, and simple spawning in **Godot 4.x** using **GDScript**. Great as a starting point for jams or tutorials.

## Features
- WASD / Arrow-key movement (`CharacterBody2D`)
- Coins spawn at intervals and grant score on pickup
- 60-second round timer with “Game Over” overlay
- UI for score and time (`CanvasLayer`)
- Lightweight code, no external assets
- Easy to extend (SFX, difficulty scaling, high score, etc.)

## Requirements
- Godot **4.x** (any recent stable)
- Desktop (Windows/macOS/Linux). Mobile works with minor input tweaks.

## Project Layout (files in this repo)
```
Main.gd
Player/Player.gd
Coin/Coin.gd
UI/UI.gd
.gitignore
README.md
```
> Scenes (`.tscn`) are created in the editor following the steps below. Keeping scenes editor-made makes it easier to tweak in Godot.

---

## Quick Start (5–10 minutes)

### 1) Create **Player.tscn**
1. New Scene → **CharacterBody2D** (name it `Player`).
2. Add **CollisionShape2D** → **CircleShape2D** with radius ~10.
3. Add a simple visual (e.g., **Sprite2D** or **ColorRect** ~20×20).
4. **Attach script**: `Player/Player.gd`.
5. Node → **Groups** → add to group: `player`.

### 2) Create **Coin.tscn**
1. New Scene → **Area2D** (name it `Coin`).
2. Add **CollisionShape2D** → **CircleShape2D** radius ~8.
3. Add a small visual (Sprite2D/ColorRect ~16×16).
4. **Attach script**: `Coin/Coin.gd`.
   - Script connects `body_entered` in `_ready()`, so no manual signal wiring needed.

### 3) Create **UI.tscn**
1. New Scene → **CanvasLayer** (name it `UI`).
2. Add two **Label** nodes: `ScoreLabel` (top-left), `TimeLabel` (top-right).
3. Add a **Control** called `Overlay` (anchors full rect), with a centered Label:
   - Text: “Game Over — Press Space”
   - Set `Overlay.visible = false` initially.
4. **Attach script**: `UI/UI.gd`.

### 4) Create **Main.tscn**
1. New Scene → **Node2D** (root; name it `Main`).
2. Add child **Node2D** named `World`.
3. Instance `Player.tscn` under `World`.
4. Instance `UI.tscn` under root (same level as `World`).
5. Add **Timer** called `GameTimer` (one-shot: false, wait_time: 1.0).
6. Add **Timer** called `SpawnTimer` (one-shot: false, wait_time: 0.75).
7. **Attach script**: `Main.gd`.
8. In the Inspector (root `Main` selected), set:
   - `coin_scene` → **res://Coin/Coin.tscn**
   - Optional: tweak `game_length_seconds`, `spawn_interval`, `spawn_margin`.

### 5) Make it the main scene
- Project → **Project Settings** → **Application → Run → Main Scene** → select `Main.tscn`.
- Press **F5** to run.

---

## Controls
- **Move:** WASD or Arrow keys  
- **Restart after Game Over:** Space or Enter

> `Main.gd` ensures the input actions exist at runtime, so you don’t need to pre-configure Input Map.

---

## How it works (high level)
- **Player.gd** reads input each physics tick, normalizes direction, sets `velocity`, and clamps the position to the viewport to keep the player on-screen.
- **Coin.gd** is an `Area2D` that emits a `picked` signal when the `player` body enters (simple and fast).
- **Main.gd** is a tiny game loop:
  - Starts timers, spawns coins at intervals, and listens for `picked` to increment the score.
  - Counts down from `game_length_seconds`; when it hits zero, it stops spawning and shows the overlay.
  - Handles **restart** on Space / Enter.
- **UI.gd** updates labels and toggles the overlay.

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

## Customize in minutes
- **Change session length:** set `game_length_seconds` in `Main`.
- **Adjust difficulty:** lower `spawn_interval` over time (e.g., every 10 seconds).
- **Add SFX:** drop an `AudioStreamPlayer` in `Main` and play on `_on_coin_picked()`.
- **Juice:** add a pickup animation (scale tween on Coin), camera shake (`Camera2D`), or particle splashes.
- **Save high score:** use `FileAccess.open("user://highscore.save", ...)` and persist an int.

---

## Turning this into a platformer (quick guide)
- Swap `Player` root to `CharacterBody2D` with gravity and jump:
  - Add `@export var gravity`, `@export var jump_force`, and handle `is_on_floor()` in `_physics_process`.
- Add a **TileMap** for ground with collisions.
- Keep `Coin.tscn` the same (it’ll still detect the player via `body_entered`).

---

## FAQ
- **Why no `.tscn` files in the repo?**  
  The PoC focuses on code clarity. Building scenes in the editor keeps node paths valid and encourages you to learn the Godot node tree. The steps above create all scenes in a few minutes.
- **Random spawns look similar across runs.**  
  For varied seeds per run, call `randomize()` (or use `RandomNumberGenerator`) once in `_ready()`.

---

## Contributing
Issues and PRs welcome. Keep things Godot-idiomatic and beginner-friendly.
