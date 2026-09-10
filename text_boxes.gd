extends Node3D

@export var talkingText: Array[String] = []
@export var player: CharacterBody3D
var npcTextToEdit
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	npcTextToEdit = player.npcChatBox.get_child(1).get_child(0).get_child(0)
	

func revealChatter():
	player.npcChatBox.visible = true
	if not talkingText.size() >= 0:
		return
	for i in talkingText:
		npcTextToEdit.text = i
		await get_tree().create_timer(3.0).timeout
		
	player.npcChatBox.visible = false
	
