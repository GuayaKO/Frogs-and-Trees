extends Control


const TIMER_STRING := "%02d:%02d:%02d"


func _ready():
	var duration := GameLogic.time_stop - GameLogic.time_start
	var hours := int(floor(duration / 3600))
	var minutes := int(floor((duration - (hours * 3600)) / 60))
	var seconds := duration - (hours * 3600) - (minutes * 60)
	var message := TIMER_STRING % [hours, minutes, seconds]
	$"MarginContainer/VBoxContainer/MarginContainer2/CounterLabel".text = message


func _on_back_button_pressed():
	GameLogic.shift_x_axis(self, 1080)
	var root := get_node("/root/GameRoot")
	var scene := GameLogic.MENU_MAIN.instantiate()
	root.add_child(scene)
	await get_tree().create_timer(0.3).timeout
	self.queue_free()
