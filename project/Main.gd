extends Node2D

const MIN_STAR_VALUE = 1
const MAX_STAR_VALUE = 4

onready var Wheel = $SpinningWheel/Wheel
onready var Pin = $SpinningWheel/ArrowPin

var star_value = 0
var randomizing = false

const POINTS = [
		{"name": "Miojo", "points": 91.5, "stars": 5},
		{"name": "Ruas", "points": 82, "stars": 8},
		{"name": "Tui", "points": 65.35, "stars": 0},
		{"name": "Yan", "points": 66.25, "stars": 0},
		{"name": "Sa", "points": 51.25, "stars": 5},
		{"name": "Gab", "points": 29.6, "stars": 0},
		{"name": "Ro", "points": 26.75, "stars": 0},
		{"name": "Renato", "points": 5, "stars": 0},
		{"name": "Fabio", "points": 1, "stars": 0},
]

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	if randf() > .5:
		$BGM.stream = load("res://assets/bg_music.ogg")
	else:
		$BGM.stream = load("res://assets/bg_music_2.ogg")
	$BGM.play()
	
	Wheel.setup(POINTS, 0)
	Wheel.connect("stopped", self, "wheel_stopped")


func _input(event):
	if event.is_action_pressed("ui_select"):
		randomize_star_value()

	elif event.is_action_pressed("ui_accept"):
		Wheel.spin()

func randomize_star_value():
	$StarRandomizer.randomize_value(MIN_STAR_VALUE, MAX_STAR_VALUE)
	yield($StarRandomizer, "randomized")
	star_value = $StarRandomizer.get_star_value()
	Wheel.setup(POINTS, star_value)

func wheel_stopped():
	yield(get_tree().create_timer(.2),"timeout") #Gambiarra
	$Yay.play()
	var name = Wheel.get_name_in_pos(Pin.get_point())
	$ChosenOne.choose(name)
