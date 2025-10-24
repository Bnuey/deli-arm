## Inventory Item Data
class_name InventoryItem
extends Resource


## item icon
@export var icon: Texture
## item name in inventory
@export var item_name: String
## item description
@export_multiline var item_description: String
## amount given on pickup
@export var amount: int
## determines if the item is stackable
@export_enum("STACKABLE", "UNSTACKABLE", "EQUIPABLE") var type: int
