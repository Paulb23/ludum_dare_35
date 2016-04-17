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
			var spawn = (randi() % enemies_scenes.size())
			
			var node = enemies_scenes[spawn].instance()
			enemies.push_back(weakref(node))
			node.set_pos(Vector2(x*Globals.get("TILE_SIZE"), y *Globals.get("TILE_SIZE")));
			get_node("navmesh").add_child(node)
			spawned_enemies += 1
			
			get_node("spawn_timer").set_wait_time(rand_range(0, 3))
			get_node("spawn_timer").start()
	
func round_start():
	get_node("gui").show_gui()
	get_node("Player").set_paused(false)
	get_node("Player").set_pos(Vector2((map_width/ 2) * Globals.get("TILE_SIZE"), (map_height/ 2) * Globals.get("TILE_SIZE")))
	get_node("Player").facing = get_node("Player").FACE_DOWN
	in_round = true
	max_enemies = 5 * current_round
	get_node("Player").health = get_node("Player").max_health
	shop_instance.queue_free()
	if max_enemies <= 0:
		max_enemies = 5 
	if max_enemies >= 20:
		max_enemies = 20
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