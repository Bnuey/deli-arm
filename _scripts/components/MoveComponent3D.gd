@icon("res://assets/textures/icons/components/3d/move_component_3d.svg")

## Gives entities the ability to move
class_name MoveComponent3D
extends Node

## This is the node you want to control
@export var actor: Node3D
## Makes movement directional
@export var use_basis: bool = false
## Velocity of the entity
@export var velocity: Vector3


func _physics_process(delta: float) -> void:
	var velocity_cal: Vector3
	if use_basis:
		velocity_cal = actor.transform.basis * velocity * delta
	else:
		velocity_cal = velocity * delta
	
	actor.translate(velocity_cal)
