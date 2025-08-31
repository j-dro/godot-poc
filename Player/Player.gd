extends CharacterBody2D

@export var speed: float = 260.0

func _physics_process(delta: float) -> void:
    var dir := Vector2.ZERO
    dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
    dir.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
    if dir.length_squared() > 0:
        dir = dir.normalized()
    velocity = dir * speed
    move_and_slide()
    _clamp_to_viewport()

func _clamp_to_viewport() -> void:
    var rect := get_viewport_rect()
    var margin := 12.0
    global_position.x = clamp(global_position.x, rect.position.x + margin, rect.size.x - margin)
    global_position.y = clamp(global_position.y, rect.position.y + margin, rect.size.y - margin)
