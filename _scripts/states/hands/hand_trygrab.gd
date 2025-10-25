extends State

func Enter() -> void:
	print("trygrab")
	if interact_raycast.get_collider():
		Transitioned.emit(self, "Grabbing")
		TryGrab.emit(interact_raycast.get_collider(), interact_raycast.get_collision_point())
	else:
		print("DORT OUT OF HERE")
		Transitioned.emit(self, "Default")


func Update(_delta : float) -> void:
	pass


func Physics_Update(_delta : float) -> void:
	pass


func Exit() -> void:
	pass
