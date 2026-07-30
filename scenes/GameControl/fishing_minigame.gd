class_name Game
extends Node2D

@onready var player: Area2D = $Player
@onready var fish: Area2D = $Fish
@onready var progress_bar: ProgressBar = $Control/ProgressBar

@export var fish_continue_chance = .99
@export var fish_velocity: float = 30

signal game_won
signal game_lost

const gravity : float = 100
const bounce : float = -10000

var fish_seconds: int = 7
var touching_fish: bool = false
var player_velocity : float = 0

#game logic vars
var fish_start: bool = false
var game_started: bool = false
var playing: bool = false

func _ready() -> void:
	pass

func initialize_game(value: int) -> void:
	fish.position.y = randi_range(-24,24)
	player.position.y = randi_range(-10, 10)
	if randi_range(0, 1):
		fish_velocity *= -1
	progress_bar.value = 0
	fish_seconds = value + 1
	fish_start = false
	game_started = false
	playing = true

func _process(delta: float) -> void:
	touching_fish = false
	if player.has_overlapping_areas():
		var areas: Array[Area2D] = player.get_overlapping_areas()
		for area in areas:
			if area.is_in_group("BotWall"):
				player_velocity = -.9 * absf(player_velocity)
			elif area.is_in_group("TopWall"):
				player_velocity = .9 * absf(player_velocity)
			elif area.is_in_group("Fish"):
				touching_fish = true
	
	#handle game logic
	if touching_fish:
		progress_bar.value += (100/fish_seconds) * delta
		if not fish_start:
			fish_start = true
			get_tree().create_timer(2,0).timeout.connect(start_game)
	else:
		progress_bar.value -= (100/(4)) * delta
	
	#handle end of game
	if progress_bar.value == 100:
		if playing:
			game_won.emit()
		playing = false
	elif progress_bar.value == 0 and game_started:
		if playing:
			game_lost.emit()
		playing = false
	
	#handle movement of player
	player_apply_gravity(delta)
	handle_input(delta)
	player_move(delta)
	
	#handle movement of fish
	if fish.has_overlapping_areas():
		var areas: Array[Area2D] = fish.get_overlapping_areas()
		for area in areas:
			if area.is_in_group("BotWall"):
				fish_velocity = -1 * absf(fish_velocity)
			if area.is_in_group("TopWall"):
				fish_velocity = absf(fish_velocity)
	fish_move(delta)

func player_apply_gravity(delta: float) -> void:
	if player_velocity > 0:
		player_velocity += (gravity + 30) * delta
	else:
		player_velocity += gravity * delta

func fish_move(delta: float) -> void:
	var cont: float = randf()
	if (cont > fish_continue_chance):
		fish_velocity *= -1
	fish.position.y += fish_velocity * delta

func handle_input(delta: float) -> void:
	if Input.is_action_just_pressed("space"):
		player_velocity += bounce * delta

func player_move(delta) -> void:
	player.position.y += player_velocity * delta

func start_game() -> void:
	#used so that the game doesn't end instantly if you touch the fish for a brief period right at the start
	game_started = true
