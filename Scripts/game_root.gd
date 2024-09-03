extends Control


var GAME_TITLE := "res://game_title.tscn"
var MENU_MAIN := "res://menu_main.tscn"


func _ready():
	var root := get_node("/root/GameRoot")
	root.add_child(load(GAME_TITLE).instantiate())
	await get_tree().create_timer(1.8).timeout
	root.add_child(load(MENU_MAIN).instantiate())
