extends CharacterBody3D;

@onready var player = $".";
@onready var nav_agent = $Navigator;

const SPEED = 5.0;

var player_position = Vector3.ZERO;


func _ready():
	pass;


func _process(delta):	
	var player_position = get_tree().get_first_node_in_group("player").global_position;
	print(player_position);
	nav_agent.set_target_position(player_position);
	var next_nav_point = nav_agent.get_next_path_position();
	velocity = (next_nav_point - global_position).normalized() * SPEED;
	
	look_at(Vector3(player_position.x, global_position.y, player_position.z), Vector3.UP);
	#rotaiton.y = lerp_angle(rotation.y, atan2(-velocity.x, -velocity.z), delta * 10.0)
	# move_and_slide();
	
	move_and_collide(velocity);
