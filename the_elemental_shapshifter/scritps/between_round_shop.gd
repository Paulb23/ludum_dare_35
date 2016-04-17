extends Node2D

var points = 0

func _ready():
	get_node("start_round_button").connect("pressed", self, "start_round")
	get_node("upgrade_health").connect("pressed", self, "upgrade_health")
	get_node("upgrade_speed").connect("pressed", self, "upgrade_speed")
	get_node("upgrade_fire_damage").connect("pressed", self, "upgrade_fire_damage")
	get_node("reduce_fire_self_damage").connect("pressed", self, "reduce_fire_self_damage")
	get_node("reduce_fire_cooldown").connect("pressed", self, "reduce_fire_cooldown")
	get_node("increase_fire_duration").connect("pressed", self, "increase_fire_duration")
	get_node("upgrade_water_damage").connect("pressed", self, "upgrade_water_damage")
	get_node("increace_water_speed").connect("pressed", self, "increace_water_speed")
	get_node("reduce_water_cooldown").connect("pressed", self, "reduce_water_cooldown")
	get_node("increace_water_duration").connect("pressed", self, "increace_water_duration")
	get_node("increase_earth_self_heal").connect("pressed", self, "increase_earth_self_heal")
	get_node("reduce_earth_cooldown").connect("pressed", self, "reduce_earth_cooldown")
	get_node("increase_earth_duartion").connect("pressed", self, "increase_earth_duartion")
	get_node("upgrade_air_damage").connect("pressed", self, "upgrade_air_damage")
	get_node("increase_air_speed").connect("pressed", self, "increase_air_speed")
	get_node("reduce_air_cooldown").connect("pressed", self, "reduce_air_cooldown")
	get_node("increase_air_duration").connect("pressed", self, "increase_air_duration")
	
	points = 6
	update_points()
	
func start_round():
	get_parent().round_start()
	
	
func upgrade_health():
	if points <= 0:
		return
	get_parent().get_node("Player").max_health += 50
	update_points()
	
func upgrade_speed():
	if points <= 0:
		return
	get_parent().get_node("Player").time_to_move += 2
	update_points()
	
func upgrade_fire_damage():
	get_parent().get_node("Player").fire_dmg += 2
	update_points()

func reduce_fire_self_damage():
	if points <= 0:
		return
	get_parent().get_node("Player").MODE_FIRE_SELF_DAMAGE -= 0.1
	update_points()
	
func reduce_fire_cooldown():
	if points <= 0:
		return
	get_parent().get_node("Player").MODE_FIRE_TIME_OUT -= 0.1
	update_points()
	
func increase_fire_duration():
	if points <= 0:
		return
	get_parent().get_node("Player").MODE_FIRE_CAST_TIME += 0.2
	update_points()
	
func upgrade_water_damage():
	get_parent().get_node("Player").water_damage += 2
	update_points()
	
func increace_water_speed():
	if points <= 0:
		return
	get_parent().get_node("Player").water_time_to_move += 1
	update_points()

func reduce_water_cooldown():
	if points <= 0:
		return
	get_parent().get_node("Player").MODE_WATER_TIME_OUT -= 0.1
	update_points()

func increace_water_duration():
	if points <= 0:
		return
	get_parent().get_node("Player").MODE_WATER_CAST_TIME += 0.2
	update_points()
	
func increase_earth_self_heal():
	if points <= 0:
		return
	get_parent().get_node("Player").MODE_EARTH_SELF_HEAL += 0.2
	update_points()
	
func reduce_earth_cooldown():
	if points <= 0:
		return
	get_parent().get_node("Player").MODE_EARTH_TIME_OUT -= 0.1
	update_points()
	
func increase_earth_duartion():
	if points <= 0:
		return 
	get_parent().get_node("Player").MODE_EARTH_CAST_TIME += 0.2
	update_points()
	
func upgrade_air_damage():
	if points <= 0:
		return
	get_parent().get_node("Player").air_damage += 2
	update_points()
		
func increase_air_speed():
	if points <= 0:
		return
	get_parent().get_node("Player").air_time_to_move += 1
	update_points()

func reduce_air_cooldown():
	if points <= 0:
		return
	get_parent().get_node("Player").MODE_AIR_TIME_OUT -= 0.1
	update_points()

func increase_air_duration():
	if points <= 0:
		return
	get_parent().get_node("Player").MODE_AIR_CAST_TIME += 0.2
	update_points()

func update_points():
	points -= 1
	get_node("points").set_text("Points Left : " + str(points))
	
func show_shop():		
	get_node("start_round_button").show()		
	get_node("upgrade_health").show()		
	get_node("upgrade_speed").show()		
	get_node("upgrade_fire_damage").show()		
	get_node("reduce_fire_self_damage").show()		
	get_node("reduce_fire_cooldown").show()		
	get_node("increase_fire_duration").show()		
	get_node("upgrade_water_damage").show()		
	get_node("increace_water_speed").show()		
	get_node("reduce_water_cooldown").show()		
	get_node("increace_water_duration").show()		
	get_node("increase_earth_self_heal").show()		
	get_node("reduce_earth_cooldown").show()		
	get_node("increase_earth_duartion").show()		
	get_node("upgrade_air_damage").show()		
	get_node("increase_air_speed").show()		
	get_node("reduce_air_cooldown").show()		
	get_node("increase_air_duration").show()		
	get_node("points").show()			
			
			
func hide_shop():		
	get_node("upgrade_health").hide()		
	get_node("start_round_button").hide()		
	get_node("upgrade_speed").hide()		
	get_node("upgrade_fire_damage").hide()		
	get_node("reduce_fire_self_damage").hide()		
	get_node("reduce_fire_cooldown").hide()		
	get_node("increase_fire_duration").hide()		
	get_node("upgrade_water_damage").hide()		
	get_node("increace_water_speed").hide()		
	get_node("reduce_water_cooldown").hide()		
	get_node("increace_water_duration").hide()		
	get_node("increase_earth_self_heal").hide()		
	get_node("reduce_earth_cooldown").hide()		
	get_node("increase_earth_duartion").hide()		
	get_node("upgrade_air_damage").hide()		
	get_node("increase_air_speed").hide()		
	get_node("reduce_air_cooldown").hide()		
	get_node("increase_air_duration").hide()		
	get_node("points").hide() 
