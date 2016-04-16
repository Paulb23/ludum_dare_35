extends Node2D

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

var speed = 10
var time_to_move = 15;
var moving = false

var target_pos = get_pos();
var actual_pos = get_pos();

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	
	# ugly but Meh!
	for i in range(0, time_to_move):
		if get_pos().distance_to(actual_pos) <= 0.1:
			moving = false
		
		if !moving:
			var direction = handle_input()
			
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
	
func handle_input():
	if ( Input.is_action_pressed("move_up") ):
		return MOVE_UP
	if ( Input.is_action_pressed("move_down") ):
		return MOVE_DOWN
	if ( Input.is_action_pressed("move_left") ):
		return MOVE_LEFT
	if ( Input.is_action_pressed("move_right") ):
		return MOVE_RIGHT
	return MOVE_NONE	

func is_tile_solid(tile):	
	return get_parent().get_node("map").is_tile_solid(tile);
	
func get_tile_type(pos):
	return get_parent().get_node("map").get_tile_type(pos);