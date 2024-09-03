extends Node


# Board pieces
const PIECE_TREE := "Y"
const PIECE_FROG := "K̈"


# Default color palettes
const GREEN_LIGHT := Color(0.733, 0.933, 0.800)		# BBEECC
const GREEN_DARK := Color(0.000, 0.466, 0.000)		# 007700
const PURPLE_DARK := Color(0.800, 0.200, 0.600)		# FF33C8


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


# Time stamps
var time_start := 0
var time_stop := 0


func build_new_game(board_size: Vector2i, tree_count: int) -> Dictionary:
	var game := {}
	game.frog_locations = []
	while game.frog_locations.size() == 0:
		game.tree_locations = generate_tree_locations(board_size, tree_count)
		game.frog_locations = get_valid_solution(
			game.tree_locations.duplicate(),
			[],
			board_size
		)
		game.board_hints = generate_board_hints(game.frog_locations, board_size)
	return game


func generate_tree_locations(board_size: Vector2i, tree_count: int) -> Array:
	var locations = []
	for c in range(board_size.x):
		for r in range(board_size.y):
			locations.append(Vector2i(c, r))
	locations.shuffle()
	return locations.slice(0, tree_count)


func get_valid_solution(tree_locations: Array, frog_locations: Array, board_size: Vector2i) -> Array:
	if tree_locations.is_empty():
		return frog_locations.duplicate()
	ORTOGONAL_DIRECTIONS.shuffle()
	for direction in ORTOGONAL_DIRECTIONS:
		var frog = tree_locations[0] + direction
		if within_board_limits(frog, board_size) and not next_to_peer(frog, frog_locations):
			frog_locations.append(frog)
			var solution = get_valid_solution(
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


func generate_board_hints(frog_locations: Array, board_size: Vector2i) -> Dictionary:
	var hints := {}
	hints.column = []
	hints.row = []
	for i in range(board_size.x):
		hints.column.append(0)
	for i in range(board_size.y):
		hints.row.append(0)
	for frog in frog_locations:
		hints.column[frog.x] += 1
		hints.row[frog.y] += 1
	return hints


func check_frog_count(current_count: int, expected_count: int) -> bool:
	return current_count == expected_count


func check_hint_correspondence(current_hints: Dictionary, expected_hints: Dictionary) -> bool:
	for r in range(current_hints.row.size()):
		if current_hints.row[r] != expected_hints.row[r]:
			return false
	for c in range(current_hints.column.size()):
		if current_hints.column[c] != expected_hints.column[c]:
			return false
	return true


func points_are_neighbors(point_a: Vector2i, point_b: Vector2i) -> bool:
	var difference := Vector2i(point_a.x - point_b.x, point_a.y - point_b.y)
	return difference in ORTOGONAL_DIRECTIONS or difference in DIAGONAL_DIRECTIONS


func check_game_solution(tree_locations: Array, frog_locations: Array) -> bool:
	if tree_locations.is_empty():
		return true
	else:
		var tree = tree_locations[0]
		var frog := Vector2i.ZERO
		for f in range(frog_locations.size()):
			frog = frog_locations[f]
			if points_are_neighbors(tree, frog):
				frog_locations.erase(frog)
				if check_game_solution(tree_locations.slice(1, tree_locations.size()), frog_locations):
					return true
				else:
					frog_locations.insert(f, frog)
					continue
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


func shift_x_axis(target_node: Node, delta_pixels: int, duration_seconds: float=0.3) -> void:
	var tween := create_tween()
	tween.tween_property(
		target_node, "position",
		Vector2(
			target_node.position.x + delta_pixels,
			target_node.position.y
		),
		duration_seconds
	)


func shift_y_axis(target_node: Node, delta_pixels: int, duration_seconds: float=0.3) -> void:
	var tween := create_tween()
	tween.tween_property(
		target_node, "position",
		Vector2(
			target_node.position.x,
			target_node.position.y + delta_pixels
		),
		duration_seconds
	)
