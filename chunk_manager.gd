class_name ChunkManager extends Node

@export var colors: Array[Color] = []
@export var dimensions: Vector3 = Vector3(128, 64, 128)
@export var chunk_size: int = 32
@export var noise_seed: int = 0

var random = FastNoiseLite.new()
var number_of_chunks: Vector3

var loading_threads: Array[Thread] = [Thread.new(), Thread.new(), Thread.new(), Thread.new()]

var chunk_class = preload("res://chunk.tscn")
	
func _ready() -> void:
	random.noise_type = FastNoiseLite.TYPE_SIMPLEX
	random.frequency = 0.003
	random.seed = noise_seed;
	
	number_of_chunks = dimensions / chunk_size
	
	loading_threads[0].start(generate_chunks.bind(Vector3(0, 0, 0)))
	loading_threads[1].start(generate_chunks.bind(Vector3(dimensions.x / 2, 0, 0)))
	loading_threads[2].start(generate_chunks.bind(Vector3(0, 0, dimensions.z /2)))
	loading_threads[3].start(generate_chunks.bind(Vector3(dimensions.x / 2, 0, dimensions.z /2)))

func generate_chunks(pos: Vector3) -> void:
	var chunks: Vector3 = number_of_chunks / 2;
	for x in range(chunks.x):
		for z in range(chunks.z):
			for y in range(number_of_chunks.y):
				var new_chunk = chunk_class.instantiate()
				new_chunk.position = Vector3(x, y, z) * chunk_size + pos
				new_chunk.generate_data(chunk_size, int(dimensions.y), random, colors)
				new_chunk.generate_mesh()
				call_deferred("add_child", new_chunk)

func _exit_tree() -> void:
	for thread in loading_threads:
		thread.wait_to_finish()
