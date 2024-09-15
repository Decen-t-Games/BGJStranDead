extends Node3D;


@onready var mesh = $MeshInstance3D;
@onready var ray = $RayCast3D;

@onready var bullet_material: StandardMaterial3D;
@onready var damage: float;
@onready var speed: float;

# Called when the node enters the scene tree for the first time.
func _ready():
	mesh.set_surface_override_material(0, bullet_material);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not OptionSettings.paused:
		position += transform.basis * Vector3(0, 0, -speed) * delta;
		if ray.is_colliding():
			mesh.visible = false;
			get_tree().call_group("enemies", "_hurt", 10, ray.get_collider());
			queue_free();
		if position.length() > 300.0:
			queue_free();
