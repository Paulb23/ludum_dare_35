extends Node2D

func _ready():
	get_node("main_menu").connect("pressed", self, "main_menu")
	get_node("restart").connect("pressed", self, "restart")
	get_node("exit").connect("pressed", self, "exit")
	get_node("score").set_text("You made it to round:" + str(get_parent().current_round))
	
func main_menu():
	get_node("SamplePlayer").play("click")	
	get_node("/root/globals").set_scene("res://menus/main_menu.tscn");
	
func restart():
	get_node("SamplePlayer").play("click")	
	get_parent().restart()
	
func exit():
	get_node("SamplePlayer").play("click")	
	get_tree().quit()
	
func hide_screen():
	get_node("title").hide()
	get_node("main_menu").hide()
	get_node("restart").hide()
	get_node("exit").hide()
	get_node("score").hide()
	
func show_screen():
	get_node("title").show()
	get_node("main_menu").show()
	get_node("restart").show()
	get_node("exit").show()
	get_node("score").show()