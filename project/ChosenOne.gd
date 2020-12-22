extends Node2D


func choose(name):
	$Label.text = name
	$AnimationPlayer.play("pop")
