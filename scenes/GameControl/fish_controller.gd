class_name FishController
extends Node

@onready var fish_ui: FishUI = $fish_ui

var fish = [
	preload("res://fish/bluegill.tres"),
	preload("res://fish/boot.tres"),
	preload("res://fish/largemouth.tres"),
	preload("res://fish/blackcrappie.tres"),
	preload("res://fish/channelcat.tres"),
	preload("res://fish/perch.tres"),
	preload("res://fish/pumpkinseed.tres"),
]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(2,0).timeout



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func choose_fish() -> void:
	var fish_selection = randi_range(0,fish.size()-1)
	var the_fish = fish[fish_selection]
	fish_ui.fish = the_fish
	fish_ui.print_stats()
