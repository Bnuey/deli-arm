@icon("res://assets/textures/icons/components/3d/pickup_component_3d.svg")

## Gives objects the abiliy to be picked up
class_name PickupComponent3D
extends Area3D

@export var audio_player : AudioStreamPlayer3D
@export var visual : Node3D

## Item data
@export var item_data: InventoryItem
signal item_picked_up

func pickup() -> void:
	item_picked_up.emit()
	if visual: visual.hide()
	if audio_player:
		audio_player.play()
		await audio_player.finished
	queue_free()
