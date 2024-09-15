extends Node3D;

@onready var barrel: Marker3D = $Barrel
@onready var bullet: PackedScene = preload("res://Assets/Guns/Bullet/bullet.tscn");
@onready var bullet_material: StandardMaterial3D = preload("res://Assets/Guns/Bullet/RifleBulletMaterial.tres");

const ATTACK_COOLDOWN := 0.5;
const RIFLE_DAMAGE := 10.0;
const BULLET_SPEED := 50.0;

const DEFAULT_STAMINA := 100.0;
const RIFLE_STAMINA_DIMINISH := 5.0;
const STAMINA_RECOVERY_DELAY := 3.0;
const STAMINA_RECOVERY_RATE := 2.5;
const MIN_STAMINA_RESUME_FROM_NONE := 5.0;

var stamina := DEFAULT_STAMINA;
var attack_recovery_timer := 0.0;
var stamina_recovery_timer := 0.0;
	
var bullet_instance: Node3D;
var can_recover := true;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if stamina_recovery_timer >= STAMINA_RECOVERY_DELAY:
		if stamina < MIN_STAMINA_RESUME_FROM_NONE:
			can_recover = false;
		else:
			can_recover = true;
		stamina -= STAMINA_RECOVERY_RATE * delta;  # Recover sprint after delay
			
	if can_recover:
		stamina += STAMINA_RECOVERY_RATE * delta;
		stamina_recovery_timer -= delta;
	
	stamina = clamp(stamina, -10, DEFAULT_STAMINA);
	get_tree().call_group("player", "update_weapon_stamina", stamina);


func _weapon_fire(delta: float) -> void:
	if attack_recovery_timer == 0 and stamina > 0:
		attack_recovery_timer += ATTACK_COOLDOWN;
		get_tree().root.add_child(prepare_bullet());
		get_tree().call_group("player", "run_gun_animation", "plasma_rifle");
		stamina -= RIFLE_STAMINA_DIMINISH;
	else:
		attack_recovery_timer -= delta;
		stamina_recovery_timer += delta;
	
	attack_recovery_timer -= delta;
	attack_recovery_timer = clamp(attack_recovery_timer, 0, ATTACK_COOLDOWN);
	stamina = clamp(stamina, -10, DEFAULT_STAMINA);
	get_tree().call_group("player", "update_weapon_stamina", stamina);


func prepare_bullet() -> Node3D:
	bullet_instance = bullet.instantiate();
	bullet_instance.damage = RIFLE_DAMAGE;
	bullet_instance.speed = BULLET_SPEED;
	bullet_instance.bullet_material = bullet_material;
	bullet_instance.position = barrel.global_position;
	bullet_instance.transform.basis = barrel.global_transform.basis;
	return bullet_instance;
