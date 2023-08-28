extends BaseWorld

onready var ship := $Ship
onready var fleet := $Fleet
onready var animation_timer := $AnimationTimer

var animation_frame_idx = 0

func _ready():
	_center_ship()
	_restart_animations()
	for enemy in fleet.get_children():
		enemy.set_in_formation(true)

func _process(delta):
	pass

func _center_ship():
	ship.position.x = world_width() / 2
	ship.position.y = world_height() - ship.height() / 2

func _restart_animations():
	animation_timer.stop()
	animation_frame_idx = 0
	animation_timer.start(1.0)

func _on_AnimationTimer_timeout():
	for enemy in fleet.get_children():
		enemy.animate(animation_frame_idx)
	animation_frame_idx += 1
