extends StaticBody3D


var player
const grid: float = 1.0

func _ready() -> void:
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("player")
	self.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if player && player.rayCast.is_colliding():
		self.visible = true
		var hit = player.rayCast.get_collision_point()
		var normal = player.rayCast.get_collision_normal()
		
		var offset = 0.5
		var newP = hit + (normal * offset)
		
		self.global_position = newP.snapped(Vector3(grid,grid,grid))
	else:
		self.visible = false
