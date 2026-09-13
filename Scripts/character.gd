extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.005
@onready var player: CharacterBody3D = $"."

@onready var footsteps: AudioStreamPlayer3D = $CollisionShape3D/Footsteps
@onready var animation_tree: AnimationTree = $Head/rig/AnimationTree

@onready var head = $Head
@onready var cam = $Head/Camera3D
@onready var box_carry_marker: Marker3D = $Head/Camera3D/boxCarryMarker
@onready var box_carry_marker2: Marker3D = $Head/Camera3D/boxCarryMarker2
@onready var rayCast: RayCast3D = $Head/Camera3D/RayCast3D
@onready var finalScreen = $"Game Finish Screen"
@onready var npcChatBox = $TextBoxes

var pickedObject: Node3D = null
#var marker: Marker3D = null
var gravity = (ProjectSettings.get_setting("physics/3d/default_gravity"))
var holdingobject = false
var collider # Stores whatever the raycast is currently looking at
var boxTypeDetector: int
var isFirstPress: bool = true
var totalScore = 0
var truck
var boxes
var client
var FinalScore = 0
var timeHeld = 0.0
# Safety trigger flag to prevent infinite screen execution spam
var level_completed: bool = false

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
#var  GPU: GPUParticles3D = null
## THIS IS FOR THE PLACE DOWN EFFECTS^^
## player is a group so this class is referencable in other scripts
func _ready():
	truck = get_tree().get_first_node_in_group("truck")
	client = get_tree().get_first_node_in_group("clients")
	add_to_group("player")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	finalScreen.visible = false
	npcChatBox.visible = false


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
	#Check for click
	if event.is_action_pressed("interaction"):
		rayCast.force_raycast_update()
		updateRaycastData()
		if collider != null and collider.is_in_group("clients"):
			if(player.npcChatBox.visible == false):
				collider.revealChatter()
			return
		if pickedObject != null:
			if rayCast.is_colliding():
				
				if not GlobalGrid.is_cell_vacant(gridPos):
					return
				#GPU.emitting = true	
				pickedObject.set_physics_process(true)
				pickedObject.reparent(get_tree().current_scene)
				pickedObject.global_position = gridPos + pickedObject["offset"]
				GlobalGrid.register_cell(gridPos, pickedObject)
			else:
				pickedObject.reparent(get_tree().current_scene)
				if pickedObject.is_in_group("boxes"):
					pickedObject.global_position = box_carry_marker.global_position + pickedObject["offset"]

				

			collisionSet()
		else:
			if collider == null:
				return
				
			if collider is CharacterBody3D or collider is RigidBody3D:
				var liftBoxPos = GlobalGrid.world_to_grid(collider.global_position, get_object_cell_size(collider))
				GlobalGrid.unregister_cell(liftBoxPos)
				pick_up_object(collider)
	
		
	if Input.is_action_pressed("rotateUp") && holdingobject:
		rotateBoxesUp()
	if Input.is_action_pressed("RotateSide") && holdingobject:
		rotateBoxesSide()
func _process(_delta):
	#update raycast
	updateRaycastData()
	

func updateRaycastData():
	if rayCast.is_colliding():
		collider = rayCast.get_collider()
		
		var collisionPoint = rayCast.get_collision_point()
		var collisionNormal = rayCast.get_collision_normal()
		
		if pickedObject != null:
			cell_size = get_object_cell_size(pickedObject)
			
			var targetPos = collisionPoint + (collisionNormal * (cell_size / 2))
			gridPos = GlobalGrid.world_to_grid(targetPos, cell_size)
			pickedObject.set_physics_process(true)
		else:
			var targetPos = collisionPoint - (collisionNormal * 0.1)
			gridPos = GlobalGrid.world_to_grid(targetPos, GlobalGrid.DEFAULT_CELL_SIZE)
			
	else:
		collider = null
		

func _physics_process(delta: float) -> void:
	# Preview processing updates 
	if pickedObject != null and rayCast.is_colliding():
		previewBox(gridPos)
		
	elif pickedObject != null and pickedObject.is_in_group("boxes"):

		pickedObject.global_position = box_carry_marker.global_position + pickedObject["offset"]


		
	# Basic Player Physics
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var inputDir := Input.get_vector("left", "right", "up", "down")
	var direction = (head.transform.basis * Vector3(inputDir.x, 0, inputDir.y))
	var current_BP = animation_tree["parameters/BlendSpace2D/blend_position"]
	animation_tree["parameters/BlendSpace2D/blend_position"] = Vector2(lerp(current_BP.x,inputDir.x, .1), lerp(current_BP.y,inputDir.y, .1))
	if direction:
		#if (footsteps.playing == false):
		#	footsteps.play()
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		#footsteps.stop()
		velocity.x = 0.0
		velocity.z = 0.0

	move_and_slide()

## saves the object 
func pick_up_object(object):

	if not holdingobject:		
		# 1. Disable collision shapes before updating parent links
		_toggleCollision(object, true)
		
		# save the holding object and marks the player as holding an object
		pickedObject = object
		#marker = pickedObject.find_child("Marker3D")
		holdingobject = true
		var statsNode = null

		# if parent has stats
		if "GivenName" in object:
			statsNode = object
		# check every child to see if has stats
		else:
			for child in object.get_children():
				if "GivenName" in child:
					statsNode = child
					break
		
		# if stats was found store the values
		if statsNode != null:
			Name 		= str(statsNode.GivenName)
			material 	= str(statsNode.GivenType)
			ability 	= str(statsNode.GivenAbility)
			weight 		= statsNode.GivenWeight			
			Income		= statsNode.GivenIncome
			health 		= statsNode.GivenHealth

func get_object_cell_size(obj: Node3D) -> float:
	if "size" in obj:
		if obj.size is Vector2 or obj.size is Vector3:
			return obj.size.x
		return obj.size
	return GlobalGrid.DEFAULT_CELL_SIZE

func previewBox(visualGridPos: Vector3):
	#GPU = pickedObject.find_child("GPUParticles3D")
	
	pickedObject.global_position = visualGridPos + pickedObject["offset"]
func find_allboxes(currentNode: Node, results: Array[Node]) -> void:
	if currentNode == player:
		return
	
	if "collision_layer" in currentNode:
		if currentNode.collision_layer & 4:
			results.append(currentNode)
			currentNode.queue_free()
			
	for child in currentNode.get_children():
		find_allboxes(child, results)

## sets collision layer value
func collisionSet():
	if pickedObject != null:
		#Turns back on Collider
		_toggleCollision(pickedObject, false)
		
		pickedObject.set_collision_layer_value(1, true)
		pickedObject.set_collision_layer_value(3, true)
		pickedObject = null
		holdingobject = false

## Safely checks for and updates any internal CollisionShape3D component
func _toggleCollision(targetNode: Node, shouldDisable: bool) -> void:
	if targetNode == null:
		return
	
	#Getting by name
	var colliderNode = targetNode.find_child("CollisionShape3D", true, false)
	
	# loop too check all childs for being collision shapes
	if colliderNode == null:
		for child in targetNode.get_children():
			if child is CollisionShape3D:
				colliderNode = child
				break
				
	# If collider is found disable it
	if colliderNode != null:
		colliderNode.set_deferred("disabled", shouldDisable)

# gameEnding test
func areThereStillBoxes() -> bool:
	print("Doing the test")
	boxes = get_tree().get_nodes_in_group("boxes")
	print(boxes)
	if boxes.size() <= 0:
		finalScreen.statsShow()
		return false
	else:
		print("truck Multi before is: " + str(finalScreen.trucksMulti))
		finalScreen.trucksMulti -= 1
		print("truck Multi is: " + str(finalScreen.trucksMulti))
		
		truck.remainingCapacity = 1.0
		
	return true

func rotateBoxesUp():
	pickedObject.rotate_x(deg_to_rad(90)) 
	pickedObject["offset"] = pickedObject["offset"].rotated(Vector3.LEFT, PI / 2)
	
func rotateBoxesSide():
	pickedObject.rotate_y(deg_to_rad(90))
	pickedObject["offset"] = pickedObject["offset"].rotated(Vector3.UP, PI / 2)
	
