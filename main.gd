extends Node2D

var curr_world = null

var BattleWorld := preload("res://scenes/BattleWorld/BattleWorld.tscn")

func _ready():
	set_world(BattleWorld.instance())

func get_world():
	return curr_world
	
func set_world(new_world):
	if curr_world:
		remove_child(curr_world)
	add_child(new_world)
	curr_world = new_world
