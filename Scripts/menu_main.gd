extends Control


func _ready():
	GameLogic.shift_x_axis(self, 1080)


func _on_play_button_pressed():
	GameLogic.shift_x_axis(self, -1080)
	var scene = GameLogic.MENU_DIFFICULTY.instantiate()
	var root := get_node("/root/GameRoot")
	root.add_child(scene)
	GameLogic.shift_x_axis(scene, -1080)
	await get_tree().create_timer(0.3).timeout
	self.queue_free()
