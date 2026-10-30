extends Node3D

@export var world_size: Vector3 = Vector3(16, 16, 16)
@onready var default_cube: CSGBox3D = $DefaultCube

func _ready() -> void:
	var random_generator = RandomNumberGenerator.new()
	for x in range(world_size.x):
		for z in range(world_size.z):
			for y in range(world_size.y):
				var random = random_generator.randf()
				if random > 0.5:
					var new_cube = default_cube.duplicate()
					new_cube.position = Vector3(x, y, z)
					add_child(new_cube)
					
	remove_child(default_cube)
