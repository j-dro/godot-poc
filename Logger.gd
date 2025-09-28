extends Node

enum LogLevel {
	DEBUG = 0,
	INFO = 1,
	WARN = 2,
	ERROR = 3
}

# Configuration
var log_level: LogLevel = LogLevel.DEBUG
var log_to_console: bool = true
var log_to_file: bool = false
var log_file_path: String = "user://game.log"

# Log level prefixes for console output
var level_prefixes = {
	LogLevel.DEBUG: "[DEBUG]",
	LogLevel.INFO: "[INFO]",
	LogLevel.WARN: "[WARN]",
	LogLevel.ERROR: "[ERROR]"
}

var log_file: FileAccess

func _ready() -> void:
	# Configure logger based on debug settings
	_configure_logger()

	# Set up file logging if enabled
	if log_to_file:
		_setup_file_logging()

func _configure_logger() -> void:
	# Check if this is a debug/development build
	if OS.is_debug_build():
		log_level = LogLevel.DEBUG
		log_to_console = true
		# Enable file logging for development if desired
		# log_to_file = true
	else:
		# Production settings - less verbose
		log_level = LogLevel.INFO
		log_to_console = true
		log_to_file = false

func _setup_file_logging() -> void:
	log_file = FileAccess.open(log_file_path, FileAccess.WRITE)
	if log_file == null:
		print("Failed to open log file: ", log_file_path)
		log_to_file = false
	else:
		log_file.store_line("=== Game Log Started ===")

func _exit_tree() -> void:
	if log_file:
		log_file.store_line("=== Game Log Ended ===")
		log_file.close()

func _log(level: LogLevel, category: String, message: String) -> void:
	if level < log_level:
		return

	var timestamp = Time.get_datetime_string_from_system()
	var prefix = level_prefixes[level]
	var formatted_message = "%s %s [%s] %s" % [timestamp, prefix, category, message]

	# Console output
	if log_to_console:
		match level:
			LogLevel.ERROR:
				push_error(formatted_message)
			LogLevel.WARN:
				push_warning(formatted_message)
			_:
				print(formatted_message)

	# File output
	if log_to_file and log_file:
		log_file.store_line(formatted_message)
		log_file.flush()

# Public logging methods
func debug(category: String, message: String) -> void:
	_log(LogLevel.DEBUG, category, message)

func info(category: String, message: String) -> void:
	_log(LogLevel.INFO, category, message)

func warn(category: String, message: String) -> void:
	_log(LogLevel.WARN, category, message)

func error(category: String, message: String) -> void:
	_log(LogLevel.ERROR, category, message)

# Convenience methods for common categories
func input_debug(message: String) -> void:
	debug("INPUT", message)

func ui_debug(message: String) -> void:
	debug("UI", message)

func game_info(message: String) -> void:
	info("GAME", message)

func system_info(message: String) -> void:
	info("SYSTEM", message)