extends CharacterBody3D;

# Onready variables
@onready var camera: Camera3D = $CameraHolder/Camera3D;
@onready var health_bar: ProgressBar = $CameraHolder/Camera3D/UIHolder/UI/VBoxContainer/HealthBar
@onready var stamina_bar: ProgressBar = $CameraHolder/Camera3D/UIHolder/UI/VBoxContainer/StaminaBar
@onready var anim_player: AnimationPlayer = $AnimationPlayer;
@onready var ui: Control = $CameraHolder/Camera3D/UIHolder/UI

# Player motion control
const AIR_SPEED_DIMINISH := 1.0;
const JUMP_VELOCITY := 4.5;
const MOUSE_SENS := 0.2;
const GRAVITY := Vector3(0, -15.0, 0);

# Sprint Constants
const NORMAL_FOV := 75.0;
const ZOOMED_FOV := 85.0;
const FOV_SPEED := 3.0;
const SPRINT_DIMINISH_RATE := 10.0;  # Diminish sprint by 20 per second when sprinting
const SPRINT_RECOVERY_RATE := 10.0;  # Recover sprint by 10 per second when not sprinting
const SPRINT_RECOVERY_DELAY := 0.5; # Delay recovery for half a second after sprinting
const MIN_STAMINA_RESUME_FROM_NONE := 10.0;

# Attack Constants:
const ATTACK_COOLDOWN := 0.5;

# Health Constant:
const DEFAULT_HEALTH := 100.0;

# Speed and Sprint variables
var speed := 7.5;
var sprint_delta := 0.0; # Speed Change
var stamina := 100.0;
var can_sprint := true;
var stamina_recovery_timer := 0.0;  # Tracks time after sprinting via delta

# Attack and health Variables:
var attack_recovery_timer := 0.0; # Tracks time after shooting via delta
var zoom_recovery_timer := 0.0;
var is_zooming := false;
var health := DEFAULT_HEALTH;

# UI Variables:
var ui_hidden := false;

func _ready() -> void:
	reset();

func _input(event) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED and not OptionSettings.paused:
		rotate_y(deg_to_rad(event.relative.x * -MOUSE_SENS));
	
	#if event.is_action_pressed("ui_cancel"):
	#	if ui_hidden:
	#		ui.show();
	#		ui_hidden = false;
	#	else:
	#		ui.hide();
	#		ui_hidden = true;
	if event.is_action_pressed("exit"):
		get_tree().quit();

func _physics_process(delta: float) -> void:
	speed = 7.5;
	if not OptionSettings.paused:
		# Add the gravity.
		if not is_on_floor():
			velocity += GRAVITY * delta;
			speed -= AIR_SPEED_DIMINISH;

		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY;
	
		# Sprint
		move_and_sprint(delta);
	
		# Attack
		if Input.is_action_pressed("attack"):
			get_tree().call_group("weapons", "_weapon_fire", delta);
	
		# UI Handling
		manage_ui();

		# Move the player
		move_and_slide();

func sprint_prep() -> void:
	camera.fov = NORMAL_FOV;
	stamina_bar.value = stamina;


func move_and_sprint(delta) -> void:
	# Get the input direction and handle movement
	var input_dir := Input.get_vector("left", "right", "forward", "backward");
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized();

	# Handle sprinting and movement speed
	if direction:
		velocity.x = move_toward(velocity.x, direction.x * (speed + sprint_delta), 2.0);
		velocity.z = move_toward(velocity.z, direction.z * (speed + sprint_delta), 2.0);
	else:
		# Apply friction/drag
		velocity.x = move_toward(velocity.x, 0, speed);
		velocity.z = move_toward(velocity.z, 0, speed);
	if Input.is_action_pressed("sprint") and stamina > 0 and can_sprint and direction:
		camera.fov = move_toward(camera.fov, ZOOMED_FOV, FOV_SPEED);
		sprint_delta = 5.0;  # Increase speed while sprinting
		stamina -= SPRINT_DIMINISH_RATE * delta;  # Decrease sprint amount over time
		stamina_recovery_timer = 0.0;  # Reset recovery timer
	else:
		camera.fov = move_toward(camera.fov, NORMAL_FOV, FOV_SPEED);
		sprint_delta = 0.0;

		# Start recovery after the delay (when player stops sprinting)
		stamina_recovery_timer += delta	
		if stamina_recovery_timer >= SPRINT_RECOVERY_DELAY:	
			if stamina < MIN_STAMINA_RESUME_FROM_NONE:
				can_sprint = false;
			else:
				can_sprint = true;
			stamina += SPRINT_RECOVERY_RATE * delta;  # Recover sprint after delay

	# Clamp the sprint amount between 0 and 100
	stamina = clamp(stamina, 0, 100);

func reduce_health(amount: float):
	if health - amount > 0:
		health -= amount;
	else:
		incur_death();


func manage_ui() -> void:
	stamina_bar.set_value(stamina);
	health_bar.set_value(health);


func reset():
	position = Vector3.ZERO;
	rotation = Vector3(0.0, 0.0, 0.0);
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
	sprint_prep();
	

func incur_death():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);
	position = Vector3.ZERO;


func run_gun_animation(weapon: String) -> void:
	if not anim_player.is_playing():
		if weapon == "plasma_rifle":
			anim_player.play("shoot");


func _handle_pause():
	if OptionSettings.paused:
		ui.hide();
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);
	else:
		ui.show();
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
