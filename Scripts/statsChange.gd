extends Control

@onready var UnitAbility = $MarginContainer2/RichTextLabel
@onready var wholeTab = $"."
var player: CharacterBody3D = null

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	wholeTab.visible = false
func _process(_delta: float) -> void:
	# Backup check: If player group failed in _ready, try to find it now
	if not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("player")

	# The validation check
	if is_instance_valid(player) and is_instance_valid(player.pickedObject) and Input.is_action_pressed("Notes"):
		wholeTab.visible = true
		UnitAbility.text = "Name: " + player.Name + "\nWeight: " + str(player.weight) + "\nMaterial: " + player.material + "\nIncome: " + str(player.Income) + "\nHealth: " + str(player.health) + "\nAbility\n" +  player.ability 

		
	else:
		wholeTab.visible = false
		UnitAbility.text = ""
	
