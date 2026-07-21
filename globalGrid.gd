extends Node

const DEFAULT_CELL_SIZE: float = 1.0

var occupied_cells: Dictionary = {}

func world_to_grid(world_pos: Vector3, custom_cell_size: float) -> Vector3:
	var x = round(world_pos.x / custom_cell_size) * custom_cell_size
	var y = round(world_pos.y / custom_cell_size) * custom_cell_size
	var z = round(world_pos.z / custom_cell_size) * custom_cell_size
	return Vector3(x, y, z)

func is_cell_vacant(grid_pos: Vector3) -> bool:
	return not occupied_cells.has(grid_pos)

func register_cell(grid_pos: Vector3, object: Node) -> void:
	occupied_cells[grid_pos] = object

func unregister_cell(grid_pos: Vector3) -> void:
	if occupied_cells.has(grid_pos):
		occupied_cells.erase(grid_pos)
