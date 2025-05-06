extends CharacterBody2D
class_name Player
const MOTION_SPEED = 160 # Pixels/second.
var last_direction = Vector2(1, 0)
static var PLAYER_LOCATION := Vector2()
<<<<<<< Updated upstream
var gameOverScreen
var gameOver

func _ready():
	gameOverScreen = get_tree().root.get_node("Dungeon/GameoverScreen")
	print(gameOverScreen.name)
=======
var teleportDefense = 0
>>>>>>> Stashed changes

var anim_directions = {
	"idle": [ # list of [animation name, horizontal flip]
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


func _physics_process(_delta):
	#update player location
	PLAYER_LOCATION = Vector2(global_position)
	gameOverScreen.position = global_position
	#print(PLAYER_LOCATION)
	var motion = Vector2()
	motion.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	motion.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	motion.y /= 2
	motion = motion.normalized() * MOTION_SPEED
	#warning-ignore:return_value_discarded
	set_velocity(motion)
	move_and_slide()
	var dir = velocity

	if dir.length() > 0:
		last_direction = dir
		update_animation("walk")
	else:
		update_animation("idle")


func update_animation(anim_set):

	var angle = rad_to_deg(last_direction.angle()) + 22.5
	var slice_dir = floor(angle / 45)

	$Sprite2D.play(anim_directions[anim_set][slice_dir][0])
	$Sprite2D.flip_h = anim_directions[anim_set][slice_dir][1]

func lose_game():
	gameOverScreen.show()
	get_tree().paused = 1
	print("PORAŻKA")
<<<<<<< Updated upstream
=======


func _on_teleport_body_area_entered(area: Area2D) -> void:
	if teleportDefense == 0: 
		print("TELEPORT ENTERED")
		teleportDefense = 1


func _on_teleport_body_area_exited(area: Area2D) -> void:
	print("TELEPORT LEFT")
	teleportDefense = 0
>>>>>>> Stashed changes
