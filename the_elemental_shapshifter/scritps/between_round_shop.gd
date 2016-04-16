extends Node2D

func _ready():
	get_node("start_round_button").connect("pressed", self, "start_round")
	pass
	
func start_round():
	get_parent().timer_start()
	
func show_shop():
	get_node("start_round_button").show()
	
	
func hide_shop():
	get_node("start_round_button").hide()
	pass