extends Node3D

@export var world_size: Vector3 = Vector3(16, 16, 16)
@export_range(-1, 1) var cut_off: float = 0.5
@export var colors: Array[Color]

@onready var mesh_instance: MeshInstance3D = $MeshInstance3D

var cubes: int = 0
var data: Dictionary[Vector3, Color] = {}

func _ready() -> void:
	Performance.add_custom_monitor("game/cubes", func(): return cubes)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	var random_generator = FastNoiseLite.new()
	
	var start_time = Time.get_ticks_usec()
	
	for x in range(world_size.x):
		for z in range(world_size.z):
			for y in range(world_size.y):
				var random = random_generator.get_noise_3d(x, y, z)
				if random > cut_off:
					data[Vector3(x, y, z)] = colors[y % colors.size()]
	
	cubes = data.size()
	
	mesh_instance.generate_mesh(data)
		
	var end_time = Time.get_ticks_usec()
	var gen_time = (end_time - start_time) / 1000000.0
	print_debug("Blocks in world: %s\n Gen Time: %s" % [cubes, gen_time])

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
