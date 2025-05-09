extends CharacterBody2D
class_name Player
const MOTION_SPEED = 160
var last_direction = Vector2(1, 0)
static var PLAYER_LOCATION := Vector2()
var room_positions = {}
var portalRecovery = false
static var teleportationHistory
var gameOverScreen
var LoadingScreen

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
	gameOverScreen = get_tree().root.get_node("Dungeon/GameoverScreen")
	LoadingScreen= get_tree().root.get_node("Dungeon/LoadingScreen")
	LoadingScreen.show()
	await get_tree().process_frame
	get_tree().paused = 1
	await get_tree().create_timer(3.0).timeout
	await generate_map()
	LoadingScreen.hide()
	get_tree().paused = 0
	print(room_positions)
	#print(room_positions["room14"])


func _physics_process(_delta):
	#update player location
	PLAYER_LOCATION = Vector2(global_position)
	gameOverScreen.global_position = global_position
	LoadingScreen.global_position = global_position
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
	

#func generate_map(): 
	#var rooms_scene = get_parent().get_parent().get_node("Rooms")
	#var aRooms = rooms_scene.get_children()
	#
	#aRooms.shuffle()
	#for i in range(0, aRooms.size(), 2):
			##room_positions[room.name] = room.position
			#
			#room_positions[str(aRooms[i]).split(":")[0]] = aRooms[i+1]
			#room_positions[str(aRooms[i+1]).split(":")[0]] = aRooms[i]

#func generate_map():
	#var rooms_scene = get_parent().get_parent().get_node("Rooms")
	#var aRooms = rooms_scene.get_children()
	#
	#var room_weights = {
		#"room1":0, "room2":0, "room3":0, "room4":0, "room5":0, "room6":1,
		#"room7":1, "room8":5, "room9":5, "room10":5, "room11":5, "room12":5,
		#"room13":5, "room14":4, "room15":0, "room16":4, "room17":4, "room18":4,
		#"room19":4, "room20":4, "room21":4, "room22":4, "room23":4, "room24":4
	#}
#
	#aRooms.sort_custom(func(a,b): return room_weights[a.name] > room_weights[b.name])
#
	#var parents = [aRooms[0]] 
	#var next_parents = []
	#var child_index = 1
	#
	#while child_index < aRooms.size():
		#var new_parents = []
		#for parent in parents:
			#if child_index >= aRooms.size():
				#break
				#
			#var left_child = aRooms[child_index]
			#room_positions[str(parent).split(":")[0]] = left_child
			#room_positions[str(left_child).split(":")[0]] = parent
			#child_index += 1
			#if room_weights[left_child.name] > 0:
				#new_parents.append(left_child)
			#
			#if child_index >= aRooms.size():
				#break
				#
			#var right_child = aRooms[child_index]
			#room_positions[str(parent).split(":")[0]] = right_child
			#room_positions[str(right_child).split(":")[0]] = parent
			#child_index += 1
			#if room_weights[right_child.name] > 0:
				#new_parents.append(right_child)
		#
		#parents = new_parents
		

func generate_map():
	var rooms_scene = get_parent().get_parent().get_node("Rooms")
	var aRooms = rooms_scene.get_children()

	# Room weights (mapping room names to their weights)
	var room_weights = {
		"room1": 0, "room2": 0, "room3": 0, "room4": 0, "room5": 0, "room6": 1,
		"room7": 1, "room8": 5, "room9": 5, "room10": 5, "room11": 5, "room12": 5,
		"room13": 5, "room14": 4, "room15": 0, "room16": 4, "room17": 4, "room18": 4,
		"room19": 4, "room20": 4, "room21": 4, "room22": 4, "room23": 4, "room24": 4
	}

	# Filter aRooms to only include non-zero weighted rooms
	var non_zero_rooms = []
	var zero_rooms = []

	# Separate rooms with non-zero and zero weights
	for room in aRooms:
		var room_name = str(room).split(":")[0]
		if room_weights.get(room_name, 0) > 0:
			non_zero_rooms.append(room)
		else:
			zero_rooms.append(room)

	# Shuffle non-zero rooms to randomize the graph creation
	non_zero_rooms.shuffle()

	var edges = []

	# Start building the tree from the root
	var root = non_zero_rooms.pop_back()  # Take the last room as the root
	_add_child_to_tree(root, non_zero_rooms, edges)

	# Connect the zero-weight rooms as leaves
	for zero_room in zero_rooms:
		# Find a leaf node (node with no children) to attach the zero-weight room to
		var random_leaf = edges[randi() % edges.size()]
		room_positions[str(zero_room).split(":")[0]] = random_leaf[0]
		room_positions[str(random_leaf[0]).split(":")[0]] = zero_room
		edges.append([zero_room, random_leaf[0]])
		edges.append([random_leaf[0], zero_room])

# Recursive helper function
func _add_child_to_tree(parent, children, edges):
	var child2
	if children.size() == 0:
		return
	# Add up to 2 children to the parent
	var child1 = children.pop_back()
	room_positions[str(parent).split(":")[0]] = child1
	room_positions[str(child1).split(":")[0]] = parent
	edges.append([parent, child1])
	edges.append([child1, parent])

	if children.size() > 0:
		child2 = children.pop_back()
		room_positions[str(parent).split(":")[0]] = child2
		room_positions[str(child2).split(":")[0]] = parent
		edges.append([parent, child2])
		edges.append([child2, parent])

	# Recursively add children to the new nodes
	_add_child_to_tree(child1, children, edges)
	_add_child_to_tree(child2, children, edges)



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
