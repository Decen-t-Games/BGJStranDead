extends Control;

@onready var main_world: PackedScene = preload("res://Assets/World/world.tscn"); 
@onready var menu: CenterContainer = $Background/Menu
@onready var options: CenterContainer = $Background/Options
@onready var volume: Label = $Background/Options/VBoxContainer/HBoxContainerVolume/Volume
@onready var h_slider_volume: HSlider = $Background/Options/VBoxContainer/HBoxContainerVolume/HSliderVolume

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	volume.text = volume_text(h_slider_volume.value);
	options.hide();
	menu.show();


func _process(delta: float) -> void:
	pass;


func _on_button_singleplayer_pressed() -> void:
	main_world.instantiate();
	get_tree().change_scene_to_packed(main_world);


func _on_button_quit_pressed() -> void:
	get_tree().quit();


func _on_button_options_pressed() -> void:
	menu.hide();
	options.show();


func _on_button_back_pressed() -> void:
	options.hide();
	menu.show();


func _on_h_slider_volume_drag_ended(value_changed: bool) -> void:
	OptionSettings.volume = h_slider_volume.value;
	volume.text = volume_text(OptionSettings.volume);


func _on_check_button_particles_toggled(toggled_on: bool) -> void:
	OptionSettings.particles = toggled_on;


func volume_text(amount: int) -> String:
	return "Volume (" + str(amount) + "%)";
