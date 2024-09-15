extends Node3D;

@onready var player: CharacterBody3D = $Player
@onready var menu: Control = $Menu
@onready var spawns: Node3D = $NavigationRegion3D/SpawnHolder
@onready var zombie: PackedScene = load("res://Assets/Enemies/Raptor/raptor.tscn");
@onready var navigation_region: NavigationRegion3D = $NavigationRegion3D

# UI Variables
var menu_shown := false;
var instance;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	menu.hide();


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if OptionSettings.paused:
			menu.hide();
			OptionSettings.paused = false;
			get_tree().call_group("pausable", "_handle_pause");
		else:
			menu.show();
			OptionSettings.paused = true;
			get_tree().call_group("pausable", "_handle_pause");

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	pass;


func _on_button_quit_pressed() -> void:
	get_tree().quit();

func _get_random_child(parent_node):
	return parent_node.get_child(randi() % parent_node.get_child_count())

func _on_zombie_spawn_timer_timeout():
	if not OptionSettings.paused:
		var spawn_point = _get_random_child(spawns).global_position;
		instance = zombie.instantiate();
		instance.position = spawn_point;
		navigation_region.add_child(instance);
