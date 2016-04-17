extends Node2D

const MODE_ACTIVE = 0
const MODE_HIDDEN = 1

var current_mode

func _ready():
	set_fixed_process(true)
	current_mode = MODE_HIDDEN
	
func _fixed_process(delta):
	if current_mode == MODE_HIDDEN:
		return
	
	get_node("score").set_text(str(get_parent().score))
	get_node("clock").set_text(str(int(get_parent().get_node("level_timer").get_time_left())))
	
	var player = get_parent().get_node("Player")
	
	if (player):
		var decrease = player.max_health - player.health
		var percent_decreace = float(decrease) / float(player.max_health)
		get_node("health_bar").set_percentage((float(1.00) - (float(percent_decreace))))
	
		if player.get_node("fire_cooldown").get_time_left() == 0:
			get_node("fire_sprite").set_frame(0)
		else:
			get_node("fire_sprite").set_frame(1)
			
		if player.get_node("water_cooldown").get_time_left() == 0:
			get_node("water_sprite").set_frame(0)
		else:
			get_node("water_sprite").set_frame(1)
		
		if player.get_node("earth_cooldown").get_time_left() == 0:
			get_node("earth_sprite").set_frame(0)
		else:
			get_node("earth_sprite").set_frame(1)
			
		if player.get_node("air_cooldown").get_time_left() == 0:
			get_node("air_sprite").set_frame(0)
		else:
			get_node("air_sprite").set_frame(1)
		
func hide_gui():
	get_node("total_score").hide()
	get_node("score").hide()
	get_node("time_left").hide()
	get_node("clock").hide()
	get_node("health_bar").hide()
	get_node("fire_sprite").hide()
	get_node("water_sprite").hide()
	get_node("earth_sprite").hide()
	get_node("air_sprite").hide()
	current_mode = MODE_HIDDEN
	
func show_gui():
	get_node("total_score").show()
	get_node("score").show()
	get_node("time_left").show()
	get_node("clock").show()
	get_node("health_bar").show()
	get_node("fire_sprite").show()
	get_node("water_sprite").show()
	get_node("earth_sprite").show()
	get_node("air_sprite").show()
	current_mode = MODE_ACTIVE