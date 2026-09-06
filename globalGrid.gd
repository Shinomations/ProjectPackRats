extends Node

const DEFAULT_CELL_SIZE: float = 1.0


func world_to_grid(world_pos: Vector3, custom_cell_size: float) -> Vector3:
	var x = round(world_pos.x / custom_cell_size) * custom_cell_size
	var y = round(world_pos.y / custom_cell_size) * custom_cell_size
	var z = round(world_pos.z / custom_cell_size) * custom_cell_size
	return Vector3(x, y, z)
