extends Node2D

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

const MODE_FIRE_CAST_TIME = 0
const MODE_WATER_CAST_TIME = 0
const MODE_EARTH_CAST_TIME = 1.0
const MODE_AIR_CAST_TIME = 0

var current_mode = 0
var spell_to_cast = 6

var speed = 10
var time_to_move = 15;
var moving = false

var target_pos = get_pos();
var actual_pos = get_pos();

func _ready():
	set_fixed_process(true)
	get_node("Timer").connect("timeout", self, "timer_end")
	
func _fixed_process(delta):
	
	if current_mode == MODE_NORMAL:
		spell_to_cast = handle_cast_input()
		
		if (spell_to_cast != MODE_CAST_NONE):
			current_mode = MODE_CAST
			
		if (spell_to_cast == MODE_EARTH):
			get_node("Timer").set_wait_time(MODE_EARTH_CAST_TIME)
			get_node("Timer").start()
			get_node("AnimationPlayer").play("cast_earth")
	
	# ugly but Meh!
	for i in range(0, time_to_move):
		if get_pos().distance_to(actual_pos) <= 0.1:
			moving = false
		
		if !moving and current_mode != MODE_EARTH and current_mode != MODE_CAST:
			var direction = handle_direction_input()
			
			if direction != MOVE_NONE:
				moving = true
				target_pos = get_pos()
				actual_pos = get_pos()
				if direction == MOVE_UP:
					target_pos.y += Globals.get("TILE_SIZE")
					actual_pos.y -= Globals.get("TILE_SIZE")
				if direction == MOVE_DOWN:
					target_pos.y -= Globals.get("TILE_SIZE")
					actual_pos.y += Globals.get("TILE_SIZE")
				if direction == MOVE_LEFT:
					target_pos.x += Globals.get("TILE_SIZE")
					actual_pos.x -= Globals.get("TILE_SIZE")
				if direction == MOVE_RIGHT:
					target_pos.x -= Globals.get("TILE_SIZE")
					actual_pos.x += Globals.get("TILE_SIZE")
		
				if is_tile_solid(get_tile_type(actual_pos)):
					moving = false
		if moving:
			var motion = get_pos() - target_pos;
			motion = motion.normalized()
			motion = motion * delta * speed 
			move(motion)
	
func timer_end():
	get_node("Timer").stop()
	get_node("AnimationPlayer").play("idle")
	current_mode = MODE_NORMAL
	
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
	return get_parent().get_node("map").is_tile_solid(tile);
	
func get_tile_type(pos):
	return get_parent().get_node("map").get_tile_type(pos);
	
func get_mode():
	return self.current_mode;
	
func get_face():
	return self.current_mode;