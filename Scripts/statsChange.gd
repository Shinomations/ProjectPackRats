extends Control

@onready var UnitAbility = $RichTextLabel
@onready var sprite = $MarginContainer2/AnimatedSprite2D
var player: CharacterBody3D = null
var speedpack

var anim_time: float = 0.00
var jitteramount: float = 0.0
@onready var startPos = Vector2(-80,160)
var tweenSlide: Tween
var notesOpen: bool = false

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	speedpack = get_tree().get_first_node_in_group("speedPack")
	UnitAbility.visible = false
	
func _process(_delta: float) -> void:
	if not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("player")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Notes"):
		handle_notes_activation()
	elif event.is_action_released("Notes"):
		closeNotes()

func handle_notes_activation() -> void:
	if is_instance_valid(player) and is_instance_valid(player.pickedObject):
		if not notesOpen:
			notesOpen = true
			sprite.flip_h = true
			sprite.play_backwards("PageFlip")
			
		await slide(Vector2(200, startPos.y), Tween.TRANS_CUBIC)
			
		UnitAbility.text = ( 
			"Name: " + player.Name + "\n" + 
			"Weight: " + str(player.weight) + "\n" + 
			"Material: " + player.material + "\n" +
			"Income: " + str(player.Income) + "\n" +
			"Health: " + str(player.health) + "\n" +
			"Ability\n" + player.ability + "\n" 
		)
		UnitAbility.visible = true

	elif is_instance_valid(player) and player.rayCast.is_colliding() and is_instance_valid(player.collider) and player.collider.is_in_group("boxes"):
		if not notesOpen:
			notesOpen = true
			sprite.flip_h = false
			sprite.play_backwards("PageFlip")
			await slide(Vector2(195, startPos.y), Tween.TRANS_CUBIC)
			
		UnitAbility.text = ( 
			"Name: " + player.collider.GivenName + "\n" + 
			"Weight: " + str(player.collider.GivenWeight) + "+ (" + str(player.collider.CollectedWeight) + ")" + "\n" + 
			"Material: " + player.collider.GivenType + "\n" +
			"Income: " + str(player.collider.GivenIncome) + "\n" +
			"Health: " + str(player.collider.GivenHealth) + "\n" +
			"Ability\n" + player.collider.GivenAbility + "\n" 
			)
		UnitAbility.visible = true

func closeNotes() -> void:
	if notesOpen:
		notesOpen = false
		UnitAbility.visible = false
		UnitAbility.text = ""
		slide(startPos, Tween.TRANS_CUBIC)

func slide(EndPoint: Vector2, Transition: Tween.TransitionType):
	if tweenSlide and tweenSlide.is_valid():
		tweenSlide.kill()
		
	tweenSlide = create_tween()
	tweenSlide.set_trans(Transition)
	tweenSlide.set_ease(Tween.EASE_IN_OUT)
	tweenSlide.tween_property(sprite, "position", EndPoint, 0.5)
	
	return tweenSlide.finished
