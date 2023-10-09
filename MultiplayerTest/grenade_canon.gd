
extends Node2D

var bullet = preload("res://Scenes/grenade.tscn")
var mp = Vector2(0.0,0.0)
var parentflip = false
var cd = 2.0
var WeaponID = 2

func shoot():
	if(cd<=0):
		cd = 2
		var bli = bullet.instantiate()
		bli.position = $FirePoint.global_position;
		bli.linear_velocity = ($FirePoint.global_position - global_position)*20.0
		Global.ObjectsNode.add_child(bli)
	pass

func altshoot():
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cd -=delta
	rotation = 0.0
	rotation = get_angle_to(mp) + deg_to_rad(90)
	
	pass
