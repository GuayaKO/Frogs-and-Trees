extends Control


func _on_back_button_pressed():
	GameLogic.shift_x_axis(self, 1080)
	var root := get_node("/root/GameRoot")
	var scene := GameLogic.MENU_MAIN.instantiate()
	print(scene)
	root.add_child(scene)
	await get_tree().create_timer(0.3).timeout
	self.queue_free()


func _on_easy_button_pressed():
	GameLogic.shift_x_axis(self, -1080)
	var root := get_node("/root/GameRoot")
	var scene := GameLogic.BOARD_EASY.instantiate()
	print(scene)
	root.add_child(scene)
	await get_tree().create_timer(0.3).timeout
	self.queue_free()
