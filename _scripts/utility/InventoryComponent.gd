@icon("res://assets/textures/icons/components/node/inventory_component.svg")
class_name InventoryComponent
extends Node

## The inventory dictionary containing items
var inventory: Dictionary = {}:
	set(value):
		inventory = value
		update()

## Signal emitted when the inventory is updated.
signal updated(inventory: Dictionary)

## Called when the node is added to the scene tree.
func _ready() -> void:
	# Initialize inventory if needed
	if inventory == null:
		inventory = {}
	
	# Emit initial update signal
	update()

## Emits an update signal with the current inventory.
func update() -> void:
	#prints("inv:", inventory)
	updated.emit(inventory)

## Adds an item to the inventory.
## Items can be stackable, unstackable, or equipable.
func add_item(item: InventoryItem) -> void:
	var item_icon: Texture = item.icon
	var item_name: String = item.item_name
	var item_amount: int = item.amount
	
	match item.type:
		# Stackable items
		0:
			if not inventory.has(item_name):
				inventory[item_name] = {
					"icon": item_icon,
					"amount": item_amount
				}
			else:
				inventory[item_name]["amount"] += item_amount

		# Unstackable items
		1:
			if not inventory.has("unstackable"):
				inventory["unstackable"] = {}
			if not inventory["unstackable"].has(item_name):
				inventory["unstackable"][item_name] = {
					"icon": item_icon,
					"amount": item_amount
				}
			else:
				inventory["unstackable"][item_name]["amount"] += item_amount

		# Equipable items
		2:
			if not inventory.has("equipable"):
				inventory["equipable"] = {}
			if not inventory["equipable"].has(item_name):
				inventory["equipable"][item_name] = {
					"icon": item_icon,
					"amount": item_amount
				}
			else:
				inventory["equipable"][item_name]["amount"] += item_amount

	# Emit an update signal.
	update()

## Removes an item from the inventory.
## Returns true if successful, false if the item doesn't exist or not enough quantity.
## If amount is -1, removes all of the specified item.
func remove_item(item_name: String, amount: int = 1, item_type: int = 0) -> bool:
	var success: bool = false
	
	match item_type:
		# Stackable items
		0:
			if inventory.has(item_name):
				if amount == -1 or inventory[item_name]["amount"] <= amount:
					# Remove the entire item entry
					inventory.erase(item_name)
				else:
					# Reduce the amount
					inventory[item_name]["amount"] -= amount
				success = true
		
		# Unstackable items
		1:
			if inventory.has("unstackable") and inventory["unstackable"].has(item_name):
				if amount == -1 or inventory["unstackable"][item_name]["amount"] <= amount:
					# Remove the entire item entry
					inventory["unstackable"].erase(item_name)
					# If unstackable category is now empty, remove it
					if inventory["unstackable"].is_empty():
						inventory.erase("unstackable")
				else:
					# Reduce the amount
					inventory["unstackable"][item_name]["amount"] -= amount
				success = true
		
		# Equipable items
		2:
			if inventory.has("equipable") and inventory["equipable"].has(item_name):
				if amount == -1 or inventory["equipable"][item_name]["amount"] <= amount:
					# Remove the entire item entry
					inventory["equipable"].erase(item_name)
					# If equipable category is now empty, remove it
					if inventory["equipable"].is_empty():
						inventory.erase("equipable")
				else:
					# Reduce the amount
					inventory["equipable"][item_name]["amount"] -= amount
				success = true
	
	# Only update if we successfully removed an item
	if success:
		update()
	
	return success
	
## Get the count of a specific item in the inventory
func get_item_count(item_name: String, item_type: int = 0) -> int:
	match item_type:
		# Stackable items
		0:
			if inventory.has(item_name):
				return inventory[item_name]["amount"]
		
		# Unstackable items
		1:
			if inventory.has("unstackable") and inventory["unstackable"].has(item_name):
				return inventory["unstackable"][item_name]["amount"]
		
		# Equipable items
		2:
			if inventory.has("equipable") and inventory["equipable"].has(item_name):
				return inventory["equipable"][item_name]["amount"]
	
	return 0
	
## Clear the inventory completely
func clear() -> void:
	inventory.clear()
	update()
