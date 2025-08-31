extends CanvasLayer

@onready var score_label: Label = $ScoreLabel
@onready var time_label: Label = $TimeLabel
@onready var overlay: Control = $Overlay

func set_score(score: int) -> void:
    score_label.text = "Score: %d" % score

func set_time(seconds_left: int) -> void:
    time_label.text = "Time: %d" % seconds_left

func show_game_over() -> void:
    overlay.visible = true

func hide_game_over() -> void:
    overlay.visible = false
