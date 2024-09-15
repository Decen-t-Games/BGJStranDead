extends Node3D;

@onready var barrel: Marker3D = $Barrel
@onready var bullet: PackedScene = preload("res://Assets/Guns/Bullet/bullet.tscn");
@onready var bullet_material: StandardMaterial3D = preload("res://Assets/Guns/Bullet/RifleBulletTexture.tres");

const ATTACK_COOLDOWN := 0.5;
const RIFLE_DAMAGE := 10.0;
const BULLET_SPEED := 50.0;

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
		get_tree().root.add_child(prepare_bullet());
		get_tree().call_group("player", "run_gun_animation", "plasma_rifle");
	else:
		attack_recovery_timer -= delta;
	
	attack_recovery_timer -= delta;
	attack_recovery_timer = clamp(attack_recovery_timer, 0, ATTACK_COOLDOWN);


func prepare_bullet() -> Node3D:
	bullet_instance = bullet.instantiate();
	bullet_instance.damage = RIFLE_DAMAGE;
	bullet_instance.speed = BULLET_SPEED;
	bullet_instance.bullet_material = bullet_material;
	bullet_instance.position = barrel.global_position;
	bullet_instance.transform.basis = barrel.global_transform.basis;
	return bullet_instance;
