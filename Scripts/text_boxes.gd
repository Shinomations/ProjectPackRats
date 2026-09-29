extends Node3D

@export var talkingText: Array[String] = []
@export var player: CharacterBody3D
@export var textBoxDisappearSpeed: int

@onready var look_at_node: Node3D = $flatRatFile/LookAtNode
@onready var animation_tree: AnimationTree = $flatRatFile/Cam/AnimationTree
var close = false
var npcTextToEdit
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	npcTextToEdit = player.npcChatBox.get_child(1).get_child(0).get_child(0)
	
func _process(delta: float) -> void:
	if(player.npcChatBox.visible == false or talkingText.size() == 0):
		animation_tree["parameters/Blend2/blend_amount"] = 1
	
	var PlayerPos = player.global_position
	look_at_node.global_position = PlayerPos

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interaction"):
		if(player.npcChatBox.visible == true):
			close = true;

func revealChatter():
	#npcTextToEdit.text = talkingText[0]
	player.npcChatBox.visible = true
	animation_tree["parameters/Blend2/blend_amount"] = 0.0
	if not talkingText.size() >= 0:
		return
	for i in talkingText:
		if(close):
			
			player.npcChatBox.visible = false
			close = false
			break
		animation_tree["parameters/Blend2/blend_amount"] = 0.0
		npcTextToEdit.text = i
		await get_tree().create_timer(textBoxDisappearSpeed).timeout
		
	
	
