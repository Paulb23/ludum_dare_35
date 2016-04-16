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
	
	get_node("clock").set_text(str(get_parent().get_node("level_timer").get_time_left()))
	
	var player = get_parent().get_node("Player")
	
	if (player):
		get_node("health_text").set_text(str(player.get_health()))
		get_node("fire_cooldown_text").set_text(str(player.get_node("fire_cooldown").get_time_left()))
		get_node("water_cooldown_text").set_text(str(player.get_node("water_cooldown").get_time_left()))
		get_node("earth_cooldown_text").set_text(str(player.get_node("earth_cooldown").get_time_left()))
		get_node("air_cooldown_text").set_text(str(player.get_node("air_cooldown").get_time_left()))	
		
func hide_gui():
	get_node("clock").hide()
	get_node("health_text").hide()
	get_node("fire_cooldown_text").hide()
	get_node("water_cooldown_text").hide()
	get_node("earth_cooldown_text").hide()
	get_node("air_cooldown_text").hide()
	current_mode = MODE_HIDDEN
	
func show_gui():
	get_node("clock").show()
	get_node("health_text").show()
	get_node("fire_cooldown_text").show()
	get_node("water_cooldown_text").show()
	get_node("earth_cooldown_text").show()
	get_node("air_cooldown_text").show()
	current_mode = MODE_ACTIVE