extends CharacterBody3D


@export var SPEED: float = 5.0
@export var JUMP_VELOCITY: float


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY
		
	var input_dir := Input.get_vector("move_forward" , "move_backward" , "move_left" , "move_right")
	var direction := Vector3(input_dir.x , 0.0 , input_dir.y).normalized()
	
	
	if direction:
		if is_on_floor():
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
	else:
		pass
	
	move_and_slide()
