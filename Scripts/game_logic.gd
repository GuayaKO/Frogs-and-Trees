extends Node


# Default color palettes
var light_green := Color(0.733, 0.933, 0.800)
var dark_green := Color(0.000, 0.466, 0.000)


# Direction deltas
const NORTH = Vector2i(0, -1)
const NORTH_EAST = Vector2i(1, -1)
const EAST = Vector2i(1, 0)
const SOUTH_EAST = Vector2i(1, 1)
const SOUTH = Vector2i(0, 1)
const SOUTH_WEST = Vector2i(-1, 1)
const WEST = Vector2i(-1, 0)
const NORTH_WEST = Vector2i(-1, -1)
const ORTOGONAL_DIRECTIONS = [NORTH, EAST, SOUTH, WEST]
const DIAGONAL_DIRECTIONS = [NORTH_EAST, SOUTH_EAST, SOUTH_WEST, NORTH_WEST]


func build_new_game(board_size: Vector2i, tree_count: int) -> Dictionary:
	var game := {}
	game.frog_locations = []
	while game.frog_locations.size() == 0:
		game.tree_locations = generate_tree_locations(board_size, tree_count)
		game.frog_locations = find_valid_solution(
			game.tree_locations.duplicate(),
			[],
			board_size
		)
	return game


func generate_tree_locations(board_size: Vector2i, tree_count: int) -> Array:
	var locations = []
	for x in range(board_size.x):
		for y in range(board_size.y):
			locations.append(Vector2i(x, y))
	locations.shuffle()
	return locations.slice(0, tree_count)


func find_valid_solution(tree_locations: Array, frog_locations: Array, board_size: Vector2i) -> Array:
	if tree_locations.is_empty():
		return frog_locations.duplicate()
	ORTOGONAL_DIRECTIONS.shuffle()
	for direction in ORTOGONAL_DIRECTIONS:
		var frog = tree_locations[0] + direction
		if within_board_limits(frog, board_size) and not next_to_peer(frog, frog_locations):
			frog_locations.append(frog)
			var solution = find_valid_solution(
				tree_locations.slice(1, tree_locations.size()).duplicate(),
				frog_locations.duplicate(),
				board_size
			)
			if not solution.is_empty():
				return solution
			frog_locations.pop_back()
	return []


func within_board_limits(object_location: Vector2i, board_size: Vector2i) -> bool:
	var x_bound := object_location.x >= 0 and object_location.x < board_size.x
	var y_bound := object_location.y >= 0 and object_location.y < board_size.y
	return x_bound and y_bound


func next_to_peer(this_object: Vector2i, all_objects: Array) -> bool:
	if all_objects.has(this_object):
		return true
	for direction in ORTOGONAL_DIRECTIONS + DIAGONAL_DIRECTIONS:
		if all_objects.has(this_object + direction):
			return true
	return false


func print_board_state(tree_locations, frog_locations, board_size):
	for y in board_size.y:
		var row := ""
		for x in board_size.x:
			var location := Vector2i(x, y)
			if tree_locations.has(location):
				row += "T"
			elif frog_locations.has(location):
				row += "o"
			else:
				row += "+"
		print(row)
