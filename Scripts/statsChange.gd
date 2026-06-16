extends Control

@onready var UnitName = $MarginContainer/HBoxContainer/VBoxContainer2/NameLine
@onready var UnitWeight = $MarginContainer/HBoxContainer/VBoxContainer2/WeightLine
@onready var UnitMaterial = $MarginContainer/HBoxContainer/VBoxContainer2/Material
@onready var UnitQuality = $MarginContainer/HBoxContainer/VBoxContainer2/Quality
@onready var UnitHealth = $MarginContainer/HBoxContainer/VBoxContainer2/Health
@onready var UnitAbility = $MarginContainer/HBoxContainer/VBoxContainer2/Ability

@onready var player = get_parent()

func _ready() -> void:
	
	pass

func _process(_delta: float) -> void:
	
	if player and is_instance_valid(player.pickedObject):
		UnitName.text = player.Name
		
	else: 
		UnitName.text = "none"
