extends Node2D

var speed
var target_pos = null
var parent = null
var dmg = 0

func _ready():
	get_node("Area2D").connect("body_enter", self, "collision")
	set_fixed_process(true)
	
func set_speed(speed):
	self.speed = speed

func set_taget(target):
	target_pos = target
	set_rot(get_angle_to(target_pos))
	
func _fixed_process(delta):
	var direction = target_pos - get_pos()
	direction = direction.normalized( )
	direction.x = direction.x * speed * delta 
	direction.y = direction.y * speed * delta
	set_pos(get_pos() + direction)
		
	if (get_pos().distance_to(target_pos) <= 2):
		queue_free()


func collision(body):
	if (body.get_name() != "Player"):
		return
	body.hit(dmg)
	queue_free()
			
func hit(dmg):
	pass
