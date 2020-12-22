extends Node2D

const TIME = 2.5

signal randomized

var randomizing = false
var min_value = 0
var max_value = 100
var star_value = 0

func _process(_delta):
	if randomizing:
		$HBoxContainer/Label.text = str(round(rand_range(min_value, max_value)))

func randomize_value(min_v, max_v):
	if randomizing:
		return
	
	min_value = min_v
	max_value = max_v
	randomizing = true
	
	yield(get_tree().create_timer(TIME), "timeout")
	
	randomizing = false
	
	randomize()
	star_value = round(rand_range(min_value, max_value))
	$HBoxContainer/Label.text = str(star_value)
	
	emit_signal("randomized")

func get_star_value():
	return star_value
	
