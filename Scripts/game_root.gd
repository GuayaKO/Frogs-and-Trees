extends Control


func _ready():
	var root := get_node("/root/GameRoot")
	root.add_child(GameLogic.GAME_TITLE.instantiate())
	await get_tree().create_timer(1.8).timeout
	root.add_child(GameLogic.MENU_MAIN.instantiate())
