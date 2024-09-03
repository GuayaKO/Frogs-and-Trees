extends Control


var MENU_MAIN := "res://menu_main.tscn"


func _on_back_button_pressed():
	GameLogic.shift_x_axis(self, 1080)
	var root := get_node("/root/GameRoot")
	root.add_child(load(MENU_MAIN).instantiate())
	await get_tree().create_timer(0.3).timeout
	self.queue_free()
