extends Node3D
class_name Client

@export var talkingText: Array[String] = []

@export var textBoxDisappearSpeed: int
@onready var look_at_node: Node3D = $flatRatFile/LookAtNode
@onready var animation_tree: AnimationTree = $flatRatFile/Cam/AnimationTree

var clientAbility: String = ""
var clientCounter: int = 0
var clientsViableUnitsManager: Array[CharacterBody3D] = []
var close = false
var npcTextToEdit
var player
var truck
var CompletedAbility: bool
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	truck = get_tree().get_first_node_in_group("truck")
	npcTextToEdit = player.npcChatBox.get_child(1).get_child(0).get_child(0)
	
func _process(_delta: float) -> void:
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
		
	
	
