extends CharacterBody3D
class_name Hand

var grab_pos : Vector3
var grabbed_object: Node3D
@export var action_name: String
@export var default_point: Node3D
@export var print_suffix: String
@export var ground_raycast: RayCast3D
@export var interact_raycast: RayCast3D
@export var hand_info: HandInfo
