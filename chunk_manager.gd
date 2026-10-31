class_name ChunkManager extends Node

@export var colors: Array[Color] = []
@export var dimensions: Vector3 = Vector3(128, 64, 128)
@export var chunk_size: int = 32
@export var noise_seed: int = 0

var random = FastNoiseLite.new()
var number_of_chunks: Vector3

var chunk_class = preload("res://chunk.tscn")
	
func _ready() -> void:
	random.noise_type = FastNoiseLite.TYPE_SIMPLEX
	random.frequency = 0.003
	random.seed = noise_seed;
	
	number_of_chunks = dimensions / chunk_size
	
	generate_chunks()

func generate_chunks() -> void:
	for x in range(number_of_chunks.x):
		for z in range(number_of_chunks.z):
			for y in range(number_of_chunks.y):
				var new_chunk = chunk_class.instantiate()
				new_chunk.position = Vector3(x, y, z) * chunk_size
				add_child(new_chunk)
				new_chunk.generate_data(chunk_size, int(dimensions.y), random, colors)
				new_chunk.generate_mesh()
