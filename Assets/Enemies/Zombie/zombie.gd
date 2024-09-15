extends CharacterBody3D;

@onready var player = $".";
@onready var nav_agent = %NavigationAgent3D;

const SPEED = 5.0;


func _ready():
	pass;


func _process(delta):
	if global_position.y != 1:
		global_position.y = 1
	
	var player_position = get_tree().get_first_node_in_group("player").global_position;
	nav_agent.set_target_position(player_position);
	var next_nav_point = nav_agent.get_next_path_position();
	velocity = (next_nav_point-global_transform.origin).normalized() * SPEED;
	
	look_at(Vector3(player_position.x, global_position.y, player_position.z), Vector3.UP);
	#rotaiton.y = lerp_angle(rotation.y, atan2(-velocity.x, -velocity.z), delta * 10.0)
	move_and_slide();
