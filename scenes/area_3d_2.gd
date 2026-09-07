extends Area3D

@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var audio_stream_player_3d_2: AudioStreamPlayer3D = $AudioStreamPlayer3D2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if audio_stream_player_3d_2.playing == false:
		audio_stream_player_3d_2.play()
	

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("boxes") or body.is_in_group("player"):
		audio_stream_player_3d.play(0.10)
		audio_stream_player_3d.play(0.10)
