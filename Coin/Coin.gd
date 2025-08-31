extends Area2D
signal picked

func _ready() -> void:
    connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node) -> void:
    if body.is_in_group("player"):
        emit_signal("picked")
        queue_free()
