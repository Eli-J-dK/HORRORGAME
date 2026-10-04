extends CharacterBody3D

@onready var neck := $neck
@onready var stam_timer := $neck/stam_regen_timer

@export var SPEED: float
@export var sprint_speed : float
@export var JUMP_VELOCITY: float
@export var slowdown : float

var max_stam : float = 100.0
var current_stam : float
@export var stam_gen : float
@export var jump_stam : float
var can_regen : bool = false

var current_stam_state : int
var new_stam_state : int

func _ready() -> void:
	current_stam = max_stam
	stam_timer.timeout.connect(_on_stam_regen_timer_timeout)
	current_stam_state = 0
	
func _on_stam_regen_timer_timeout() -> void:
	can_regen = true

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if is_on_floor() and current_stam >= 20 and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY
		current_stam -= jump_stam
		stam_timer.stop()
		stam_timer.start()
		new_stam_state = 1
		can_regen = false
		
	var input_dir := Input.get_vector("move_left" , "move_right" , "move_forward" , "move_backward")
	var direction = (neck.transform.basis * Vector3(input_dir.x , 0.0 , input_dir.y)).normalized()
	
	
	if direction:
		if Input.is_action_pressed("sprint") and current_stam > 0 and is_on_floor():
				velocity.x = direction.x * sprint_speed
				velocity.z = direction.z * sprint_speed
				
				stam_timer.stop()
				can_regen = false
				current_stam -= stam_gen * delta
				
				new_stam_state = 1
		elif is_on_floor():
				velocity.x = direction.x * SPEED
				velocity.z = direction.z * SPEED
				
				new_stam_state = 0
		else:
			velocity.x = move_toward(velocity.x , direction.x * SPEED * 0.5 , slowdown)
			velocity.z = move_toward(velocity.z , direction.z * SPEED * 0.5 , slowdown)
	else:
		velocity.x = move_toward(velocity.x , 0 , slowdown)
		velocity.z = move_toward(velocity.z , 0 , slowdown)
		
		new_stam_state = 0
		
	if current_stam_state != new_stam_state:
		current_stam_state = new_stam_state
		stam_timer.start()
	
	if can_regen and current_stam < max_stam:
		current_stam += stam_gen * delta
	
	print(current_stam)
	
	move_and_slide()
