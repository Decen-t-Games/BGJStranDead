extends Node3D;

@onready var barrel: Marker3D = $Barrel
@onready var bullet: PackedScene = load("res://Assets/Guns/Bullet/bullet.tscn");

const ATTACK_COOLDOWN := 0.5;

var stamina := 100.0;
var attack_recovery_timer := 0.0;

var bullet_instance: Node3D;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass; # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass;


func _weapon_fire(delta: float) -> void:
	if attack_recovery_timer == 0:
		attack_recovery_timer += ATTACK_COOLDOWN;
		bullet_instance = bullet.instantiate();
		bullet_instance.position = barrel.global_position;
		bullet_instance.transform.basis = barrel.global_transform.basis;
		get_tree().root.add_child(bullet_instance);
		get_tree().call_group("player", "run_gun_animation", "plasma_rifle");
	else:
		attack_recovery_timer -= delta;
	
	attack_recovery_timer -= delta;
	attack_recovery_timer = clamp(attack_recovery_timer, 0, ATTACK_COOLDOWN);
