extends RigidBody2D

signal stopped

const PEG = preload("res://SpinningWheel/Peg.tscn")
const NAME = preload("res://SpinningWheel/Name.tscn")
const MIN_SPEED = 50
const MAX_SPEED = 100

var angles = []
var spinning = false

func _process(_delta):
	var epsilon = .1
	if spinning and angular_velocity <= epsilon:
		spinning = false
		angular_velocity = 0
		emit_signal("stopped")

func _draw():
	randomize()
	var radius = $CollisionShape2D.shape.radius
	for i in range(0, angles.size()):
		var color = hsv_to_rgb(i * 1.0/angles.size(), .7, .9)
		var angle_1 = angles[i]
		var angle_2 = angles[i+1] if i < angles.size() - 1 else 0
		draw_circle_arc(Vector2(0,0), radius, rad2deg(angle_1), rad2deg(angle_2), color)

#func get_name_in_pos(pos):
#	var vec = pos - global_position
#	var angle = vec.angle() - deg2rad(rotation_degrees)
#	var cur_angle = 0
#	for i in range(0, angles.size()):
#		cur_angle += angles[i]
#		if cur_angle >= angle:
## warning-ignore:property_used_as_function
#			return $Names.get_child(i).name()
#	return "aaa"

func get_name_in_pos(pos):
	var min_d = 1000000
	var chosen_name = "Null"
	for name in $Names.get_children():
		if (name.global_position - pos).length() < min_d:
			min_d = (name.global_position - pos).length()
			chosen_name = name.name()
	
	return chosen_name

func draw_circle_arc(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = []
	points_arc.push_back(center)
	var colors = [color]

	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to - angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
		colors.append(color)
	draw_polygon(points_arc, colors)

func setup(distributions : Array, star_value):
	for child in $Pegs.get_children():
		$Pegs.remove_child(child)
	for child in $Names.get_children():
		$Names.remove_child(child)
	
	angles = []
	var total_weight = 0
	var total_pegs = 0
	var radius = $CollisionShape2D.shape.radius
	for distribution in distributions:
		total_pegs += 1
		total_weight += distribution.points + distribution.stars*star_value
	
	var cur_weight = total_weight
	for i in range(0, total_pegs):
		var new_peg = PEG.instance()
		
		var angle = 2*PI * cur_weight/total_weight
		cur_weight -=  distributions[i].points + distributions[i].stars*star_value
		angles.append(angle)
		
		new_peg.position = Vector2(cos(angle - PI/2) * radius, sin(angle - PI/2) * radius)
		$Pegs.add_child(new_peg)
		
		var new_name = NAME.instance()
		var name_angle = (angle + 2*PI * cur_weight/total_weight)/2
		new_name.position = Vector2(cos(name_angle - PI/2) * radius/2, sin(name_angle - PI/2) * radius/2)
		new_name.setup(distributions[i].name, rad2deg(name_angle - PI/2))
		
		$Names.add_child(new_name)
		
		
	update()
	
func spin():
	randomize()
	angular_velocity = rand_range(MIN_SPEED, MAX_SPEED)
	spinning = true

func hsv_to_rgb(h, s, v, a = 1):
	#based on code at
	#http://stackoverflow.com/questions/51203917/math-behind-hsv-to-rgb-conversion-of-colors
	var r
	var g
	var b

	var i = floor(h * 6)
	var f = h * 6 - i
	var p = v * (1 - s)
	var q = v * (1 - f * s)
	var t = v * (1 - (1 - f) * s)

	match (int(i) % 6):
		0:
			r = v
			g = t
			b = p
		1:
			r = q
			g = v
			b = p
		2:
			r = p
			g = v
			b = t
		3:
			r = p
			g = q
			b = v
		4:
			r = t
			g = p
			b = v
		5:
			r = v
			g = p
			b = q
	return Color(r, g, b, a)
