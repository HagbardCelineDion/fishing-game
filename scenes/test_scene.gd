extends Node2D

@onready var fish_controller: FishController = $FishController
@onready var fishing_minigame: Game = $FishingMinigame

var fish_on = false
var score = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fish_controller.visible = false
	fishing_minigame.visible = false
	$CanvasLayer/Score.text = "Score: " + str(score)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("space"):
		if not fish_on:
			#start minigame
			fish_controller.visible = false
			fish_on = true
			fish_controller.choose_fish()
			fishing_minigame.initialize_game(fish_controller.get_value())
			fishing_minigame.visible = true
	

func _on_fishing_minigame_game_won() -> void:
	fish_controller.visible = true
	fishing_minigame.visible = false
	print("caught fish!")
	fish_controller.print()
	score += fish_controller.get_value()
	$CanvasLayer/Score.text = "Score: " + str(score)
	await get_tree().create_timer(2).timeout
	fish_on = false


func _on_fishing_minigame_game_lost() -> void:
	fishing_minigame.visible = false
	print("lost the fish!")
	await get_tree().create_timer(2).timeout
	fish_on = false
