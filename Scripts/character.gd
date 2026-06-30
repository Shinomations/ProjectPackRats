extends CharacterBody3D

signal interact_object

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.005
@onready var player: CharacterBody3D = $"."

@onready var head = $Head
@onready var cam = $Head/Camera3D
@onready var box_carry_marker: Marker3D = $Head/Camera3D/boxCarryMarker
@onready var placementZ = $PlacementZone 
@onready var rayCast = $Head/Camera3D/RayCast3D

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


func _ready():
	add_to_group("player")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event.is_action_pressed("quit"): 
		get_tree().quit()
	
	if event.is_action_pressed("Freedom"):
		if isFirstPress == true:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			print("Mouse on")
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			print("Mouse off")
		isFirstPress = !isFirstPress
		
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		cam.rotate_x(-event.relative.y * SENSITIVITY)
		cam.rotation.x = clamp(cam.rotation.x,deg_to_rad(-40),deg_to_rad(60))

func _input(event):
	if event.is_action_pressed("interaction"):	
		if(pickedObject != null): # IF HOLDING AN ITEM (DROP/PLACE IT)
			if collider is store_object:
				if collider.isEmpty():
					pickedObject.set_collision_layer_value(1, true)
					pickedObject.set_collision_layer_value(3, true)
					if pickedObject is RigidBody3D:
						pickedObject.freeze = true
					collider.add_object(pickedObject)
					
					pickedObject = null
					holdingobject = false
				else:
					collider._on_objects_child_exiting_tree(pickedObject)
			
			else: # Drop item normally into the world
				pickedObject.reparent(get_tree().current_scene)
				if pickedObject is RigidBody3D:
					pickedObject.lock_rotation = false
				
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
			# FIXED: Now checks for BOTH RigidBody3D and CharacterBody3D types
			elif collider is RigidBody3D or collider is CharacterBody3D:
				player.pick_up_object(collider)
		
	

func _process(_delta):
	if rayCast.is_colliding():
		collider = rayCast.get_collider()
		interact_object.emit(collider)
	else: 
		collider = null # FIXED: Clears reference so you aren't pointing at old nodes
		interact_object.emit(null)

func _physics_process(delta: float) -> void:
	# Keep held object tracking smooth without conflicting transforms
	if (pickedObject != null):
		pickedObject.global_transform = placementZ.global_transform
	
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
		object.reparent(placementZ) # FIXED: Changed parent directly to the placement zone
		object.set_collision_layer_value(1, false)
		object.set_collision_layer_value(3, false)
		
		if object is RigidBody3D:
			object.lock_rotation = true
			
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
			
