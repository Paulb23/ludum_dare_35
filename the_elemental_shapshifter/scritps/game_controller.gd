extends Node2D

const LEVEL_TIME = 180

var current_round = -1

func _ready():
	set_fixed_process(true)
	get_node("level_timer").connect("timeout", self, "timer_end")
	timer_end()
	
func _fixed_process(delta):
	pass
	
func round_start():
	get_node("gui").show_gui()
	get_node("Player").set_paused(false)
	get_node("between_rounds_shop").hide_shop();
	
	timer_start()
	
func player_died():
	timer_end()
	
func timer_start():
	get_node("level_timer").set_wait_time(LEVEL_TIME)
	get_node("level_timer").start()
	
	
func timer_end():
	current_round += 1
	get_node("gui").hide_gui()
	get_node("Player").set_paused(true)
	get_node("between_rounds_shop").show_shop();