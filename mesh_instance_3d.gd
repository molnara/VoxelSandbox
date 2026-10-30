extends MeshInstance3D

@export var mat: Material

@onready var collision_shape = $StaticBody3D/CollisionShape3D

var surface_array: Array = []
var vertices = PackedVector3Array()
var normals = PackedVector3Array()
var colors = PackedColorArray()

var cube_vertices: Array[Vector3] = [
	Vector3(-0.5, -0.5, 0.5),
	Vector3(0.5, -0.5, 0.5),
	Vector3(0.5, -0.5, -0.5),
	Vector3(-0.5, -0.5, -0.5),
	Vector3(-0.5, 0.5, 0.5),
	Vector3(0.5, 0.5, 0.5),
	Vector3(0.5, 0.5, -0.5),
	Vector3(-0.5, 0.5, -0.5)
]

enum Face{BOTTOM, FRONT, RIGHT, TOP, LEFT, BACK}

var face_indices: Dictionary[Face, Array] = {
	Face.FRONT: [[0, 4, 5],[0, 5, 1]],
	Face.BACK: [[2, 7, 3],[2, 6, 7]],
	Face.LEFT: [[3, 7, 4],[3, 4, 0]],
	Face.RIGHT: [[1, 5, 6],[1, 6, 2]],
	Face.BOTTOM: [[0, 1, 2],[0, 2, 3]],
	Face.TOP: [[4, 7, 6],[4, 6, 5]]
}

var face_normals: Dictionary[Face, Vector3] = {
	Face.FRONT: Vector3(0, 0, 1),
	Face.BACK: Vector3(0, 0, -1),
	Face.LEFT: Vector3(-1, 0, 0),
	Face.RIGHT: Vector3(1, 0, 0),
	Face.BOTTOM: Vector3(0, -1, 0),
	Face.TOP: Vector3(0, 1, 0)
}

# Used for debugging purposes, to visualize the faces of the mesh with different colors
var face_colors: Dictionary[Face, Color] = {
	Face.BOTTOM: Color.RED,
	Face.FRONT: Color.ORANGE,
	Face.RIGHT: Color.YELLOW,
	Face.TOP: Color.GREEN,
	Face.LEFT: Color.BLUE,
	Face.BACK: Color.PURPLE
}

func _ready() -> void:
	surface_array.resize(Mesh.ARRAY_MAX)

func generate_mesh(data: Dictionary[Vector3, Color]) -> void:
	for pos in data:
		var color = data[pos]
		if not has_neighbour(data, Face.FRONT, pos):
			add_face(Face.FRONT, pos, color)
		if not has_neighbour(data, Face.BACK, pos):
			add_face(Face.BACK, pos, color)
		if not has_neighbour(data, Face.LEFT, pos):
			add_face(Face.LEFT, pos, color)
		if not has_neighbour(data, Face.RIGHT, pos):
			add_face(Face.RIGHT, pos, color)
		if not has_neighbour(data, Face.TOP, pos):
			add_face(Face.TOP, pos, color)
		if not has_neighbour(data, Face.BOTTOM, pos):
			add_face(Face.BOTTOM, pos, color)
		
	commit_mesh()

func has_neighbour(data: Dictionary[Vector3, Color], face: Face, pos: Vector3) -> bool:
	var neighbour_pos = pos + face_normals[face]
	if data.has(neighbour_pos): return true
	return false
	
func add_face(face: Face, pos: Vector3, color: Color) -> void:
		var indices = face_indices[face]
		for triangle in indices:
			for index in triangle:
				vertices.append(cube_vertices[index] + pos)
				normals.append(face_normals[face])
				colors.append(color)
	
func commit_mesh() -> void:
	surface_array[Mesh.ARRAY_VERTEX] = vertices
	surface_array[Mesh.ARRAY_NORMAL] = normals
	surface_array[Mesh.ARRAY_COLOR] = colors

	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)
	mesh.surface_set_material(0, mat)
	
	collision_shape.shape = mesh.create_trimesh_shape()
