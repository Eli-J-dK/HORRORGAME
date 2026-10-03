extends CharacterBody3D

@onready var neck := $neck

@export var SPEED: float = 5.0
@export var JUMP_VELOCITY: float


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY
		
	var input_dir := Input.get_vector("move_left" , "move_right" , "move_forward" , "move_backward")
	var direction = (neck.transform.basis * Vector3(input_dir.x , 0.0 , input_dir.y)).normalized()
	
	
	if direction:
		if is_on_floor():
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x , direction.x * SPEED * 0.3 , SPEED)
			velocity.z = move_toward(velocity.z , direction.z * SPEED * 0.3 , SPEED)
	else:
		velocity.x = move_toward(velocity.x , 0 , SPEED)
		velocity.z = move_toward(velocity.z , 0 , SPEED)
	
	move_and_slide()
