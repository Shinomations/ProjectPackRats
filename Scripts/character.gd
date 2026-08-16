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

## player is a group so this class is referencable in other scripts
func _ready():
	add_to_group("player")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

## handles close, mouse movement
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

## input handler
func _input(event):

	# interaction button -> left click
	if event.is_action_pressed("interaction"):	

		# if holding item 
		if pickedObject != null:

			# Dynamic Grid System Drop Logic
			if rayCast.is_colliding():
			
				# Block placement if the target grid coordinates are already occupied
				if not GlobalGrid.is_cell_vacant(gridPos):
					print("Cannot place: Grid position ", gridPos, " is occupied!")
					return 
				
				# Finalize structural drop into grid space
				pickedObject.reparent(get_tree().current_scene)
				pickedObject.global_position = gridPos
				GlobalGrid.register_cell(gridPos, pickedObject)
			
			# Fallback drop if pointing completely out into the open sky
			else:
				pickedObject.reparent(get_tree().current_scene)
				pickedObject.global_position = box_carry_marker.global_position
			
			pickedObject.set_collision_layer_value(1, true)
			pickedObject.set_collision_layer_value(3, true)
			pickedObject = null
			holdingobject = false
		
		# if not holding item	
		else: 

			# looking at nothing
			if collider == null:
				return 

			# if looking at something its a node & either a character or rigid
			if collider is Node3D and (collider is CharacterBody3D or collider is RigidBody3D):

				# saves x y z
				var lifted_grid_pos = GlobalGrid.world_to_grid(collider.global_position, get_object_cell_size(collider))
				
				# if theres something there delete the thing
				GlobalGrid.unregister_cell(lifted_grid_pos)
				
				# put in player hand
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


## saves the object 
func pick_up_object(object):

	if not holdingobject:		
		
		collision_set()

		# save the holding object and marks the player as holding an object
		pickedObject = object
		holdingobject = true
		var stats_node = null

		# if parent has stats
		if "GivenName" in object:
			stats_node = object
		# check every child to see if has stats
		else:
			for child in object.get_children():
				if "GivenName" in child:
					stats_node = child
					break
		
		# if stats was found store the values
		if stats_node != null:
			Name 		= str(stats_node.GivenName)
			material 	= str(stats_node.GivenType)
			ability 	= str(stats_node.GivenAbility)
			weight 		= stats_node.GivenWeight			
			Income		= stats_node.GivenIncome
			health 		= stats_node.GivenHealth

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


## sets collision layer value
func collision_set():
	if pickedObject != null:
		pickedObject.set_collision_layer_value(1, true)
		pickedObject.set_collision_layer_value(3, true)
