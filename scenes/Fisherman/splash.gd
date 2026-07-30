class_name Splash
extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_2d.visible = false

func visible() -> void:
	sprite_2d.visible = true

func invisible() -> void:
	sprite_2d.visible = false

func splash_animate() -> void:
	$AnimationPlayer.play("splash")
