extends Node3D

@export var world_size: Vector3 = Vector3(32, 32, 32)
@export_range(-1, 1) var cut_off: float = 0.5
@export var colors: Array[Color]

@onready var chunk: Chunk = $Chunk

var cubes: int = 0
var data: Dictionary[Vector3, Color] = {}

func _ready() -> void:
	Performance.add_custom_monitor("game/cubes", func(): return data.keys().size())
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	var random_noise = FastNoiseLite.new()
	random_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	random_noise.frequency = 0.003
	
	var start_time = Time.get_ticks_usec()
	
	chunk.generate_data(int(world_size.x), int(world_size.y), random_noise, colors)
	chunk.generate_mesh()
		
	var end_time = Time.get_ticks_usec()
	var gen_time = (end_time - start_time) / 1000000.0
	print_debug("Blocks in world: %s\n Gen Time: %s" % [data.keys().size(), gen_time])

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
