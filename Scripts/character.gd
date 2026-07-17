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

var pickedObject
var gravity = (ProjectSettings.get_setting("physics/3d/default_gravity"))
var holdingobject = false
var collider # Stores whatever the raycast is currently looking at
var boxTypeDetector: int
var isFirstPress: bool = true

#stats
var Name: String
var weight: int
var material: String
var Income: int
var ability: String
var health: int

var cell_size = 1
var gridPos: Vector3 = Vector3.ZERO
func _ready():
	add_to_group("player")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
#close game
	if event.is_action_pressed("quit"): 
		get_tree().quit()
	
#Show Mouse Toggle
	if event.is_action_pressed("Freedom"):
		if isFirstPress == true:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			print("Mouse on")
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			print("Mouse off")
		isFirstPress = !isFirstPress
		
#Movement
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		cam.rotate_x(-event.relative.y * SENSITIVITY)
		cam.rotation.x = clamp(cam.rotation.x,deg_to_rad(-80),deg_to_rad(85))

func _input(event):
#grab object
	if event.is_action_pressed("interaction"):	
		if(pickedObject != null): # IF HOLDING AN ITEM (DROP/PLACE IT)
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
			
			else: # Drop item normally into the world
				pickedObject.reparent(get_tree().current_scene)
				pickedObject.set_collision_layer_value(1, true)
				pickedObject.set_collision_layer_value(3, true)
				pickedObject = null
				holdingobject = false
				
		else: # IF NOT HOLDING AN ITEM (TRY TO PICK UP)
			if collider == null:
				return # Exit early if looking at nothing
				
			if collider is store_object:
				if collider.isEmpty():
					pass
				else:
					collider._on_objects_child_exiting_tree(pickedObject)
			
			elif collider is CharacterBody3D:
				player.pick_up_object(collider)
		
	

func _process(_delta):
	if rayCast.is_colliding():
		collider = rayCast.get_collider()
		interact_object.emit(collider)
		if pickedObject:
			var collisionPoint = rayCast.get_collision_point()
			var collisionNormal = rayCast.get_collision_normal()
			var targetPos = collisionPoint + (collisionNormal * (cell_size / 2))
			gridPos = snap2grid(targetPos)
	else: 
		collider = null 
		interact_object.emit(null)

func _physics_process(delta: float) -> void:
	
	if pickedObject != null and rayCast.is_colliding():
		previewBox(gridPos)
	elif pickedObject != null:
		pickedObject.global_position = box_carry_marker.global_position
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction = (head.transform.basis * Vector3(input_dir.x,0,input_dir.y))
	
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
			
func find_allboxes(current_node: Node, results: Array[Node]) -> void:
	if current_node == player:
		return
	
	if "collision_layer" in current_node:
		if current_node.collision_layer & 4:
			results.append(current_node)
			current_node.queue_free()
			
	for child in current_node.get_children():
		find_allboxes(child, results)
		
func snap2grid(world_position: Vector3) -> Vector3:
	if "size" in pickedObject:
		if pickedObject.size is Vector2 or pickedObject.size is Vector3:
			cell_size = pickedObject.size.x 
		else:
			cell_size = pickedObject.size 
	else:
		cell_size = 1.0 # Default backup size if no property is found
	var x = round(world_position.x / cell_size) * cell_size
	var y = round(world_position.y / cell_size) * cell_size
	var z = round(world_position.z / cell_size) * cell_size
	return Vector3(x,y,z)

func previewBox(gridPos):
	pickedObject.global_position = gridPos
	#pickedObject.visibility = true
