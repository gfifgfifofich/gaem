
extends Sprite2D

var bullet = preload("res://Scenes/bullet.tscn")
var mp = Vector2(0.0,0.0)
var parentflip = false
var cd = 1.0
var WeaponID = -1
func shoot():
	if(cd<=0):
		cd = 0.25
		var bli = bullet.instantiate()
		bli.position = $end.global_position;
		bli.velocity = ($end.global_position - global_position)*10.0
		Global.ObjectsNode.add_child(bli)
	pass

func altshoot():
	if(cd<=0):
		cd = 0.75
		var bli = bullet.instantiate()
		bli.position = $end.global_position;
		bli.velocity = ($end.global_position - global_position)*5.0
		Global.ObjectsNode.add_child(bli)
		bli = bullet.instantiate()
		bli.position = $end.global_position;
		bli.velocity = ($end.global_position - global_position)*9.0
		Global.ObjectsNode.add_child(bli)
		bli = bullet.instantiate()
		bli.position = $end.global_position;
		bli.velocity = ($end.global_position - global_position)*1.0
		Global.ObjectsNode.add_child(bli)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cd -=delta
	rotation = 0.0
	rotation = get_angle_to(mp) + deg_to_rad(90)
	
	pass
