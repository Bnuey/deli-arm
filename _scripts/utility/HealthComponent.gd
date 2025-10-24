@icon("res://assets/textures/icons/components/node/health_component.svg")
## This component manages Player health
class_name HealthComponent
extends Node

@export var stat_manager: StatManager


# These only return the private variable and cannot be set
var health: float:
	get:
		return _health
var max_health: float:
	get:
		return _max_health

# Entity health property
var _health : float:
	set(value):
		_health = value
		health_changed.emit(_health)
# Entity maximum health property
var _max_health : float:
	set(value):
		_max_health = value
		max_health_changed.emit(_max_health)

## Is emit when damage occurs
signal damage_taken(value: float)
## Is emit when health is changed
signal health_changed(health: float)
## Is emit when max health is changed
signal max_health_changed(max_health: float)
## Is emit when health is depleted
signal health_depleted


func _ready() -> void:
	if !stat_manager:
		DebugConsole.log_error(name + ": Stat Manager is not defined")
		return

	stat_manager.on_prop_changed.connect(_on_stat_updated)
	_health = stat_manager.stats.health
	_max_health = stat_manager.stats.max_health


## Reduces the health by the provided value
func damage(value : float) -> void:
	_health = clamp(_health - value, 0, _max_health)
	#health_changed.emit(_health)
	damage_taken.emit(value)

	if _health == 0:
		health_depleted.emit()

## Adds value to health property
func increase_max_health(value : float) -> void:
	_max_health = max(_max_health + value, 0)
	max_health_changed.emit(_max_health)
	#health_changed.emit(_health)


func _on_stat_updated(prop: String, value: float) -> void:
	match prop:
		"health":
			_health = value
		"max_health":
			_max_health = value
			#_health = max_health
