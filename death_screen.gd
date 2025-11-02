extends CanvasLayer

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	$ColorRect/Button.pressed.connect(_on_restart_pressed)

func _on_restart_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
