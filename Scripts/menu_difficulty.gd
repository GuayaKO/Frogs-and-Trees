extends Control


var MENU_MAIN := "res://menu_main.tscn"
var GAME_BOARD := "res://game_board.tscn"
var BOARD_EASY := "res://board_easy.tscn"


func _on_back_button_pressed():
	GameLogic.shift_x_axis(self, 1080)
	var root := get_node("/root/GameRoot")
	root.add_child(load(MENU_MAIN).instantiate())
	await get_tree().create_timer(0.3).timeout
	self.queue_free()


func _on_easy_button_pressed():
	$"MarginContainer/VBoxContainer/MarginContainer2/EasyButton".disabled = true
	GameLogic.shift_x_axis(self, -1080)
	var root := get_node("/root/GameRoot")
	root.add_child(load(BOARD_EASY).instantiate())
	await get_tree().create_timer(0.3).timeout
	self.queue_free()


func _on_medium_button_pressed():
	$"MarginContainer/VBoxContainer/MarginContainer2/MediumButton".disabled = true
	GameLogic.shift_x_axis(self, -1080)
	var root := get_node("/root/GameRoot")
	var board = load(GAME_BOARD).instantiate()
	board.set_game_state(10, 8)
	root.add_child(board)
	await get_tree().create_timer(0.3).timeout
	self.queue_free()
