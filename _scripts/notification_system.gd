class_name NotificationSystem
extends Control

@export var info_icon: Texture2D
@export var warning_icon: Texture2D
@export var error_icon: Texture2D

enum NotificationType {INFO, WARNING, ERROR}

const NOTIFICATION: PackedScene = preload("uid://m8850lgin2x7")

@onready var notif_parent: VBoxContainer = $VBoxContainer

func create_notification(text: String, type: NotificationType) -> Notification:
	var new_notification := NOTIFICATION.instantiate() as Notification
	notif_parent.add_child(new_notification)
	new_notification.notif_text.text = text
	
	var temp_icon: Texture2D
	
	match type:
		NotificationType.INFO:
			temp_icon = info_icon
		NotificationType.WARNING:
			temp_icon = warning_icon
		NotificationType.ERROR:
			temp_icon = error_icon
	
	new_notification.notif_icon.texture = temp_icon
	
	return new_notification
