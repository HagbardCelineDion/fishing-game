extends Node2D

@onready var fish_controller: FishController = $FishController
@onready var fishing_minigame: Game = $FishingMinigame
@onready var fisherman: Fisherman = $Fisherman
@onready var score: Label = $CanvasLayer/PanelContainer2/MarginContainer/Score
@onready var wait_timer: Timer = $WaitTimer
@onready var best_fish: Dictionary[String, int] = {}
@onready var fish_deets: Label = $"CanvasLayer/PanelContainer/MarginContainer/CenterContainer/Fish Deets"

enum State {STAND, CASTING, WAIT, BITE, GAME, WON, DISPLAY, DISPLAYING, LOST}

var game_state :State
var fish_on = false
var waiting = false
var overall_score = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_state =  State.STAND
	fish_controller.visible = false
	fishing_minigame.visible = false
	$Bobber.visible = false
	score.text = "Score: " + str(overall_score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if game_state == State.STAND:
		stand()
	elif game_state == State.WAIT:
		wait()
	elif game_state == State.BITE:
		bite()
	elif game_state == State.GAME:
		game()
	elif game_state == State.WON:
		won()
	elif game_state == State.DISPLAY:
		display()
	elif game_state == State.LOST:
		lost()
	#if Input.is_action_just_pressed("space"):
		#if not fish_on:
			##start minigame
			#fish_controller.visible = false
			#fish_on = true
			#fish_controller.choose_fish()
			#fishing_minigame.initialize_game(fish_controller.get_value())
			#fisherman.reel_animate()
			#fishing_minigame.visible = true
	

func _on_fishing_minigame_game_won() -> void:
	game_state = State.WON

func _on_fishing_minigame_game_lost() -> void:
	game_state = State.LOST


func stand() -> void:
	$CanvasLayer/PanelContainer.visible = false
	fish_controller.visible = false
	fisherman.stand_animate()
	if Input.is_action_just_pressed("space"):
		game_state = State.CASTING
		fisherman.cast_animate()
		await Signal(fisherman, "cast_complete")
		$Splash.splash_animate()
		$Bobber.visible = true
		$Bobber.float_animate()
		game_state = State.WAIT

func wait() -> void:
	if not waiting:
		waiting = true
		var wait_time = randf_range(2.2, 6.8)
		await get_tree().create_timer(wait_time,0).timeout
		game_state = State.BITE
		waiting = false

func bite() -> void:
	fisherman.bite_animate()
	$Bobber.bite_animate()
	if Input.is_action_just_pressed("space"):
		game_state = State.GAME

func game() -> void:
	$Bobber.visible = false
	if not fish_on:
		fish_on = true
		#start minigame transfer control to fishing minigame
		fish_controller.visible = false
		fish_controller.choose_fish()
		fishing_minigame.initialize_game(fish_controller.get_value())
		fisherman.reel_animate()
		fishing_minigame.visible = true

func won() -> void:
	fisherman.stand_animate()
	fish_controller.reel_in_animate()
	fish_controller.visible = true
	fishing_minigame.visible = false
	overall_score += fish_controller.get_value()
	score.text = "Score: " + str(overall_score)
	fish_on = false
	
	game_state = State.DISPLAY

func display() -> void:
	if not waiting:
		waiting = true
		game_state = State.DISPLAYING
		wait_timer.start()
		if best_fish.has(fish_controller.return_name()):
			if fish_controller.get_length() > best_fish.get(fish_controller.return_name()):
				best_fish.set(fish_controller.return_name(),fish_controller.get_length())
		else:
			best_fish.set(fish_controller.return_name(),fish_controller.get_length())
		await Signal($FishController,"reeled_in")
		fish_controller.display()
		fish_deets.text = fish_controller.print() + "\nBest: " + str(best_fish.get(fish_controller.return_name()))
		$CanvasLayer/PanelContainer.visible = true
		game_state = State.DISPLAY
	else:
		if wait_timer.is_stopped():
			if Input.is_action_just_pressed("space"):
				game_state = State.STAND
				waiting = false

func lost() -> void:
	if not waiting:
		waiting = true
		fisherman.stand_animate()
		fishing_minigame.visible = false
		fish_on = false
		game_state = State.DISPLAYING
		wait_timer.start()
		fish_deets.text = "Fish got away!"
		$CanvasLayer/PanelContainer.visible = true
		game_state = State.LOST
	else:
		if wait_timer.is_stopped():
			if Input.is_action_just_pressed("space"):
				game_state = State.STAND
				waiting = false
