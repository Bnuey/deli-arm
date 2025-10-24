@icon("res://assets/textures/icons/components/3d/move_input_component_3D.svg")
class_name MoveInputComponent3D
extends Node

@export var stat_manager: StatManager
@export var move_component: MoveComponent3D
@export var active: bool = true:
	set(value):
		active = value
		if not active:
			_disable_input()
@export var left_input: String = "ui_left"
@export var right_input: String = "ui_right"
@export var up_input: String = "ui_up"
@export var down_input: String = "ui_down"

var _move_speed: float
signal last_direction_pressed(direction: String)

func _ready() -> void:
	_move_speed = stat_manager.stats.move_speed if stat_manager else 0

func _physics_process(_delta: float) -> void:
	pass

func _disable_input() -> void:
	move_component.velocity = Vector3.ZERO
