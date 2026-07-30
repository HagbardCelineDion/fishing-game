class_name Fisherman
extends Node2D

signal cast_complete

func cast_done() -> void:
	cast_complete.emit()

func cast_animate() -> void:
	$AnimationPlayer.play("cast")

func stand_animate() -> void:
	$AnimationPlayer.stop()
	$Sprite2D.frame = 0

func bite_animate() -> void:
	$AnimationPlayer.play("bite")

func reel_animate() -> void:
	$AnimationPlayer.play("reel")
