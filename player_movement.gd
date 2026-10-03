extends CharacterBody3D

@onready var neck := $neck

@export var SPEED: float
@export var sprint_speed : float
@export var JUMP_VELOCITY: float

@export var air_slowdown : float

var current_move_state : int = 4
var new_move_state : int
@export var stam_regen : float
@export var stam_degen : float
var max_stam : float = 100.0
var current_stam : float = max_stam
var should_stam_change : int = 0
#0 = no movement
#1 = walking
#2 = sprinting
var stam_changing : int = 0


func _stamina_regenerate (delta: float) -> void:
	if current_move_state != new_move_state:
		current_move_state = new_move_state
		
		match should_stam_change:
			0:
				await get_tree().create_timer(3).timeout
				print("not moving")
				
				stam_changing = 0
			1:
				print("moving")
				stam_changing = 1
			2:
				stam_changing = 2

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY
		
	var input_dir := Input.get_vector("move_left" , "move_right" , "move_forward" , "move_backward")
	var direction = (neck.transform.basis * Vector3(input_dir.x , 0.0 , input_dir.y)).normalized()
	
	
	if direction:
		if is_on_floor():
			if Input.is_action_pressed("sprint"):
				velocity.x = direction.x * sprint_speed
				velocity.z = direction.z * sprint_speed
				
				should_stam_change = 2
				new_move_state = 2
			else:
				velocity.x = direction.x * SPEED
				velocity.z = direction.z * SPEED
				
				should_stam_change = 1
				new_move_state = 1
		else:
			velocity.x = move_toward(velocity.x , direction.x * SPEED * 0.5 , air_slowdown)
			velocity.z = move_toward(velocity.z , direction.z * SPEED * 0.5 , air_slowdown)
			
			should_stam_change = 0
			new_move_state = 0
	else:
		velocity.x = move_toward(velocity.x , 0 , SPEED)
		velocity.z = move_toward(velocity.z , 0 , SPEED)
		
		should_stam_change = 0
		new_move_state = 0
		
	match stam_changing:
		0:
			if current_stam < max_stam:
				current_stam += stam_regen * delta
		1:
			if current_stam > 0:
				current_stam -= stam_degen * delta
		2: 
			if current_stam > 0:
				current_stam -= stam_degen * 2 * delta
	
	print(current_stam)
	
	_stamina_regenerate(delta)
	
	move_and_slide()
