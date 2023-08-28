tool
class_name Bullet
extends Area2D

const MAX_TTL = 1.0 # time to live in seconds

export var is_ship_bullet = true setget _set_is_ship_bullet
export var max_speed = 320.0 / (MAX_TTL - 0.25) # speed in pixels/second

onready var sprite := $Sprite
var lifetime = 0
var velocity = Vector2()
var ready = false

func _ready():
	ready = true
	if is_ship_bullet:
		Globals.ship_bullet_count += 1
	else:
		Globals.enemy_bullet_count += 1

func _process(delta):
	if velocity.length() > 0.1:
		lifetime += delta
		global_position += velocity * delta
		if lifetime >= MAX_TTL:
			kill()

func go():
	if is_ship_bullet:
		velocity = Vector2(0,-max_speed) # ship bullets fly up
	else:
		velocity = Vector2(0,max_speed) # enemy bullets fly down

func kill():
	if is_ship_bullet:
		Globals.ship_bullet_count -= 1
	else:
		Globals.enemy_bullet_count -= 1
	queue_free()

func _set_is_ship_bullet(value):
	is_ship_bullet = value
	if ! ready:
		yield(self, "ready")
	else:
		push_error("can't change bullet type after spawned")
		return
		
	if is_ship_bullet:
		sprite.sprite_type = SmallSprite.SpriteType.ShipBullet
		collision_layer = Constants.COLL_MASK_SHIP_BULLET
		collision_mask = Constants.COLL_MASK_ENEMY
	else:
		sprite.sprite_type = SmallSprite.SpriteType.EnemyBullet
		collision_layer = Constants.COLL_MASK_ENEMY_BULLET
		collision_mask = Constants.COLL_MASK_SHIP

func _on_Bullet_area_entered(area):
	if area.has_method('hurt'):
		area.hurt()
		self.kill()
