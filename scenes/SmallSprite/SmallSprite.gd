tool
class_name SmallSprite
extends Sprite

enum SpriteType {
	ShipWhite,
	ShipRed,
	GalagaGreen,
	GalagaPurple,
	ShipBullet,
	EnemyBullet
}

export(SpriteType) var sprite_type := SpriteType.ShipWhite setget _set_sprite_type

const GRID = 16
const PAD = 2
var is_animation = false
var animation_idx = 0
var rotation_idx = 0
var type_lut = {
	SpriteType.ShipWhite : {'x':1, 'y':1, 'w':GRID, 'h':GRID, 'n_rotations':6, 'n_animations':1},
	SpriteType.ShipRed : {'x':1, 'y':19, 'w':GRID, 'h':GRID, 'n_rotations':6, 'n_animations':1},
	SpriteType.GalagaGreen : {'x':1, 'y':37, 'w':GRID, 'h':GRID, 'n_rotations':6, 'n_animations':2},
	SpriteType.GalagaPurple : {'x':1, 'y':55, 'w':GRID, 'h':GRID, 'n_rotations':6, 'n_animations':2},
	SpriteType.ShipBullet : {'x':307, 'y':118, 'w':GRID, 'h':GRID, 'n_rotations':1, 'n_animations':0},
	SpriteType.EnemyBullet : {'x':307, 'y':136, 'w':GRID, 'h':GRID, 'n_rotations':0, 'n_animations':0}
}

func get_num_animations():
	return type_lut[sprite_type].n_animations

func get_num_rotations():
	return type_lut[sprite_type].n_rotations

func sprite_width():
	return type_lut[sprite_type].w

func sprite_height():
	return type_lut[sprite_type].h

func set_animation_idx(value):
	is_animation = true
	var num_anims = get_num_animations()
	if num_anims == 0:
		animation_idx = 0
	elif value < num_anims:
		animation_idx = value
	else:
		animation_idx = num_anims - 1
	_update_region()

func set_rotation_idx(value):
	is_animation = false
	var num_rots = get_num_rotations()
	if num_rots == 0:
		rotation_idx = 0
	elif value < num_rots:
		rotation_idx = value
	else:
		rotation_idx = num_rots - 1
	_update_region()

func _set_sprite_type(value):
	sprite_type = value
	var num_rots = get_num_rotations()
	if num_rots == 0:
		rotation_idx = 0
	elif rotation_idx >= num_rots:
		rotation_idx = num_rots - 1
	_update_region()

func _update_region():
	var lut_info = type_lut[sprite_type]
	if is_animation:
		region_rect.position.x = lut_info.x + ((lut_info.w + PAD) * (lut_info.n_rotations + animation_idx))
	else:
		region_rect.position.x = lut_info.x + ((lut_info.w + PAD) * rotation_idx)
	region_rect.position.y = lut_info.y
	region_rect.size.x = lut_info.w
	region_rect.size.y = lut_info.h
