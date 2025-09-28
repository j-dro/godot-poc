extends Control

# Debug flag to force show mobile controls on desktop for testing
const DEBUG_SHOW_MOBILE_CONTROLS = false

@onready var up_button: TouchScreenButton = $DPad/UpButton
@onready var down_button: TouchScreenButton = $DPad/DownButton
@onready var left_button: TouchScreenButton = $DPad/LeftButton
@onready var right_button: TouchScreenButton = $DPad/RightButton
@onready var restart_button: TouchScreenButton = $RestartButton

func _ready() -> void:
	# Configure D-pad buttons
	up_button.action = "move_up"
	down_button.action = "move_down"
	left_button.action = "move_left"
	right_button.action = "move_right"
	restart_button.action = "restart"

	# Only show on touch devices or force show for testing
	visible = _is_mobile_device()

	# Add debug backgrounds to make TouchScreenButtons visible
	if DEBUG_SHOW_MOBILE_CONTROLS:
		_add_button_backgrounds()

	# Log mobile controls initialization
	Logger.ui_debug("MobileControls visible: %s" % visible)
	Logger.ui_debug("Is mobile device: %s" % _is_mobile_device())
	Logger.ui_debug("MobileControls position: %s, size: %s" % [position, size])
	Logger.system_info("Viewport size: %s" % get_viewport().get_visible_rect().size)

	# Log button status
	var buttons = [
		["UpButton", up_button],
		["DownButton", down_button],
		["LeftButton", left_button],
		["RightButton", right_button],
		["RestartButton", restart_button]
	]

	for button_info in buttons:
		var button_name = button_info[0]
		var button = button_info[1]
		if button:
			Logger.ui_debug("%s global_position: %s, visible: %s" % [button_name, button.global_position, button.visible])
		else:
			Logger.error("UI", "%s is null!" % button_name)

func _is_mobile_device() -> bool:
	# Check if we're running on a mobile platform or web with touch
	if DEBUG_SHOW_MOBILE_CONTROLS:
		return true
	return OS.has_feature("mobile") or OS.has_feature("web")

func _add_button_backgrounds() -> void:
	# Add colored backgrounds to make TouchScreenButtons visible for testing
	var buttons = [up_button, down_button, left_button, right_button, restart_button]
	var actions = ["move_up", "move_down", "move_left", "move_right", "restart"]
	var colors = [Color.RED, Color.BLUE, Color.GREEN, Color.YELLOW, Color.PURPLE]

	for i in range(buttons.size()):
		var button = buttons[i]
		if button:
			var background = ColorRect.new()
			background.color = colors[i]
			background.color.a = 0.5  # Semi-transparent
			button.add_child(background)
			# Allow mouse clicks for testing
			background.mouse_filter = Control.MOUSE_FILTER_PASS
			background.size = Vector2(40, 40)
			background.position = Vector2.ZERO

			# Add mouse click detection for desktop testing
			var action = actions[i]
			background.gui_input.connect(_on_debug_button_input.bind(action))

func _on_debug_button_input(event: InputEvent, action: String) -> void:
	# Handle mouse clicks for desktop testing
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			# Simulate the action press
			Input.action_press(action)
			Logger.input_debug("Pressed %s" % action)
	elif event is InputEventMouseButton and not event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			# Simulate the action release
			Input.action_release(action)
			Logger.input_debug("Released %s" % action)
