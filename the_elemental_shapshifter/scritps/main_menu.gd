extends Node2D

func _ready():
	seed(OS.get_unix_time())
	get_node("start_game").connect("pressed", self, "start_game")
	get_node("exit").connect("pressed", self, "exit")
	set_fixed_process(true)

func _fixed_process(delta):
	if !get_node("SamplePlayer").is_active():
		var track = (randi() % 2) + 1
		get_node("SamplePlayer").play("menu_music_" + str(track))
	
func start_game():
	get_node("SamplePlayer").play("click")	
	get_node("/root/globals").set_scene("res://other/floor_controller.tscn");

func exit():
	get_node("SamplePlayer").play("click")	
	get_tree().quit()