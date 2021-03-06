extends Node2D

var LEVEL_TIME = 180

var shop = load("res://other/shop.tscn")
var pause = load("res://other/pause.tscn")
var game_over = load("res://other/game_over.tscn")
var shop_instance
var pause_instance
var game_over_instance

var enemies_scenes = [
	load("res://characters/enemy/basic_meele_enemy.tscn"),
	load("res://characters/enemy/basic_range_enemy.tscn"),
	load("res://characters/enemy/tank_enemy.tscn"),
	load("res://characters/enemy/turret_enemy.tscn")
]

var current_round = -1
var map_width;
var map_height;
var game_ended = false

var enemies = Array()
var max_enemies = 5
var spawned_enemies = 0
var score = 0

var in_round = false

func _ready():
	set_fixed_process(true)
	get_node("level_timer").connect("timeout", self, "timer_end")
	map_width = Globals.get("SCREEN_WIDTH") / Globals.get("TILE_SIZE")
	map_height = Globals.get("SCREEN_HEIGHT") / Globals.get("TILE_SIZE")
	
	map_width -= 4
	map_height -= 6
	timer_end()
	
func restart():
	game_over_instance.hide_screen()
	game_over_instance.queue_free()
	max_enemies = 5
	spawned_enemies = 0
	in_round = false
	game_ended = false
	current_round = -1
	score = 0
	get_node("Player").health = get_node("Player").max_health
	get_node("Player").reset_stats()
	timer_end()
	
func _fixed_process(delta):
	if !get_node("SamplePlayer").is_active():
		var track = (randi() % 3) + 1
		get_node("SamplePlayer").play("music_" + str(track))
	
	if in_round:
		if spawned_enemies < max_enemies && get_node("spawn_timer").get_time_left() == 0:
			var x = (randi() % map_width) + 2
			var y = (randi() % map_height) + 2
			
			var enemy_size = enemies_scenes.size()
			
			if current_round == 0:			# i guess this counts as diffuculty scaling? 
				enemy_size = current_round
			elif current_round < enemy_size:
				enemy_size = current_round
			
			var spawn = 0
			if enemy_size > 0:	
				spawn = (randi() % enemy_size)
			
			
			var node = enemies_scenes[spawn].instance()
			enemies.push_back(weakref(node))
			node.max_health += current_round * 2
			node.health = node.max_health
			node.damage += current_round * 2
			node.set_pos(Vector2(x*Globals.get("TILE_SIZE"), y *Globals.get("TILE_SIZE")));
			get_node("navmesh").add_child(node)
			spawned_enemies += 1
			
			get_node("spawn_timer").set_wait_time(rand_range(0, 3))
			get_node("spawn_timer").start()
	
func round_start():
	get_node("gui").show_gui()
	get_node("Player").set_paused(false)
	get_node("Player").set_pos(get_node("Player").starting_pos)
	in_round = true
	max_enemies = 5 * current_round
	get_node("Player").health = get_node("Player").max_health
	get_node("Player").time_to_move = get_node("Player").default_move_time
	shop_instance.queue_free()
	if current_round == 0:
		LEVEL_TIME = 60
	else:
		LEVEL_TIME = 60 * current_round
		
	if LEVEL_TIME > 180:
		LEVEL_TIME = 180
	
	spawned_enemies = 0
	if max_enemies <= 0:
		max_enemies = 5 
	if max_enemies >= 50: # why not :P
		max_enemies = 50
	timer_start()
	
func player_died():
	timer_end()
	shop_instance.queue_free()
	game_ended = true
	game_over_instance = game_over.instance()
	add_child(game_over_instance)
	
func timer_start():
	get_node("level_timer").set_wait_time(LEVEL_TIME)
	get_node("level_timer").start()
	
	
func timer_end():
	in_round = false
	current_round += 1
	get_node("gui").hide_gui()
	get_node("Player").set_paused(true)
	shop_instance = shop.instance()
	add_child(shop_instance)
	if enemies.size() > 0:
		for i in range(0, enemies.size()):
			if enemies[i].get_ref():
				enemies[i].get_ref().queue_free()
	
func kill_enemy(p_score):
	get_node("SamplePlayer").play("beep")
	score += p_score
	spawned_enemies -= 1;
	
func game_pause():
	if !in_round && !game_ended:
		shop_instance.hide_shop()
		
	if game_ended:
		game_over_instance.hide_screen()
	
	pause_instance = pause.instance()
	add_child(pause_instance)
	get_tree().set_pause(true)
	
func game_unpause():
	if !in_round && !game_ended:
		shop_instance.show_shop()
		
	if game_ended:
		game_over_instance.show_screen()
		
	pause_instance.queue_free()
	get_tree().set_pause(false)