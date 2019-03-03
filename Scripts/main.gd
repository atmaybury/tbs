extends Node2D

onready var map = $navigation_map
onready var player = $player

var start = null
var end = null
var start_v3
var end_v3

var path

func _ready():
	
	set_process_input(true)


# select tile
func _input(event):
	
	start = player.position
	
	# GET DESTINATION
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		end = get_global_mouse_position()
		# ASSIGN FULL PATH IN PLAYER FUNCTION
		path = map.get_path(start, end)
		player.movement_points += 3
		player.make_turn_path(path)
	
	# CONTINUE
	if event.is_action_pressed("ui_accept"):
		player.movement_points += 3
		player.make_turn_path(path)


# TODO
# add system for obstacles
# add system for action points

# NOTES
# nagivator:
#	navigation_map // need invisible tilemap just for navigation/sprite placement, or unnecessary?
#	ground_map // hold terrain tiles // any reason not to use this as navigation?
#	obstacle_map // sprites for permanent obstacles and structures
#	reachable_map // transparent layer, maps reachable tiles