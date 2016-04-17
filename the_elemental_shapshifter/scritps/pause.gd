extends Node2D

var can_unpause = false

func _ready():
	get_node("resume").connect("pressed", self, "resume")
	get_node("main_menu").connect("pressed", self, "main_menu")
	get_node("exit").connect("pressed", self, "exit")
	set_process_input(true)
	get_node("Timer").connect("timeout", self, "timer_end")
	get_node("Timer").set_wait_time(0.10)
	get_node("Timer").start()

func _input(event):
	if event.type == InputEvent.KEY:
		if event.scancode == KEY_ESCAPE && can_unpause:
				resume()
	
func timer_end():
	can_unpause = true
		
func resume():
	get_node("SamplePlayer").play("click")	
	get_parent().game_unpause()
	
func main_menu():
	get_node("SamplePlayer").play("click")	
	get_parent().game_unpause()
	get_node("/root/globals").set_scene("res://menus/main_menu.tscn");
	
func exit():
	get_node("SamplePlayer").play("click")	
	get_tree().quit()