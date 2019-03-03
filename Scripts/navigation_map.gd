extends TileMap

onready var astar = AStar.new()

## tilemap variables
var tile_width = 1
var tile_height = 1
onready var half_cell_size = cell_size / 2
#onready var traversable_tiles = get_used_cells()
#onready var used_rect = get_used_rect()

## grid variables
var grid_size_x = 10
var grid_size_y = 10
var grid = []


func _ready():
	
	grid = _make_grid()
	_connect_grid()


# PRIVATE FUNCTIONS

func _make_grid():
	
	var x = 0
	var y = 0
	var id = 0
	var grid = []

	for x in grid_size_x:
		
		grid.append([])
		
		for y in grid_size_y:

			var tile = {
				"id": id
			}
			grid[x].append(tile)
			astar.add_point(id, Vector3(x, 0, y))
			id += 1
	
	return grid


func _connect_grid():

	for x in grid_size_x:
		
		for y in grid_size_y:
			
			var id = grid[x][y]["id"]
			var neighbours = {
					"n": Vector3(x, 0, y-1),
					"ne": Vector3(x+1, 0, y-1),
					"e": Vector3(x+1, 0, y),
					"se": Vector3(x+1, 0, y+1),
					"s": Vector3(x, 0, y+1),
					"sw": Vector3(x-1, 0, y+1 ),
					"w": Vector3(x-1, 0, y),
					"nw": Vector3(x-1, 0, y-1)
				}
			
			for j in neighbours:
				
				var dir = neighbours[j]
				if dir.x > -1 and dir.z > -1 and dir.x < grid_size_x and dir.z < grid_size_y:
					var neighbour = grid[dir.x][dir.z]["id"]
					if not astar.are_points_connected(id, neighbour):
						astar.connect_points(id, neighbour)


func _get_tile_id(tile):
	
	return grid[tile.x][tile.y]["id"]

 
# PUBLIC FUNCTIONS

func get_path(start, end):

	var start_tile = world_to_map(start)
	var end_tile = world_to_map(end)

	var start_id = _get_tile_id(start_tile)
	var end_id = _get_tile_id(end_tile)

	if not astar.has_point(start_id) or not astar.has_point(end_id):
		return null

	var path_map = astar.get_point_path(start_id, end_id)

	var path_world = []
	for point in path_map:
		var point_world = map_to_world(Vector2(point.x, point.z)) + half_cell_size
		path_world.append(point_world)
	return path_world