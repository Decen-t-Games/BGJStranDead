extends Node3D;

@onready var player: CharacterBody3D = $Player
@onready var menu: Control = $Menu

# UI Variables
var menu_shown := false;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	menu.hide();


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if OptionSettings.paused:
			menu.hide();
			OptionSettings.paused = false;
			get_tree().call_group("player", "_handle_pause");
		else:
			menu.show();
			OptionSettings.paused = true;
			get_tree().call_group("player", "_handle_pause");

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	pass;


func _on_button_quit_pressed() -> void:
	get_tree().quit();
