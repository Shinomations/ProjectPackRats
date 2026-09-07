extends Control

@onready var UnitAbility = $RichTextLabel
@onready var wholeTab = $"."
var player: CharacterBody3D = null


var anim_time: float = 0.00
var jitteramount: float = 0.03

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	wholeTab.visible = false
	
	
func _process(_delta: float) -> void:
	
	# slightly jitters the text for cool animation
	anim_time += _delta
	
	if anim_time >= jitteramount:
		anim_time = 0.0
		var offsetx: float = randf_range(-0.67, 0.67)
		var offsety: float = randf_range(-0.67, 0.67)
		
		UnitAbility.position = Vector2(
			70.0  + offsetx,
			121.0 + offsety
		)
		
		
	# Backup check: If player group failed in _ready, try to find it now
	if not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("player")

	# The validation check
	if is_instance_valid(player) and is_instance_valid(player.pickedObject) and Input.is_action_pressed("Notes"):
		wholeTab.visible = true
		UnitAbility.text = ( 
			"Name: " + player.Name + "\n" + 
			"Weight: " + str(player.weight) + "\n" + 
			"Material: " + player.material + "\n" +
			"Income: " + str(player.Income) + "\n" +
			"Health: " + str(player.health) + "\n" +
			"Ability" +  "\n" + player.ability 
		)
	else:
		wholeTab.visible = false
		UnitAbility.text = ""
	
