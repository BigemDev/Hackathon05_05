extends CharacterBody2D

var navigation: NavigationRegion2D

const MOTION_SPEED = 50 # Pixels/second.

var direction = Vector2.ZERO
var last_direction = Vector2.RIGHT

var anim_directions = {
	"idle": [
		["side_right_idle", false],
		["45front_right_idle", false],
		["front_idle", false],
		["45front_left_idle", false],
		["side_left_idle", false],
		["45back_left_idle", false],
		["back_idle", false],
		["45back_right_idle", false],
	],
	"walk": [
		["side_right_walk", false],
		["45front_right_walk", false],
		["front_walk", false],
		["45front_left_walk", false],
		["side_left_walk", false],
		["45back_left_walk", false],
		["back_walk", false],
		["45back_right_walk", false],
	],
}

func _ready():
	navigation = get_node("/root/Dungeon/NavigationRegion2D")

func updateDirection():
	var map_rid = navigation.get_navigation_map()
	var path = NavigationServer2D.map_get_path(
		map_rid,
		global_position,
		Player.PLAYER_LOCATION,
		false
	)

	if path.size() > 1:
		direction = (path[1] - global_position).normalized()
	else:
		direction = Vector2.ZERO

func _physics_process(_delta):
	updateDirection()

	var motion = direction
	motion.y /= 2.0
	motion = motion.normalized() * MOTION_SPEED

	set_velocity(motion)
	move_and_slide()

	if motion.length() > 0:
		last_direction = motion
		update_animation("walk")
	else:
		update_animation("idle")


func update_animation(anim_set):
	var angle = rad_to_deg(last_direction.angle())
	angle = fmod(angle + 360 + 22.5, 360)
	var slice_dir = int(floor(angle / 45.0)) % 8

	var anim = anim_directions[anim_set][slice_dir]
	$Sprite2D.play(anim[0])
	$Sprite2D.flip_h = anim[1]
