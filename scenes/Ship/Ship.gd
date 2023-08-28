tool
extends Area2D

enum ShipType {
	Single,
	Double
}

const MAX_VELOCITY = 240.0 / 3.0 # pixels per second

export(PackedScene) var Bullet = null
export(ShipType) var ship_type = ShipType.Single setget _set_ship_type

onready var single_sprite := $SingleShipSprite
onready var single_coll_shape := $SingleShipCollShape
onready var bullet_spawn_center := $BulletSpawnCenter
onready var double_sprite1 := $DoubleShipSprite1
onready var double_sprite2 := $DoubleShipSprite2
onready var double_coll_shape := $DoubleShipCollShape
onready var bullet_spawn_left := $BulletSpawnLeft
onready var bullet_spawn_right := $BulletSpawnRight

var max_bullets_in_flight = 3
var velocity = Vector2()
var is_ready = false
var is_in_world = false
var world :BaseWorld= null
var x_pos_left_limit = 0
var x_pos_right_limit = 0

func _ready():
	is_ready = true
	collision_layer = Constants.COLL_MASK_SHIP
	collision_mask = Constants.COLL_MASK_ENEMY_BULLET
	
	# find parent world
	var parent = get_parent()
	while parent:
		if parent is BaseWorld:
			is_in_world = true
			world = parent
			break
		else:
			parent = parent.get_parent()
	
	# inits internal variables that are dependant on ship_type
	self._set_ship_type(ship_type)

func _input(event):
	if Input.is_action_just_pressed(ArcadeInput.get_action(Globals.isP1, 'b')):
		shoot()
	
	velocity.x = 0
	if Input.is_action_pressed(ArcadeInput.get_action(Globals.isP1, 'l')):
		velocity.x = -MAX_VELOCITY
	elif Input.is_action_pressed(ArcadeInput.get_action(Globals.isP1, 'r')):
		velocity.x = +MAX_VELOCITY

func _process(delta):
	# handle ship movement logic
	if velocity.length() > 0.1:
		global_position += velocity * delta
		# don't let ship go past the left side of the world
		if global_position.x < x_pos_left_limit:
			global_position.x = x_pos_left_limit
		# don't let ship go past the right side of the world
		if global_position.x > x_pos_right_limit:
			global_position.x = x_pos_right_limit

func _set_ship_type(value):
	ship_type = value
	if ! is_ready:
		yield(self,"ready")
	
	match(ship_type):
		ShipType.Single:
			max_bullets_in_flight = 3
			single_sprite.show()
			single_coll_shape.disabled = false
			double_sprite1.hide()
			double_sprite2.hide()
			double_coll_shape.disabled = true
		ShipType.Double:
			max_bullets_in_flight = 3 * 2
			single_sprite.hide()
			single_coll_shape.disabled = true
			double_sprite1.show()
			double_sprite2.show()
			double_coll_shape.disabled = false
			
	if is_in_world:
		var half_width = width() / 2.0
		x_pos_left_limit = half_width
		x_pos_right_limit = world.world_width() - half_width

func width():
	match(ship_type):
		ShipType.Single:
			return single_sprite.sprite_width()
		ShipType.Double:
			return single_sprite.sprite_width() * 2
	
func height():
	match(ship_type):
		ShipType.Single:
			return single_sprite.sprite_height()
		ShipType.Double:
			return single_sprite.sprite_height()

func hurt():
	kill()

func kill():
	queue_free()

func _spawn_bullet(parent, global_pos):
	var bullet :Bullet= Bullet.instance()
	bullet.is_ship_bullet = true
	bullet.global_position = global_pos
	parent.add_child(bullet)
	bullet.go()

func shoot():
	var parent = get_parent()
	if ! Bullet:
		return
	elif ! parent:
		return
	elif Globals.ship_bullet_count >= max_bullets_in_flight:
		return
	
	match(ship_type):
		ShipType.Single:
			_spawn_bullet(parent, bullet_spawn_center.global_position)
		ShipType.Double:
			_spawn_bullet(parent, bullet_spawn_left.global_position)
			_spawn_bullet(parent, bullet_spawn_right.global_position)
