extends Node2D

var dmg = 1

var colliders = Array()

func _ready():
	set_fixed_process(true)
	get_node("Area2D").connect("body_enter", self, "collision")
	get_node("Area2D").connect("body_exit", self, "collision_end")
	
func _fixed_process(delta):
	if colliders.size() > 0:
		for i in range(0, colliders.size()):
			colliders[i].hit(dmg)	

func collision(body):
	colliders.push_back(body)
	
func collision_end(body):
	colliders.remove(colliders.find(body))
	
func set_damage(damage):
	self.dmg = damage
	