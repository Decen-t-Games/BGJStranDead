extends AudioStreamPlayer;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass; # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if OptionSettings.paused:
		stream_paused = true;
	else:
		stream_paused = false;


func _handle_pause():
	if OptionSettings.paused:
		stream_paused = true;
	else:
		stream_paused = false;
