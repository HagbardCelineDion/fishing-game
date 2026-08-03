class_name Fish
extends Resource

@export_group("Fish Stats")
@export var min_length : float
@export var max_length : float
@export var max_value : int
@export var rarity : rarity_list

@export_group("Fish Visuals")
@export var name : String
@export var image : Texture

@export_group("Legendary Info")
@export var has_legendary : bool
@export var legendary_fish : Fish

enum rarity_list {COMMON, UNCOMMON, RARE, LEGENDARY}
var length

func get_value() -> int:
	var spread : float = max_length - min_length
	var peak = min_length + (.8 * spread)
	if length >= peak:
		return max_value
	else:
		var chunk = (.8 * spread) / (max_value - 1)
		var val = (length - min_length) / chunk
		return val + 1

func get_length() -> int:
	return length

func rotate_needed() -> bool:
	return false
