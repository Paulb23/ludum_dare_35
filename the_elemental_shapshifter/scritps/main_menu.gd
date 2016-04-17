extends Node2D

func _ready():
	get_node("start_game").connect("pressed", self, "start_game")
	get_node("exit").connect("pressed", self, "exit")
	
func start_game():
	get_node("/root/globals").set_scene("res://other/floor_controller.tscn");

func exit():
	get_tree().quit()