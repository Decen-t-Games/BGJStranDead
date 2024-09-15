extends Node3D;

@onready var ui_holder: Node3D = $Camera3D/UIHolder;
@onready var player: CharacterBody3D = $".."

const MOUSE_SENS := 0.2;
const VERT_BOB_TIME_SENS := 15.0;
const HORI_BOB_TIME_SENS := 7.5;
const PLAYER_SPEED_BOB_SENS := 2.0;
const VERTICAL_BOB_SENS := 0.02;
const HORIZONTAL_BOB_SENS := 0.02;
const BOBBING_REVERSAL_CONSTANT := 0.05;

var vert_moving_time = 0;
var hori_moving_time = 0;
var current_delta: Vector3;
var initial_pos: Vector3;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initial_pos = position;

func _input(event) -> void:
	if event is InputEventMouseMotion and not OptionSettings.paused:
		rotate_x(deg_to_rad(event.relative.y * -MOUSE_SENS));


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	current_delta = player.get_position_delta();
	handle_vertical_bob(delta, current_delta);
	handle_horizontal_bob(delta, current_delta);
	rotation.x = clamp(rotation.x, deg_to_rad(-65), deg_to_rad(90));


func handle_vertical_bob(delta: float, current_delta: Vector3) -> void:
	if current_delta != Vector3.ZERO and player.is_on_floor():
		vert_moving_time += delta * VERT_BOB_TIME_SENS;
		position.y += sin(vert_moving_time) * VERTICAL_BOB_SENS;
	else:
		vert_moving_time = 0;
		position.y = move_toward(position.y, initial_pos.y, BOBBING_REVERSAL_CONSTANT);

func handle_horizontal_bob(delta: float, current_delta: Vector3) -> void:
	if current_delta != Vector3.ZERO and player.is_on_floor():
		hori_moving_time += delta * HORI_BOB_TIME_SENS;
		position.x += cos(hori_moving_time) * HORIZONTAL_BOB_SENS;
	else:
		hori_moving_time = 0;
		position.x = move_toward(position.x, initial_pos.x, BOBBING_REVERSAL_CONSTANT);
		
