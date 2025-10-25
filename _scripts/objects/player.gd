extends CharacterBody3D

@export var stat_manager: StatManager
@export var look_sensitivity: float = 0.005
@export var jump_vel: float = 5.0
@export var walk_speed: float = 7.0

var input_dir := Vector2.ZERO
var wish_dir := Vector3.ZERO

@export var _headbob_move_amount: float = 0.06
@export var _headbob_frequency: float = 2.4
var headbob_time: float = 0.0

@onready var head_pivot: Node3D = %HeadPivot
@onready var camera: Camera3D = %Camera3D


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	elif event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			rotate_y(-event.relative.x * look_sensitivity)
			camera.rotate_x(-event.relative.y * look_sensitivity)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _handle_air_physics(delta: float) -> void:
	self.velocity.y += get_gravity().y * delta
	
	var cur_speed_in_wish_dir = self.velocity.dot(wish_dir)
	var capped_speed = min((global.sv_airmovespeed * wish_dir).length(), global.sv_aircap)
	
	var add_speed_till_cap = capped_speed - cur_speed_in_wish_dir
	
	if add_speed_till_cap > 0:
		var accel_speed = global.sv_airaccelerate * global.sv_airmovespeed * delta
		accel_speed = min(accel_speed, add_speed_till_cap)
		velocity += accel_speed * wish_dir

func _handle_ground_physics(delta: float) -> void:
	var cur_speed_in_wish_dir = velocity.dot(wish_dir)
	var add_speed_till_cap = walk_speed - cur_speed_in_wish_dir
	if add_speed_till_cap > 0:
		var accel_speed = global.sv_groundaccelerate * delta * walk_speed
		accel_speed = min(accel_speed, add_speed_till_cap)
		velocity += accel_speed * wish_dir
	
	# Apply Friction
	var control = max(velocity.length(), global.sv_grounddecelerate)
	var drop = control * global.sv_groundfriction * delta
	var new_speed = max(velocity.length() - drop, 0.0)
	if velocity.length() > 0:
		new_speed /= velocity.length()
		
	velocity *= new_speed
	
	_headbob_effect(delta)

func _process(_delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	input_dir = Input.get_vector("left", "right", "up", "down").normalized()
	wish_dir = self.global_transform.basis * Vector3(-input_dir.x, 0, -input_dir.y)
	
	if is_on_floor():
		#if Input.is_action_just_pressed("jump"):
			#self.velocity.y = jump_vel
		_handle_ground_physics(delta)
	else:
		_handle_air_physics(delta)
	
	move_and_slide()

func _headbob_effect(delta: float) -> void:
	headbob_time += delta * self.velocity.length()
	camera.transform.origin = Vector3(
		cos(headbob_time * _headbob_frequency * 0.5) * _headbob_move_amount,
		cos(headbob_time * _headbob_frequency) * _headbob_move_amount,
		0
		)

func do_jump() -> void:
	self.velocity.y = jump_vel
