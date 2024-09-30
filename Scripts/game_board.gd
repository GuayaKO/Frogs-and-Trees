extends Control


var MAJOR_MONO := "res://Fonts/Major Mono Display/MajorMonoDisplay-Regular.ttf"
const FONT_ATTRIBUTES := [
	"font_color",
	"font_focus_color",
	"font_hover_color",
	"font_hover_pressed_color",
	"font_pressed_color"
]
var GAME_STATE := {}
var tree_count : int
var frog_locations : Array


func set_game_state(rows: int=6, columns:int=6):
	self.tree_count = rows + (columns / 2)
	self.GAME_STATE.board_size = Vector2i(columns, rows)
	self.GAME_STATE = GameLogic.build_new_game(
		self.GAME_STATE.board_size,
		self.tree_count
	)
	self.GAME_STATE.row_count = rows
	self.GAME_STATE.column_count = columns


func get_square_size() -> int:
	return int(1040 / (self.GAME_STATE.column_count + 1))


func _ready():
	# Match font size to square size
	var font_size := int(get_square_size() / 150.0 * 120.0)
	# Create vertical alignment container to contain board rows
	var game_board := VBoxContainer.new()
	# Create row of column hints
	var hint_row := HBoxContainer.new()
	hint_row.size_flags_horizontal = Control.SIZE_SHRINK_END
	for hint in self.GAME_STATE.board_hints.column:
		var column_hint := Label.new()
		column_hint.text = str(hint)
		column_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		column_hint.custom_minimum_size = Vector2(get_square_size(), 0)
		column_hint.set("theme_override_colors/font_color", GameLogic.WHITE_LIGHT)
		column_hint.set("theme_override_colors/font_outline_color", GameLogic.WHITE_LIGHT)
		column_hint.set("theme_override_font_sizes/font_size", font_size)
		column_hint.set("theme_override_fonts/font", load(MAJOR_MONO))
		hint_row.add_child(column_hint)
	game_board.add_child(hint_row)
	# Create board rows
	for row in self.GAME_STATE.row_count:
		# Use right-aligned horizontal container to contain board squares
		var board_row := HBoxContainer.new()
		board_row.size_flags_horizontal = Control.SIZE_SHRINK_END
		# Add hint before every row
		var row_hint := Label.new()
		row_hint.text = str(self.GAME_STATE.board_hints.row[row])
		row_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		row_hint.custom_minimum_size = Vector2(get_square_size(), 0)
		row_hint.set("theme_override_colors/font_color", GameLogic.WHITE_LIGHT)
		row_hint.set("theme_override_colors/font_outline_color", GameLogic.WHITE_LIGHT)
		row_hint.set("theme_override_font_sizes/font_size", font_size)
		row_hint.set("theme_override_fonts/font", load(MAJOR_MONO))
		board_row.add_child(row_hint)
		for column in self.GAME_STATE.column_count:
			var board_square := Button.new() 
			board_square.custom_minimum_size = Vector2(get_square_size(), get_square_size())
			board_row.add_child(board_square)
			var square_style = load("res://Styles/button_easy_style.tres")
			board_square.add_theme_stylebox_override("normal", square_style)
			board_square.add_theme_stylebox_override("hover", square_style)
			board_square.add_theme_stylebox_override("pressed", square_style)
			board_square.add_theme_stylebox_override("disabled", square_style)
			board_square.add_theme_stylebox_override("focus", square_style)
			board_square.pressed.connect(_on_pressed.bind(board_square))
			board_square.name = str(column) + " " + str(row)
			board_square.set("theme_override_font_sizes/font_size", font_size)
			board_square.set("theme_override_fonts/font", load(MAJOR_MONO))
			if Vector2i(column, row) in self.GAME_STATE.tree_locations:
				board_square.text = GameLogic.PIECE_TREE
				#board_square.disabled = true
				for attribute in FONT_ATTRIBUTES:
					board_square.add_theme_color_override(
						attribute,
						GameLogic.GREEN_DARK
					)
			else:
				board_square.text = GameLogic.PIECE_UNKNOWN
		game_board.add_child(board_row)
	$"MarginContainer".add_child(game_board)
	GameLogic.shift_x_axis(self, -1080)


func _on_pressed(board_square: Button):
	var values = board_square.name.split(" ")
	var coordinates = Vector2i(int(values[0]),int(values[1]))
	print(coordinates)
	match board_square.text:
		GameLogic.PIECE_TREE:
			pass
		GameLogic.PIECE_UNKNOWN:
			board_square.text = GameLogic.PIECE_EMPTY
			for attribute in FONT_ATTRIBUTES:
				board_square.add_theme_color_override(
					attribute,
					GameLogic.GREEN_LIGHT
				)
		GameLogic.PIECE_EMPTY:
			board_square.text = GameLogic.PIECE_FROG
			for attribute in FONT_ATTRIBUTES:
				board_square.add_theme_color_override(
					attribute,
					GameLogic.PURPLE_DARK
				)
			self.frog_locations.append(coordinates)
		GameLogic.PIECE_FROG:
			board_square.text = GameLogic.PIECE_UNKNOWN
			for attribute in FONT_ATTRIBUTES:
				board_square.add_theme_color_override(
					attribute,
					GameLogic.GREEN_LIGHT
				)
			self.frog_locations.erase(coordinates)
		_:
			print("This should never print!")
			return null
	if GameLogic.check_frog_count(self.frog_locations.size(), self.tree_count):
		#var hints := GameLogic.generate_board_hints(
			#self.frog_locations,
			#self.GAME_STATE.board_size
		#)
		print(self.frog_locations)
