extends CharacterBody3D;

@onready var nav_agent = $Navigator;
@onready var hitbox: CollisionShape3D = $Hitbox
@onready var anim_tree = $blockbench_export/AnimationTree

const SPEED = 5.0;
const ATTACK_RANGE = 5

var player_position := Vector3.ZERO;
var next_nav_point := Vector3.ZERO;
var state_machine

var health := 10.0;

func _ready():
	state_machine = anim_tree.get("parameters/playback")


func _process(delta):
	if not OptionSettings.paused:
		match state_machine.get_current_node():
			"walk":
				player_position = get_tree().get_first_node_in_group("player").global_position;
				nav_agent.set_target_position(player_position);
				next_nav_point = nav_agent.get_next_path_position();
				velocity = (next_nav_point - global_transform.origin).normalized() * SPEED;
				look_at(Vector3(global_position.x + velocity.x, global_position.y, global_position.z + velocity.z), Vector3.UP);
			"attack":
				pass

		
		look_at(Vector3(player_position.x, global_position.y, player_position.z), Vector3.UP);
		
		anim_tree.set("parameters/conditions/attack", _target_in_range())
		anim_tree.set("parameters/conditions/walk", !_target_in_range())
		
		anim_tree.get("parameters/playback")
		
		move_and_slide();

func _target_in_range():
	var distance = pow(abs(pow(player_position.x-global_position.x, 2)+pow(player_position.y-global_position.y,2)),1/2.0)
	return distance < ATTACK_RANGE

func _hurt(damage: float, collider: Object):
	if collider == self:
		if (health - damage) > 0:
			health -= damage;
		else:
			queue_free();
