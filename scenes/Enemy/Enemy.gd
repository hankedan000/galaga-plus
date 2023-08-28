tool
class_name Enemy
extends Area2D

onready var sprite := $Sprite
onready var coll_shape := $CollisionShape

var is_ready = false
var is_in_world = false
var world :BaseWorld= null
var in_formation = true
var health = 1
var rotation_quant_degrees = 0

func _ready():
	is_ready = true
	collision_layer = Constants.COLL_MASK_ENEMY
	collision_mask = Constants.COLL_MASK_SHIP | Constants.COLL_MASK_SHIP_BULLET
	
	# find parent world
	var parent = get_parent()
	while parent:
		if parent is BaseWorld:
			is_in_world = true
			world = parent
			break
		else:
			parent = parent.get_parent()

func _process(delta):
	if ! is_ready:
		return
	coll_shape.global_rotation = 0
	
	if ! in_formation:
		var num_rots = sprite.get_num_rotations()
		var angle_step = 90 / num_rots
		var angle_0to360 = int(global_rotation_degrees) % 360
		if angle_0to360 < 0:
			angle_0to360 = angle_0to360 + 360
		var angle_idx = int(round(angle_0to360 / angle_step))
		rotation_quant_degrees = angle_idx * angle_step
		sprite.global_rotation_degrees = 180 + floor(rotation_quant_degrees / 90) * 90
		sprite.rotation_idx = angle_idx % num_rots

func sprite_type():
	return sprite.sprite_type

func set_in_formation(value: bool):
	in_formation = value
	if in_formation:
		sprite.global_rotation_degrees = 0

func animate(frame_idx):
	var num_animations = sprite.get_num_animations()
	if num_animations <= 1:
		return
	
	if in_formation:
		sprite.set_animation_idx(frame_idx % num_animations)

func hurt():
	health -= 1
	if health <= 0:
		kill()

func kill():
	queue_free()
