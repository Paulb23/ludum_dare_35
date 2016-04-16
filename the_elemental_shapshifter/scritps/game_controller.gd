extends Node2D

const LEVEL_TIME = 180

var enemies_scenes = [
	load("res://characters/enemy/basic_meele_enemy.tscn"),
	load("res://characters/enemy/basic_range_enemy.tscn")
]

var current_round = -1
var map_width;
var map_height;

var enemies = Array()
var max_enemies = 5
var spawned_enemies = 0

var in_round = false

func _ready():
	set_fixed_process(true)
	get_node("level_timer").connect("timeout", self, "timer_end")
	map_width = Globals.get("SCREEN_WIDTH") / Globals.get("TILE_SIZE")
	map_height = Globals.get("SCREEN_HEIGHT") / Globals.get("TILE_SIZE")
	
	map_width -= 2
	map_height -= 4
	timer_end()
	
func _fixed_process(delta):
	if in_round:
		if spawned_enemies < max_enemies && get_node("spawn_timer").get_time_left() == 0:
			var x = (randi() % map_width) + 1
			var y = (randi() % map_height) + 1
			var spawn = (randi() % enemies_scenes.size())
			
			var node = enemies_scenes[spawn].instance()
			enemies.push_back(node)
			node.set_pos(Vector2(x*Globals.get("TILE_SIZE"), y *Globals.get("TILE_SIZE")));
			get_node("navmesh").add_child(node)
			spawned_enemies += 1
			
			get_node("spawn_timer").set_wait_time(rand_range(0, 3))
			get_node("spawn_timer").start()
	
func round_start():
	get_node("gui").show_gui()
	get_node("Player").set_paused(false)
	get_node("between_rounds_shop").hide_shop();
	in_round = true
	max_enemies = 5 * current_round
	
	if max_enemies <= 0:
		max_enemies = 5 
	if max_enemies >= 20:
		max_enemies = 20
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
	
func kill_enemy():
	spawned_enemies -= 1;