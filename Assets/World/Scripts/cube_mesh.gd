extends MeshInstance3D

var speed: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Hello World!");
	print(position);
	scale.x *= 5;
	
	var myNewPos: Vector3 = Vector3(0, 0, 2);
	position = myNewPos;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("forward"):
		position.x += speed * delta;
	elif Input.is_action_pressed("backward"):
		position.x -= speed * delta;
