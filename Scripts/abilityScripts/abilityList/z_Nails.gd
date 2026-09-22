extends CharacterBody3D


# Called when the node enters the scene tree for the first time.

@onready var boxbasic1 = $CollisionShape3D
@onready var gpu_particles_3d: GPUParticles3D = $GPUParticles3D
@onready var mesh2Animate = $CollisionShape3D/MeshInstance3D
var GivenName = "Box of Nails"
var GivenWeight = 75
var GivenType = "Cardboard"
var GivenIncome = 150
var GivenAbility = "Passive: Deal 25 Damage to all boxes directly adjacent to this by "
var GivenHealth = 55
var CollectedWeight = 0

var selected = false
var player
var outlineWidth = 0.05
var height = 1

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var BoxesNotToAffect: Array = []
@export var size: Vector2 = Vector2(1,1)
@export var offset: Vector3 = Vector3.ZERO
#Ability Specific editing

var canBeDestroyed: bool = true
var incomeCanChange:bool = true
var weightCanChange:bool = true
var healthCanChange:bool = true
var abilityCanChange:bool = true
var materialCanChange:bool = true
var canBeMoved:bool = true
var canMove:bool = true
var canReroll:bool = true

var isPickUpable:bool = true
var squashTween: Tween = null
var splatted: bool = false

var boxesAboveThis: Array[Node3D] = []

func _ready():
	player = get_tree().get_first_node_in_group("player")
	add_to_group("boxes")

func _process(_delta):
	CollectedWeight = 0
	for i in boxesAboveThis:
		CollectedWeight += i.GivenWeight + i.CollectedWeight

	if GivenWeight < 0:
		gravity = -9.8
	else:
		gravity = 9.8

	if selected:
		boxbasic1.position.y = outlineWidth
		player.boxTypeDetector = 1 
	else:
		boxbasic1.position.y = 0
		
	if GivenHealth <= 0 or CollectedWeight >= GivenWeight * 4:
		self.queue_free()
func _physics_process(delta: float) -> void:
	
	if player.pickedObject == self:
		velocity = Vector3.ZERO
		move_and_slide()
		return
		 
	if not is_on_floor() and gravity > 0:
		velocity.y -= gravity * delta
		if splatted:
			splatted = false
			if squashTween == null or not squashTween.is_running():
				squashTween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
				squashTween.tween_property(mesh2Animate,"scale", Vector3(0.7,1.1,0.7), 1)
				gpu_particles_3d.emitting = false
		
	elif is_on_floor() and gravity > 0 and not splatted:
		splatted = true
		if squashTween and squashTween.is_running():
			squashTween.kill()
		squashTween = create_tween()
		squashTween.tween_property(mesh2Animate,"scale", Vector3(1.3,0.5,1.3), 0.1)
		squashTween.tween_property(mesh2Animate,"scale", Vector3(1,1,1), 0.2)
		gpu_particles_3d.emitting = true
		velocity.y = 0
		
	if gravity < 0 and not is_on_ceiling():
		velocity.y -= gravity * delta
	elif is_on_ceiling() and gravity < 0:
		velocity.y = 0
	move_and_slide()
func _set_selected(object):
	selected = self == object
	

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body != self and body is CharacterBody3D or body is RigidBody3D:
		if not body.is_in_group("player") and not player.pickedObject:
			if not BoxesNotToAffect.has(body):
				body.GivenHealth -= 25
				BoxesNotToAffect.append(body)
				if "Destroyer" in body and body.GivenHealth <= 0:
					body.Destroyer = self
					body.ability()

func get_rect():
	var objectPosition = Vector2(
		global_position.x - int(size.x / 2),
		global_position.z - int(size.y / 2)
	)
	return Rect2(objectPosition, size)


func _on_checker_body_entered(body: Node3D) -> void:
	if body.is_in_group("boxes") and body != self:
		boxesAboveThis.append(body)
func _on_checker_body_exited(body: Node3D) -> void:
	if body.is_in_group("boxes") and boxesAboveThis.has(body):
		boxesAboveThis.erase(body)
		print(body.GivenName)
