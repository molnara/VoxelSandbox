extends Node3D

@onready var chunk: Chunk = $Chunk
var data: Dictionary[Vector3, Color] = {}

func _ready() -> void:
	#get_viewport().debug_draw = Viewport.DEBUG_DRAW_WIREFRAME
	Performance.add_custom_monitor("game/cubes", func(): return data.keys().size())
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
