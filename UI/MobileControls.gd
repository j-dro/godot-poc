extends Control

# Debug flag to force show mobile controls on desktop for testing
const DEBUG_SHOW_MOBILE_CONTROLS: bool = true

@onready var up_button: TouchScreenButton = $DPad/UpButton
@onready var down_button: TouchScreenButton = $DPad/DownButton
@onready var left_button: TouchScreenButton = $DPad/LeftButton
@onready var right_button: TouchScreenButton = $DPad/RightButton
@onready var restart_button: TouchScreenButton = $RestartButton

func _ready() -> void:
	# Actions are already set in the scene file, no need to override them
	# Just verify they're properly set
	_verify_button_actions()

	# Only show on touch devices or force show for testing
	visible = _is_mobile_device()

	# Ensure TouchScreenButtons are properly configured
	_configure_touch_buttons()

	# Add debug backgrounds to make TouchScreenButtons visible
	_add_button_backgrounds()

	# Connect TouchScreenButton signals for debugging
	_connect_touch_signals()

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

	for i in range(buttons.size()):
		var button = buttons[i]
		if button:
			var background = ColorRect.new()
			background.color = Color.BLUE
			background.color.a = 0.2  # Semi-transparent
			var label = button.get_node("Label")
			label.add_child(background)
			# Allow mouse clicks for testing
			background.mouse_filter = Control.MOUSE_FILTER_PASS
			background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
			
			# Add mouse click detection for desktop testing
			var action = actions[i]
			background.gui_input.connect(_on_debug_button_input.bind(action))

func _verify_button_actions() -> void:
	# Verify that button actions are properly set
	var buttons = [
		["UpButton", up_button, "move_up"],
		["DownButton", down_button, "move_down"],
		["LeftButton", left_button, "move_left"],
		["RightButton", right_button, "move_right"],
		["RestartButton", restart_button, "restart"]
	]

	for button_info in buttons:
		var button_name = button_info[0]
		var button = button_info[1]
		var expected_action = button_info[2]
		if button and button.action != expected_action:
			button.action = expected_action
			Logger.ui_debug("Fixed %s action to %s" % [button_name, expected_action])

func _configure_touch_buttons() -> void:
	# Ensure TouchScreenButtons are properly configured for mobile
	var buttons = [up_button, down_button, left_button, right_button, restart_button]

	for button in buttons:
		if button:
			# Ensure buttons are visible and enabled
			button.visible = true
			button.modulate.a = 1.0
			# Enable passthrough to prevent blocking other input
			button.passby_press = false
			# Ensure the button is properly set up for touch input
			button.process_mode = Node.PROCESS_MODE_INHERIT

func _connect_touch_signals() -> void:
	# Connect touch signals for debugging
	var buttons = [
		[up_button, "move_up"],
		[down_button, "move_down"],
		[left_button, "move_left"],
		[right_button, "move_right"],
		[restart_button, "restart"]
	]

	for button_data in buttons:
		var button = button_data[0]
		var action_name = button_data[1]
		if button:
			button.pressed.connect(_on_touch_pressed.bind(action_name))
			button.released.connect(_on_touch_released.bind(action_name))

func _on_touch_pressed(action: String) -> void:
	Logger.input_debug("Touch pressed: %s" % action)

func _on_touch_released(action: String) -> void:
	Logger.input_debug("Touch released: %s" % action)

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
