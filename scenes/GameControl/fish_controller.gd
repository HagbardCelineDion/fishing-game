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
	preload("res://fish/tire.tres")
]


func choose_fish() -> void:
	fish_ui.position = Vector2(70,92)
	fish_ui.scale = Vector2(1,1)
	var fish_selection = randi_range(0,fish.size()-1)
	var the_fish = fish[fish_selection]
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
