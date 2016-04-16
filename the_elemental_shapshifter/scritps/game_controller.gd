extends Node2D

const LEVEL_TIME = 5#180

func _ready():
	set_fixed_process(true)
	get_node("level_timer").connect("timeout", self, "timer_end")
	timer_end()
	
func _fixed_process(delta):
	pass
	
func timer_start():
	get_node("gui").show_gui()
	get_node("Player").set_paused(false)
	get_node("between_rounds_shop").hide_shop();
	get_node("level_timer").set_wait_time(LEVEL_TIME)
	get_node("level_timer").start()
	
	
func timer_end():
	get_node("gui").hide_gui()
	get_node("Player").set_paused(true)
	get_node("between_rounds_shop").show_shop();
	pass