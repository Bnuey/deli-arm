extends State

@onready var hand: Hand = $"../.."
@onready var hand_sprite: Sprite3D = %HandSprite

func Enter() -> void:
	hand_sprite.texture = hand.hand_info.hand_up


func Update(_delta : float) -> void:
	if not hand.interact_raycast.is_colliding():
		Transitioned.emit(self, "Default")
		return
	
	if not Input.is_action_pressed(hand.action_name): return
	
	Grab()
	
func Grab() -> void:
	var collider = hand.interact_raycast.get_collider()
	
	if not collider: return
	
	hand.hand_info.grab_point = hand.interact_raycast.get_collision_point()
	hand.hand_info.grab_obj = hand.interact_raycast.get_collider()
	hand.hand_info.grabbing = true
	collider.set_collision_layer_value(4, false)
	
	Transitioned.emit(self, "Grabbing")

func Physics_Update(_delta : float) -> void:
	pass


func Exit() -> void:
	pass
