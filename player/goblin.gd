extends CharacterBody2D
class_name Player
const MOTION_SPEED = 600
var last_direction = Vector2(1, 0)
static var PLAYER_LOCATION := Vector2()
var room_positions = {}
var portalRecovery = false
static var teleportationHistory
var gameOverScreen

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

func _ready():
	var rooms_scene = get_parent().get_parent().get_node("Rooms")
	gameOverScreen = get_tree().root.get_node("Dungeon/GameoverScreen")
	print(gameOverScreen.name)

	

	var aRooms = rooms_scene.get_children()
	aRooms.shuffle()
	for i in range(0, aRooms.size(), 2):
			#room_positions[room.name] = room.position
			
			room_positions[str(aRooms[i]).split(":")[0]] = aRooms[i+1]
			room_positions[str(aRooms[i+1]).split(":")[0]] = aRooms[i]

	#for name in room_positions:
		#print(name, ":", room_positions[name])
		#print(name)
	#print(room_positions["room14"])

func _physics_process(_delta):
	#update player location
	PLAYER_LOCATION = Vector2(global_position)
	gameOverScreen.global_position = global_position
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

func _on_portalbody_area_entered(area: Area2D) -> void:
	if not portalRecovery:
		print("Portal entered")
		portalRecovery = true
		global_position = room_positions[str(area.name)].global_position


func _on_portalbody_area_exited(area: Area2D) -> void:
	print("Portal exit")
	var teleportationPosition = room_positions[str(area.name)].global_position
	print(teleportationPosition)
	teleportationHistory = teleportationPosition
	get_parent().get_node("Enemy").countDown()
	var timer = get_tree().root.get_node("Dungeon/Timer")
	timer.start() 
	await timer.timeout


func _on_timer_timeout() -> void:
	print("refresh teleport cooldown")
	portalRecovery = false
