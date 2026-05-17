extends CharacterBody3D

signal interact_object

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.005


@onready var head = $Head
@onready var cam = $Head/Camera3D
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
	if event.is_action_pressed("interaction") and pickedObject:	
		if collider is store_object:
			collider.add_object(pickedObject)
		else:
			pickedObject.reparent(get_tree().current_scene)
		pickedObject = null
		holdingobject = false
		
	

func _process(_delta):
	
	if rayCast.is_colliding():
		collider = rayCast.get_collider()
		interact_object.emit(collider)
	else: interact_object.emit(null)

func _physics_process(delta: float) -> void:
	# Add the gravity.
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
		object.reparent(cam)
		object.global_position = %boxCarryMarker.global_position
		await get_tree().create_timer(0.1).timeout
		object.freeze = true
		object.lock_rotation = true
		pickedObject = object
		holdingobject = true
