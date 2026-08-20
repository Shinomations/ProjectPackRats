extends Control

@onready var UnitAbility = $MarginContainer/RichTextLabel
@onready var rich_text_label = $TextureRect/RichTextLabel


var player: CharacterBody3D = null

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _process(_delta: float) -> void:
	# Backup check: If player group failed in _ready, try to find it now
	if not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("player")
	

	
	# The validation check
	if is_instance_valid(player) and is_instance_valid(player.pickedObject):
		UnitAbility.text = "Name: " + player.Name + "\nWeight: " + str(player.weight) + "\nMaterial: " + player.material + "\nIncome: " + str(player.Income) + "\nHealth: " + str(player.health) + "\nAbility\n" +  player.ability 

		
	else:
		UnitAbility.text = ""
	
