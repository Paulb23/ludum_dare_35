extends Node2D

var fire_scene = load("res://characters/fire.tscn")
var fire_nodes = Array()

const FACE_UP = 0
const FACE_DOWN = 1
const FACE_LEFT = 2
const FACE_RIGHT = 3

const MOVE_UP = 0
const MOVE_DOWN = 1
const MOVE_LEFT = 2
const MOVE_RIGHT = 3
const MOVE_NONE = 4

const MODE_NORMAL = 0
const MODE_FIRE = 1
const MODE_WATER = 2
const MODE_EARTH = 3
const MODE_AIR = 4
const MODE_CAST = 5
const MODE_CAST_NONE = 6
const MODE_PAUSED = 7

var MODE_FIRE_SELF_DAMAGE = 0.5;
var MODE_EARTH_SELF_HEAL = 0.1;

var MODE_FIRE_TIME_OUT = 1.0
var MODE_WATER_TIME_OUT = 1.0
var MODE_EARTH_TIME_OUT = 1.0
var MODE_AIR_TIME_OUT = 1.0

var MODE_FIRE_CAST_TIME = 1.0
var MODE_WATER_CAST_TIME = 1.0
var MODE_EARTH_CAST_TIME = 1.0
var MODE_AIR_CAST_TIME = 1.5

var fire_dmg = 1
var water_damage = 1
var earth_damage = 0
var air_damage = 1

var current_mode = 0
var spell_to_cast = 6

var speed = 10

var default_move_time = 15
var air_time_to_move = 20
var water_time_to_move = 17

var time_to_move = 15;
var moving = false
var facing = 1

var max_health = 100
var health = 100
var current_dmg = 0

var target_pos = get_pos();
var actual_pos = get_pos();

var colliders = Array()

func _ready():
	set_fixed_process(true)
	get_node("Timer").connect("timeout", self, "timer_end")
	get_node("Area2D").connect("body_enter", self, "collision")
	get_node("Area2D").connect("body_exit", self, "collision_end")
	set_process_input(true)
	
func reset_stats():
	max_health = 100
	health = 100
	current_dmg = 0
	time_to_move = 15;
	moving = false	
	default_move_time = 15
	air_time_to_move = 20
	water_time_to_move = 17
	MODE_FIRE_SELF_DAMAGE = 0.5;
	MODE_EARTH_SELF_HEAL = 0.1;
	
	MODE_FIRE_TIME_OUT = 1.0
	MODE_WATER_TIME_OUT = 1.0
	MODE_EARTH_TIME_OUT = 1.0
	MODE_AIR_TIME_OUT = 1.0
	
	MODE_FIRE_CAST_TIME = 1.0
	MODE_WATER_CAST_TIME = 1.0
	MODE_EARTH_CAST_TIME = 1.0
	MODE_AIR_CAST_TIME = 1.5
	
	fire_dmg = 1
	water_damage = 1
	earth_damage = 0
	air_damage = 1
	
	current_mode = 0
	spell_to_cast = 6
	
	speed = 10
	
func _input(event):
	if Input.is_action_pressed("pause") :
		get_parent().game_pause()
	
func _fixed_process(delta):

	
	if current_mode == MODE_PAUSED:
		return
	
	if current_mode == MODE_NORMAL:
		spell_to_cast = handle_cast_input()
		
		if (spell_to_cast == MODE_FIRE && get_node("fire_cooldown").get_time_left() == 0):
			get_node("SamplePlayer").play("fire_attack")
			var node = fire_scene.instance()
			var current_pos = node.get_pos()
			current_pos.x += Globals.get("TILE_SIZE")
			node.set_pos(current_pos)
			node.set_damage(fire_dmg)
			fire_nodes.push_back(node)
			add_child(node);
			var node = fire_scene.instance()
			current_pos = node.get_pos()
			current_pos.x -= Globals.get("TILE_SIZE")
			node.set_pos(current_pos)
			fire_nodes.push_back(node)
			node.set_damage(fire_dmg)
			add_child(node);
			var node = fire_scene.instance()
			current_pos = node.get_pos()
			current_pos.y += Globals.get("TILE_SIZE")
			node.set_pos(current_pos)
			fire_nodes.push_back(node)
			node.set_damage(fire_dmg)
			add_child(node);
			var node = fire_scene.instance()
			current_pos = node.get_pos()
			current_pos.y -= Globals.get("TILE_SIZE")
			node.set_pos(current_pos)
			node.set_damage(fire_dmg)
			fire_nodes.push_back(node)
			add_child(node);
			get_node("Timer").set_wait_time(MODE_FIRE_CAST_TIME)
			get_node("Timer").start()
			get_node("AnimationPlayer").play("cast_fire")
			current_dmg = fire_dmg
			current_mode = MODE_CAST
			
		if (spell_to_cast == MODE_WATER && get_node("water_cooldown").get_time_left() == 0):
			get_node("Timer").set_wait_time(MODE_WATER_CAST_TIME)
			get_node("Timer").start()
			get_node("AnimationPlayer").play("cast_water")
			get_node("SamplePlayer").play("water_attack")
			time_to_move = water_time_to_move
			current_dmg = water_damage
			current_mode = MODE_CAST
			
		if (spell_to_cast == MODE_EARTH && get_node("earth_cooldown").get_time_left() == 0):
			get_node("Timer").set_wait_time(MODE_EARTH_CAST_TIME)
			get_node("Timer").start()
			get_node("AnimationPlayer").play("cast_earth")
			get_node("SamplePlayer").play("earth_attack")
			current_dmg = earth_damage
			current_mode = MODE_CAST
		
		if (spell_to_cast == MODE_AIR && get_node("air_cooldown").get_time_left() == 0):
			get_node("Timer").set_wait_time(MODE_AIR_CAST_TIME)
			get_node("Timer").start()
			get_node("AnimationPlayer").play("cast_air")
			get_node("SamplePlayer").play("air_attack")
			time_to_move = air_time_to_move
			current_dmg = air_damage
			current_mode = MODE_CAST 
		
			
	if current_mode == MODE_CAST:
		if (spell_to_cast == MODE_FIRE):
			hit(MODE_FIRE_SELF_DAMAGE)
			
		if (spell_to_cast == MODE_WATER):
			if !moving:
				move_player(facing)
				
		if (spell_to_cast == MODE_EARTH):
			health += MODE_EARTH_SELF_HEAL
			
		if (spell_to_cast == MODE_AIR):
			if !moving:
				var direction = handle_direction_input()
				
				if direction != MOVE_NONE:
					move_player(direction)
	else:
		current_dmg = 0
	
	# ugly but Meh!
	for i in range(0, time_to_move):
		if get_pos().distance_to(actual_pos) <= 0.1:
			moving = false
		
		if !moving and current_mode != MODE_CAST:
			var direction = handle_direction_input()
			
			if direction != MOVE_NONE:
				move_player(direction)
		if moving:
			var motion = get_pos() - target_pos;
			motion = motion.normalized()
			motion = motion * delta * speed 
			move(motion)

	if !moving && current_mode != MODE_CAST:
		if facing == FACE_DOWN:
			get_node("AnimatedSprite").set_frame(0)
		if facing == FACE_UP:
			get_node("AnimatedSprite").set_frame(8)
		if facing == FACE_LEFT:
			get_node("AnimatedSprite").set_frame(19)
		if facing == FACE_RIGHT:
			get_node("AnimatedSprite").set_frame(12)
	
			
	if health > max_health:
		health = max_health
		
	if colliders.size() > 0:
		for i in range(0, colliders.size()):
			colliders[i].hit(current_dmg)
	
func move_player(direction):	
	moving = true
	target_pos = get_pos()
	actual_pos = get_pos()
	if direction == MOVE_UP:
		target_pos.y += Globals.get("TILE_SIZE")
		actual_pos.y -= Globals.get("TILE_SIZE")
		facing = FACE_UP
		
		if get_node("AnimationPlayer").get_current_animation() && current_mode != MODE_CAST:
			get_node("AnimationPlayer").play("walk_up")
	if direction == MOVE_DOWN:
		target_pos.y -= Globals.get("TILE_SIZE")
		actual_pos.y += Globals.get("TILE_SIZE")
		facing = FACE_DOWN
		
		if get_node("AnimationPlayer").get_current_animation() && current_mode != MODE_CAST:
			get_node("AnimationPlayer").play("walk_down")
	if direction == MOVE_LEFT:
		target_pos.x += Globals.get("TILE_SIZE")
		actual_pos.x -= Globals.get("TILE_SIZE")
		facing = FACE_LEFT
		
		if get_node("AnimationPlayer").get_current_animation() && current_mode != MODE_CAST:
			get_node("AnimationPlayer").play("walk_left")
	if direction == MOVE_RIGHT:
		target_pos.x -= Globals.get("TILE_SIZE")
		actual_pos.x += Globals.get("TILE_SIZE")
		facing = FACE_RIGHT
		
		if get_node("AnimationPlayer").get_current_animation() && current_mode != MODE_CAST:
			get_node("AnimationPlayer").play("walk_right")
		
	if is_tile_solid(get_tile_type(actual_pos)):
		moving = false
	
func collision(body):
	if body.get_name() == "Player":
		return
	colliders.push_back(body)
	
func collision_end(body):
	if colliders.find(body) != -1:
		colliders.remove(colliders.find(body))
	
func timer_end():
	get_node("Timer").stop()
	get_node("AnimationPlayer").play("idle")
	
	
	if spell_to_cast == MODE_FIRE:
		remove_fire()
		get_node("fire_cooldown").set_wait_time(MODE_FIRE_TIME_OUT)
		get_node("fire_cooldown").start()
	
	if spell_to_cast == MODE_WATER:
		get_node("water_cooldown").set_wait_time(MODE_WATER_TIME_OUT)
		get_node("water_cooldown").start()
	
	if spell_to_cast == MODE_EARTH:
		get_node("earth_cooldown").set_wait_time(MODE_EARTH_TIME_OUT)
		get_node("earth_cooldown").start()
		
	if spell_to_cast == MODE_AIR:
		get_node("air_cooldown").set_wait_time(MODE_AIR_TIME_OUT)
		get_node("air_cooldown").start()
	
	time_to_move = default_move_time
	spell_to_cast = MODE_CAST_NONE
	current_mode = MODE_NORMAL
	
func remove_fire():
	for i in range(0, fire_nodes.size()):
			var node = fire_nodes[i]
			node.queue_free()
	fire_nodes.clear()
	
func handle_direction_input():
	if ( Input.is_action_pressed("move_up") ):
		return MOVE_UP
	if ( Input.is_action_pressed("move_down") ):
		return MOVE_DOWN
	if ( Input.is_action_pressed("move_left") ):
		return MOVE_LEFT
	if ( Input.is_action_pressed("move_right") ):
		return MOVE_RIGHT
	return MOVE_NONE
	
func handle_cast_input():
	if ( Input.is_action_pressed("cast_fire") ):
		return MODE_FIRE
	if ( Input.is_action_pressed("cast_water") ):
		return MODE_WATER
	if ( Input.is_action_pressed("cast_earth") ):
		return MODE_EARTH
	if ( Input.is_action_pressed("cast_air") ):
		return MODE_AIR
	return MODE_CAST_NONE

func is_tile_solid(tile):	
	return get_parent().get_node("map").is_tile_solid(tile)
	
func get_tile_type(pos):
	return get_parent().get_node("map").get_tile_type(pos)
	
func get_spell():
	return self.spell_to_cast
	
func get_mode():
	return self.current_mode
	
func get_face():
	return self.facing
	
func get_health():
	return self.health
	
func set_paused(paused):
	if (paused):
		current_mode = MODE_PAUSED
		remove_fire()
		get_node("AnimatedSprite").hide()
	else:
		current_mode = MODE_NORMAL
		get_node("AnimatedSprite").show()
		
func hit(dmg):
	if spell_to_cast == MODE_EARTH:
		return
	get_node("SamplePlayer").play("hit")
	health -= dmg
	
	if health <= 0.0:
		get_parent().player_died()