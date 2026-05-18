extends CharacterBody3D

signal interact_object

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.005
@onready var player: CharacterBody3D = $"."

@onready var head = $Head
@onready var cam = $Head/Camera3D
@onready var box_carry_marker: Marker3D = $Head/Camera3D/boxCarryMarker

@onready var rayCast = $Head/Camera3D/RayCast3D

var pickedObject
var gravity = (ProjectSettings.get_setting("physics/3d/default_gravity"))
var holdingobject = false
var collider

func _ready():
	add_to_group("player")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event.is_action_pressed("quit"): get_tree().quit()
	
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		cam.rotate_x(-event.relative.y * SENSITIVITY)
		cam.rotation.x = clamp(cam.rotation.x,deg_to_rad(-40),deg_to_rad(60))

func _input(event):
	if event.is_action_pressed("interaction"):	
		if(pickedObject != null): # if u have item
			print(collider)
			if collider is store_object:
				if collider.isEmpty():
					collider.add_object(pickedObject)
				else:
					#pickedObject.reparent(get_tree().current_scene)
					collider._on_objects_child_exiting_tree(pickedObject)
			
			else:
				pickedObject.reparent(get_tree().current_scene)
				pickedObject.lock_rotation = false
				
				
				pickedObject.set_collision_layer_value(1, true)
				pickedObject.set_collision_layer_value(3, true)
				pickedObject = null
				holdingobject = false
				
		else: # if u dont have item
			if collider is store_object:
				if collider.isEmpty():
					
					pass
				else:
					collider._on_objects_child_exiting_tree(pickedObject)
			elif collider is RigidBody3D:
				print("isowrking")
				player.pick_up_object(collider)
		
	

func _process(_delta):
	print(collider)
	if rayCast.is_colliding():
		collider = rayCast.get_collider()
		interact_object.emit(collider)
	else: interact_object.emit(null)

func _physics_process(delta: float) -> void:
	#print(pickedObject)
	if (pickedObject != null):
		pickedObject.rotation_degrees = Vector3(0,90,0)
		pickedObject.position = Vector3(0,0,0)
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
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
		
		object.reparent(box_carry_marker)
		#object.position = Vector3(0,0,0)
		#object.rotation_degrees = Vector3(0,90,0)
		#object.freeze = true
		object.set_collision_layer_value(1, false)
		object.set_collision_layer_value(3, false)
		object.lock_rotation = true
		pickedObject = object
		holdingobject = true
		
