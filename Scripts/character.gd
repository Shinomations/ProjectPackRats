extends CharacterBody3D

signal interact_object

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.005
@onready var player: CharacterBody3D = $"."

@onready var head = $Head
@onready var cam = $Head/Camera3D
@onready var box_carry_marker: Marker3D = $Head/Camera3D/boxCarryMarker
@onready var rayCast: RayCast3D = $Head/Camera3D/RayCast3D

var pickedObject: Node3D = null
var gravity = (ProjectSettings.get_setting("physics/3d/default_gravity"))
var holdingobject = false
var collider # Stores whatever the raycast is currently looking at
var boxTypeDetector: int
var isFirstPress: bool = true

# Player Stats cache for picked up items
var Name: String
var weight: int
var material: String
var Income: int
var ability: String
var health: int

var cell_size: float = 1.0
var gridPos: Vector3 = Vector3.ZERO
var original_grid_pos: Vector3 = Vector3.ZERO # Tracks where an item came from

func _ready():
	add_to_group("player")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	# Close game
	if event.is_action_pressed("quit"): 
		get_tree().quit()
	
	# Show Mouse Toggle
	if event.is_action_pressed("Freedom"):
		if isFirstPress == true:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			print("Mouse on")
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			print("Mouse off")
		isFirstPress = !isFirstPress
		
	# Movement look
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		cam.rotate_x(-event.relative.y * SENSITIVITY)
		cam.rotation.x = clamp(cam.rotation.x, deg_to_rad(-80), deg_to_rad(85))

func _input(event):
	# Grab / Place Object Interaction
	if event.is_action_pressed("interaction"):	
		if pickedObject != null: # IF HOLDING AN ITEM (TRYING TO DROP/PLACE IT)
			
			if collider is store_object:
				if collider.isEmpty():
					pickedObject.set_collision_layer_value(1, true)
					pickedObject.set_collision_layer_value(3, true)
					if pickedObject is CharacterBody3D:
						pickedObject.freeze = true
					collider.add_object(pickedObject)
					pickedObject = null
					holdingobject = false
				else:
					pickedObject.reparent(get_tree().current_scene)
					pickedObject.set_collision_layer_value(1, true)
					pickedObject.set_collision_layer_value(3, true)
					pickedObject = null
					holdingobject = false
			
			else: # Dynamic Grid System Drop Logic
				if rayCast.is_colliding():
					# Block placement if the target grid coordinates are already occupied
					if not GlobalGrid.is_cell_vacant(gridPos):
						print("Cannot place: Grid position ", gridPos, " is occupied!")
						return 
					
					# Finalize structural drop into grid space
					pickedObject.reparent(get_tree().current_scene)
					pickedObject.global_position = gridPos
					GlobalGrid.register_cell(gridPos, pickedObject)
				else:
					# Fallback drop if pointing completely out into the open sky
					pickedObject.reparent(get_tree().current_scene)
					pickedObject.global_position = box_carry_marker.global_position
				
				pickedObject.set_collision_layer_value(1, true)
				pickedObject.set_collision_layer_value(3, true)
				pickedObject = null
				holdingobject = false
				
		else: # IF NOT HOLDING AN ITEM (TRY TO PICK UP)
			if collider == null:
				return 
				
			if collider is store_object:
				if collider.isEmpty():
					pass
				else:
					collider._on_objects_child_exiting_tree(pickedObject)
			
			elif collider is Node3D and (collider is CharacterBody3D or collider is RigidBody3D):
				# Clean up old position database entries before lifting the item
				var lifted_grid_pos = GlobalGrid.world_to_grid(collider.global_position, get_object_cell_size(collider))
				GlobalGrid.unregister_cell(lifted_grid_pos)
				
				player.pick_up_object(collider)

func _process(_delta):
	if rayCast.is_colliding():
		collider = rayCast.get_collider()
		interact_object.emit(collider)
		
		if pickedObject != null:
			cell_size = get_object_cell_size(pickedObject)
			var collisionPoint = rayCast.get_collision_point()
			var collisionNormal = rayCast.get_collision_normal()
			
			# Offsets position outwards by half its size so it rests perfectly on structural faces
			var targetPos = collisionPoint + (collisionNormal * (cell_size / 2.0))
			gridPos = GlobalGrid.world_to_grid(targetPos, cell_size)
	else: 
		collider = null 
		interact_object.emit(null)

func _physics_process(delta: float) -> void:
	# Preview processing updates 
	if pickedObject != null and rayCast.is_colliding():
		previewBox(gridPos)
	elif pickedObject != null:
		pickedObject.global_position = box_carry_marker.global_position
	
	# Basic Player Physics
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y))
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = 0.0
		velocity.z = 0.0

	move_and_slide()

func pick_up_object(object):
	if not holdingobject:
		object.set_collision_layer_value(1, false)
		object.set_collision_layer_value(3, false)
		
		pickedObject = object
		holdingobject = true
			
		var stats_node = null
		if "GivenName" in object:
			stats_node = object
		else:
			for child in object.get_children():
				if "GivenName" in child:
					stats_node = child
					break
				
		if stats_node != null:
			Name = str(stats_node.GivenName)
			weight = stats_node.GivenWeight
			material = str(stats_node.GivenType)
			Income = stats_node.GivenIncome
			ability = str(stats_node.GivenAbility)
			health = stats_node.GivenHealth

func get_object_cell_size(obj: Node3D) -> float:
	if "size" in obj:
		if obj.size is Vector2 or obj.size is Vector3:
			return obj.size.x
		return obj.size
	return GlobalGrid.DEFAULT_CELL_SIZE

func previewBox(visual_grid_pos: Vector3):
	pickedObject.global_position = visual_grid_pos

func find_allboxes(current_node: Node, results: Array[Node]) -> void:
	if current_node == player:
		return
	
	if "collision_layer" in current_node:
		if current_node.collision_layer & 4:
			results.append(current_node)
			current_node.queue_free()
			
	for child in current_node.get_children():
		find_allboxes(child, results)
