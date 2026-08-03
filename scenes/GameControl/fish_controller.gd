class_name FishController
extends Node

@onready var fish_ui: FishUI = $fish_ui
signal reeled_in

var fish = [
	preload("res://fish/bluegill.tres"),
	preload("res://fish/boot.tres"),
	preload("res://fish/largemouth.tres"),
	preload("res://fish/blackcrappie.tres"),
	preload("res://fish/channelcat.tres"),
	preload("res://fish/perch.tres"),
	preload("res://fish/pumpkinseed.tres"),
	preload("res://fish/smallmouth.tres"),
	preload("res://fish/tire.tres"),
	preload("res://fish/lakesturgeon.tres"),
]

#fish choosing stuff
var common_fish = []
var uncommon_fish = []
var rare_fish = []
var legendary_fish = []
const COMMON_CHANCE: float = .6
const UNCOMMON_CHANCE: float = .3
const RARE_CHANCE: float = .1
const LEGENDARY_CHANCE: float = .05

func _ready() -> void:
#organize fish by rarity
	for i in fish:
		if i.rarity == Fish.rarity_list.COMMON:
			common_fish.append(i)
		elif i.rarity == Fish.rarity_list.UNCOMMON:
			uncommon_fish.append(i)
		elif i.rarity == Fish.rarity_list.RARE:
			rare_fish.append(i)
		else:
			legendary_fish.append(i)


func choose_fish() -> void:
	var fish_selection
	var the_fish: Fish
	fish_ui.position = Vector2(70,92)
	fish_ui.scale = Vector2(1,1)
	var rarity = randf()
	print(rarity)
	if (rarity <= COMMON_CHANCE):
		fish_selection = randi_range(0,common_fish.size()-1)
		the_fish = common_fish[fish_selection]
		print(the_fish.name)
	elif (rarity <= COMMON_CHANCE + UNCOMMON_CHANCE):
		fish_selection = randi_range(0,uncommon_fish.size()-1)
		the_fish = uncommon_fish[fish_selection]
		print(the_fish.name)
	elif (rarity <= COMMON_CHANCE + UNCOMMON_CHANCE + RARE_CHANCE):
		fish_selection = randi_range(0,rare_fish.size()-1)
		the_fish = rare_fish[fish_selection]
		print(the_fish.name)
	
	if the_fish.has_legendary:
		var is_leg = randf()
		if (is_leg <= LEGENDARY_CHANCE):
			the_fish = the_fish.legendary_fish
	fish_ui.fish = the_fish

func get_value() -> int:
	return fish_ui.fish.get_value()
	
func print() -> String:
	return fish_ui.print_stats()

func reel_in_animate() -> void:
	var tween = create_tween()
	tween.tween_property($fish_ui, "position", Vector2(70,92),1.5).from(Vector2(70,105))
	await get_tree().create_timer(1.5).timeout
	reeled_in.emit()

func display() -> void:
	var pos_tween = create_tween()
	var scale_tween = create_tween()
	pos_tween.tween_property($fish_ui, "position", Vector2(64,42),1)
	scale_tween.tween_property($fish_ui,"scale",Vector2(2,2),1)
	fish_ui.do_rotate()

func return_name() -> String:
	return fish_ui.return_name()

func get_length() -> int:
	return fish_ui.get_length()
