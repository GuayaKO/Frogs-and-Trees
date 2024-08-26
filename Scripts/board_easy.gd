extends Control


const ROWS := 6
const COLS := 6
const BOARD_SIZE := Vector2i(COLS, ROWS)
const FROG_COUNT := 8
const FONT_ATTRIBUTES := [
	"font_color",
	"font_focus_color",
	"font_hover_color",
	"font_hover_pressed_color",
	"font_pressed_color"
]
var frog_locations := []
var tree_locations := []
var board_hints := {}


func _ready():
	# Get game state
	var game = GameLogic.build_new_game(BOARD_SIZE, FROG_COUNT)
	tree_locations = game.tree_locations
	board_hints = game.board_hints
	# Place trees on board
	var board := get_board_squares()
	for c in range(COLS):
		for r in range(ROWS):
			if Vector2i(c, r) in game.tree_locations:
				board[c][r].text = GameLogic.PIECE_TREE
				board[c][r].disabled = true
				print(c, r)
			else:
				board[c][r].text = " "
			board[c][r].pressed.connect(_on_pressed.bind(board[c][r]))
	# Place 
	await get_tree().create_timer(0.15).timeout
	GameLogic.shift_x_axis(self, -1080)


func _on_pressed(board_button: Button):
	board_button.text = change_button_text(board_button.text)
	change_font_color(board_button)
	var values = board_button.name.split(" ")
	var coordinates = Vector2i(int(values[0]),int(values[1]))
	if board_button.text == GameLogic.PIECE_FROG:
		frog_locations.append(coordinates)
	else:
		frog_locations.erase(coordinates)
	if GameLogic.check_frog_count(frog_locations.size(), FROG_COUNT):
		print("- Correct size!")
		var hints := GameLogic.generate_board_hints(frog_locations, BOARD_SIZE)
		print(hints, board_hints)
		if GameLogic.check_hint_correspondence(
			hints,
			board_hints
		):
			print("- Correct hints!")
			if GameLogic.check_game_solution(tree_locations, frog_locations):
				print("Solved!")
		
	print(frog_locations)


func change_button_text(button_text: String) -> String:
	match button_text:
		" ":
			return "."
		".":
			return GameLogic.PIECE_FROG
		_:
			return " "


func change_font_color(board_button: Button):
	match board_button.text:
		GameLogic.PIECE_FROG:
			for attribute in FONT_ATTRIBUTES:
				board_button.add_theme_color_override(
					attribute,
					GameLogic.PURPLE_DARK
				)
		".":
			for attribute in FONT_ATTRIBUTES:
				board_button.add_theme_color_override(
					attribute,
					GameLogic.GREEN_LIGHT
				)


func get_board_squares() -> Dictionary:
	var board_squares := {
		0: [
			$"MarginContainer/VBoxContainer/HBoxContainer2/0 0",
			$"MarginContainer/VBoxContainer/HBoxContainer2/1 0",
			$"MarginContainer/VBoxContainer/HBoxContainer2/2 0",
			$"MarginContainer/VBoxContainer/HBoxContainer2/3 0",
			$"MarginContainer/VBoxContainer/HBoxContainer2/4 0",
			$"MarginContainer/VBoxContainer/HBoxContainer2/5 0",
		],
		1: [
			$"MarginContainer/VBoxContainer/HBoxContainer3/0 1",
			$"MarginContainer/VBoxContainer/HBoxContainer3/1 1",
			$"MarginContainer/VBoxContainer/HBoxContainer3/2 1",
			$"MarginContainer/VBoxContainer/HBoxContainer3/3 1",
			$"MarginContainer/VBoxContainer/HBoxContainer3/4 1",
			$"MarginContainer/VBoxContainer/HBoxContainer3/5 1",
		],
		2: [
			$"MarginContainer/VBoxContainer/HBoxContainer4/0 2",
			$"MarginContainer/VBoxContainer/HBoxContainer4/1 2",
			$"MarginContainer/VBoxContainer/HBoxContainer4/2 2",
			$"MarginContainer/VBoxContainer/HBoxContainer4/3 2",
			$"MarginContainer/VBoxContainer/HBoxContainer4/4 2",
			$"MarginContainer/VBoxContainer/HBoxContainer4/5 2",
		],
		3: [
			$"MarginContainer/VBoxContainer/HBoxContainer5/0 3",
			$"MarginContainer/VBoxContainer/HBoxContainer5/1 3",
			$"MarginContainer/VBoxContainer/HBoxContainer5/2 3",
			$"MarginContainer/VBoxContainer/HBoxContainer5/3 3",
			$"MarginContainer/VBoxContainer/HBoxContainer5/4 3",
			$"MarginContainer/VBoxContainer/HBoxContainer5/5 3",
		],
		4: [
			$"MarginContainer/VBoxContainer/HBoxContainer6/0 4",
			$"MarginContainer/VBoxContainer/HBoxContainer6/1 4",
			$"MarginContainer/VBoxContainer/HBoxContainer6/2 4",
			$"MarginContainer/VBoxContainer/HBoxContainer6/3 4",
			$"MarginContainer/VBoxContainer/HBoxContainer6/4 4",
			$"MarginContainer/VBoxContainer/HBoxContainer6/5 4",
		],
		5: [
			$"MarginContainer/VBoxContainer/HBoxContainer7/0 5",
			$"MarginContainer/VBoxContainer/HBoxContainer7/1 5",
			$"MarginContainer/VBoxContainer/HBoxContainer7/2 5",
			$"MarginContainer/VBoxContainer/HBoxContainer7/3 5",
			$"MarginContainer/VBoxContainer/HBoxContainer7/4 5",
			$"MarginContainer/VBoxContainer/HBoxContainer7/5 5",
		]
	}
	return board_squares

