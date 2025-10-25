extends State

@onready var hand: Hand = $"../.."
@onready var hand_sprite: Sprite3D = %HandSprite

signal jump_slam

func Enter() -> void:
	print("default" + hand.print_suffix)
	hand_sprite.texture = hand.hand_info.hand_default


func Update(_delta : float) -> void:
	hand.global_position = hand.default_point.global_position
	
	if hand.interact_raycast.is_colliding():
		Transitioned.emit(self, "CanGrab")
		return
	
	if not Input.is_action_pressed(hand.action_name): return
	
	
	
	if Input.is_action_pressed("switch_hand_mode"):
		if hand.hand_info.deli_arm:
			if hand.ground_raycast.get_collider():
				Jump()
			else:
				Punch()
		else:
			# NOODLE ARM PUNCH OR SMN
			pass



func Jump() -> void: 
	jump_slam.emit()

func Punch() -> void:
	pass

func Physics_Update(_delta : float) -> void:
	pass


func Exit() -> void:
	pass
