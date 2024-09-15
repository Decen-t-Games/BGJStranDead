extends CharacterBody3D;

@onready var nav_agent = $Navigator;
@onready var hitbox: CollisionShape3D = $Hitbox

const SPEED = 5.0;

var player_position := Vector3.ZERO;
var next_nav_point := Vector3.ZERO;

var health := 100.0;

func _ready():
	pass;


func _process(delta):
	if not OptionSettings.paused:
		player_position = get_tree().get_first_node_in_group("player").global_position;
		nav_agent.set_target_position(player_position);
		next_nav_point = nav_agent.get_next_path_position();
		
		velocity = (next_nav_point - global_transform.origin).normalized() * SPEED;
		
		look_at(Vector3(player_position.x, global_position.y, player_position.z), Vector3.UP);
		
		move_and_slide();


func _hurt(damage: float, collider: Object):
	if collider == self:
		if (health - damage) > 0:
			health -= damage;
		else:
			queue_free();
