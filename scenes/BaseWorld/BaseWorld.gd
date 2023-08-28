class_name BaseWorld
extends Node2D

onready var camera := $Camera

func flip_world(forP1):
	if forP1:
		camera.rotation_degrees = 0
	else:
		camera.rotation_degrees = 180

func world_width():
	return 240
	
func world_height():
	return 320
