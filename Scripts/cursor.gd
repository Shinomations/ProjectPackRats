extends Control

@onready var image: TextureRect = $image
@onready var player = get_tree().get_first_node_in_group("player")

var normal = preload("res://Sprites & images/cursor-sprites/bubble.png")
var grabbing = preload("res://Sprites & images/cursor-sprites/grabbing.png")
var hovering = preload("res://Sprites & images/cursor-sprites/hover.png")


func _process(delta):
	if player == null:
		return

	if player.pickedObject != null:
		image.texture = grabbing

	elif player.collider is CharacterBody3D or player.collider is RigidBody3D:
		image.texture = hovering

	else:
		image.texture = normal
