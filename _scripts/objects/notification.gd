class_name Notification
extends Control

@onready var notif_icon: TextureRect = %Notif_Icon
@onready var notif_text: Label = %Notif_Text


func _on_timer_timeout() -> void:
	queue_free()

func _enter_tree() -> void:
	pass
