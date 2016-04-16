extends Node2D

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	var player = get_parent().get_node("Player")
	
	if (player):
		get_node("health_text").set_text(str(player.get_health()))
		get_node("fire_cooldown_text").set_text(str(player.get_node("fire_cooldown").get_time_left()))
		get_node("water_cooldown_text").set_text(str(player.get_node("water_cooldown").get_time_left()))
		get_node("earth_cooldown_text").set_text(str(player.get_node("earth_cooldown").get_time_left()))
		get_node("air_cooldown_text").set_text(str(player.get_node("air_cooldown").get_time_left()))	