extends Node2D

@export var coin_scene: PackedScene
@export var game_length_seconds: int = 60
@export var spawn_interval: float = 0.75
@export var spawn_margin: float = 24.0

@onready var world: Node2D = $World
@onready var player: Node2D = $World/Player
@onready var ui: CanvasLayer = $UI
@onready var game_timer: Timer = $GameTimer
@onready var spawn_timer: Timer = $SpawnTimer

var score: int = 0
var time_left: int = 0
var state: StringName = &"idle"

func _ready() -> void:
    _ensure_actions()
    ui.hide_game_over()
    player.add_to_group("player")
    time_left = game_length_seconds
    ui.set_score(score)
    ui.set_time(time_left)

    game_timer.wait_time = 1.0
    spawn_timer.wait_time = spawn_interval

    game_timer.timeout.connect(_on_second_tick)
    spawn_timer.timeout.connect(_on_spawn_tick)

    _start_game()

func _start_game() -> void:
    state = &"playing"
    score = 0
    time_left = game_length_seconds
    ui.set_score(score)
    ui.set_time(time_left)
    ui.hide_game_over()
    _clear_all_coins()
    game_timer.start()
    spawn_timer.start()

func _game_over() -> void:
    state = &"gameover"
    game_timer.stop()
    spawn_timer.stop()
    ui.show_game_over()

func _on_second_tick() -> void:
    time_left -= 1
    ui.set_time(time_left)
    if time_left <= 0:
        _game_over()

func _on_spawn_tick() -> void:
    if state != &"playing":
        return
    _spawn_coin()

func _spawn_coin() -> void:
    if coin_scene == null:
        coin_scene = preload("res://Coin/Coin.tscn")
    var coin := coin_scene.instantiate()
    world.add_child(coin)
    coin.global_position = _random_point_in_view()
    coin.picked.connect(_on_coin_picked)

func _on_coin_picked() -> void:
    if state != &"playing":
        return
    score += 1
    ui.set_score(score)

func _input(event: InputEvent) -> void:
    if state == &"gameover" and Input.is_action_just_pressed("restart"):
        _start_game()

func _random_point_in_view() -> Vector2:
    var rect := get_viewport_rect()
    var x := randf_range(rect.position.x + spawn_margin, rect.size.x - spawn_margin)
    var y := randf_range(rect.position.y + spawn_margin, rect.size.y - spawn_margin)
    return Vector2(x, y)

func _clear_all_coins() -> void:
    for c in world.get_children():
        if c is Area2D and c.has_signal("picked"):
            c.queue_free()

func _ensure_actions() -> void:
    var actions = {
        "move_left": [KEY_A, KEY_LEFT],
        "move_right": [KEY_D, KEY_RIGHT],
        "move_up": [KEY_W, KEY_UP],
        "move_down": [KEY_S, KEY_DOWN],
        "restart": [KEY_SPACE, KEY_ENTER]
    }
    for name in actions.keys():
        if not InputMap.has_action(name):
            InputMap.add_action(name)
        for ev in InputMap.action_get_events(name):
            InputMap.action_erase_event(name, ev)
        for sc in actions[name]:
            var ev := InputEventKey.new()
            ev.physical_keycode = sc
            InputMap.action_add_event(name, ev)
