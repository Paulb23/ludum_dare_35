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


var speed = 10
var time_to_move = 15;
var moving = false
var facing = 1
var worth = 5

var damage = 10;
var attack_speed = 10.0;

var max_health = 200
var health = 200

var attack_range = 900
var dead = false

var target_pos = get_pos();
var actual_pos = get_pos();

var arrow = load("res://characters/arrow.tscn")

func _ready():
	set_fixed_process(true)
	get_node("Timer").connect("timeout", self, "timer_end")
	get_node("Area2D").connect("body_enter", self, "collision")
	get_node("Area2D").connect("body_exit", self, "collision")
	
	
func _fixed_process(delta):
	var decrease = max_health - health
	var percent_decreace = float(decrease) / float(max_health)
	get_node("health_bar").set_percentage((float(1.00) - (float(percent_decreace))))
	
	# ugly but Meh!
	for i in range(0, time_to_move):
		if get_pos().distance_to(actual_pos) <= 0.1:
			moving = false
		
		if !moving:
			var path = get_parent().get_simple_path(get_pos(), get_player_pos())
			
			if get_player_pos().y < get_pos().y:
				facing = FACE_UP
			elif get_player_pos().y > get_pos().y:
				facing = FACE_DOWN
			elif get_player_pos().x > get_pos().x:
				facing = FACE_RIGHT
			elif get_player_pos().x < get_pos().x:
				facing = FACE_LEFT
			
			if (get_node("attack_timer").get_time_left() == 0 && get_parent().get_parent().get_node("Player").get_spell() != get_parent().get_parent().get_node("Player").MODE_EARTH):
				var node = arrow.instance()
				node.parent = "basic_range_enemy"
				node.dmg = damage
				node.set_pos(get_pos())
				node.set_speed(150)
				node.set_taget(get_player_pos())
				get_parent().add_child(node)
				get_node("attack_timer").set_wait_time(attack_speed)
				get_node("attack_timer").start()
		if moving:
			var motion = get_pos() - target_pos;
			motion = motion.normalized()
			motion = motion * delta * speed 
			move(motion)
			
	if !moving:
		if facing == FACE_DOWN:
			get_node("Sprite").set_frame(0)
		if facing == FACE_UP:
			get_node("Sprite").set_frame(8)
		if facing == FACE_LEFT:
			get_node("Sprite").set_frame(19)
		if facing == FACE_RIGHT:
			get_node("Sprite").set_frame(12)
			
			
func collision(body):
	if body.get_name() == "fire":
		pass
		
func move_node(direction):	
	moving = true
	target_pos = get_pos()
	actual_pos = get_pos()
	if direction == MOVE_UP:
		target_pos.y += Globals.get("TILE_SIZE")
		actual_pos.y -= Globals.get("TILE_SIZE")
		facing = FACE_UP
		get_node("AnimationPlayer").play("walk_up")
	if direction == MOVE_DOWN:
		target_pos.y -= Globals.get("TILE_SIZE")
		actual_pos.y += Globals.get("TILE_SIZE")
		facing = FACE_DOWN
		get_node("AnimationPlayer").play("walk_down")
	if direction == MOVE_LEFT:
		target_pos.x += Globals.get("TILE_SIZE")
		actual_pos.x -= Globals.get("TILE_SIZE")
		facing = FACE_LEFT
		get_node("AnimationPlayer").play("walk_left")
	if direction == MOVE_RIGHT:
		target_pos.x -= Globals.get("TILE_SIZE")
		actual_pos.x += Globals.get("TILE_SIZE")
		facing = FACE_RIGHT
		get_node("AnimationPlayer").play("walk_right")
		
	if is_tile_solid(get_tile_type(actual_pos)):
		moving = false

func is_tile_solid(tile):	
	return get_parent().get_parent().get_node("map").is_tile_solid(tile)
	
func get_tile_type(pos):
	return get_parent().get_parent().get_node("map").get_tile_type(pos)
	
func get_player_pos():
	return get_parent().get_parent().get_node("Player").get_pos()

func timer_end():
	get_node("Timer").stop()
	
func hit(dmg):
	health -= dmg
	
	if health <= 0.0 && not dead:
		dead = true
		get_parent().get_parent().kill_enemy(worth);
		self.queue_free()