extends State

@onready var hand: Hand = $"../.."
@export var joint_parent: Node3D
var joint: PinJoint3D
@onready var hand_sprite: Sprite3D = %HandSprite

func _ready() -> void:
	hand_sprite.texture = hand.hand_info.hand_default

func Enter() -> void:
	print("grabbing" + hand.print_suffix)
	hand_sprite.texture = hand.hand_info.hand_grab
	if hand.hand_info.grabbing:
		hand.global_position = hand.hand_info.grab_point
	
	joint = SetJointPoints(hand, hand.hand_info.grab_obj)

func Update(_delta : float) -> void:
	if Input.is_action_just_released(hand.action_name):
		Transitioned.emit(self, "Default")
	
	

func CreateJoint() -> PinJoint3D:
	joint = PinJoint3D.new()
	joint_parent.add_child(joint)
	joint.set_param(PinJoint3D.PARAM_BIAS, hand.hand_info.bias)
	joint.set_param(PinJoint3D.PARAM_DAMPING, hand.hand_info.damping)
	joint.set_param(PinJoint3D.PARAM_IMPULSE_CLAMP, hand.hand_info.impulse)
	return joint

func SetJointPoints(node_a: Node3D, node_b: Node3D) -> PinJoint3D:
	var new_joint = CreateJoint()
	new_joint.node_a = node_a.get_path()
	new_joint.node_b = node_b.get_path()
	return new_joint

func Physics_Update(_delta : float) -> void:
	pass


func Exit() -> void:
	joint.queue_free()
	hand.hand_info.grab_obj.set_collision_layer_value(4, true)
	hand.hand_info.grabbing = false
	hand.hand_info.grab_point = Vector3.ZERO
	hand.hand_info.grab_obj = null
