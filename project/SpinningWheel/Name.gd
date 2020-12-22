extends Node2D


func setup(name, angle):
	$Label.text = name
	$Label.rect_pivot_offset = Vector2(150,50)
	$Label.rect_rotation = angle

func name():
	return $Label.text
