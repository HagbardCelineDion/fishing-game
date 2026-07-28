class_name FishUI
extends Control

@export var fish: Fish : set = _set_fish

@onready var sprite: Sprite2D = $sprite


func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _set_fish(value : Fish) -> void:
	if not is_node_ready():
		await ready
	
	fish = value
	if fish.rotate_needed():
		sprite.rotation_degrees = 0
	else:
		sprite.rotation_degrees = -90
	
	var mean := (fish.max_length - fish.min_length)/2.0
	var dev : float = mean/3.0
	var rand = randfn(mean, dev) + fish.min_length
	fish.length = clamp(snapped(rand,0.1), fish.min_length, fish.max_length)
	$sprite.texture = fish.image

func print_stats() -> void:
	print("____________________")
	print(fish.name)
	print("length: " + str(fish.get_length()))
	print("value: " + str(fish.get_value()))
