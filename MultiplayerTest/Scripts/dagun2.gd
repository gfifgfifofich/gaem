
extends Sprite2D
var partic = preload("res://Particles/Test Particles2.tscn")
var bullet = preload("res://Scenes/bullet.tscn")
var mp = Vector2(0.0,0.0)
var parentflip = false
var cd = 1.0
var WeaponID = -1
var shot = false;
func shoot():
	shot = true
	$Sprite2D.visible =true
	$Sprite2D.scale.y = 0.039 * (((($RayCast2D.get_collision_point() - global_position)).length()-(global_position - $Sprite2D.global_position).length())*0.2 )
	
	var pi = partic.instantiate()
	pi.global_position = $RayCast2D.get_collision_point()
	pi.scale = Vector2(0.3,0.3)
	get_parent().get_parent().get_parent().get_child(2).add_child(pi)
	pass

func altshoot():
	pass

var bodies = []

func _process(delta):
	if($Sprite2D.visible ==true):
		for b in bodies:
			b.health -= delta * 50
			
			var pi = partic.instantiate()
			pi.global_position = b.position
			pi.scale = Vector2(0.3,0.3)
			get_parent().get_parent().get_parent().get_child(2).add_child(pi)
			pass
	
	if rotation > deg_to_rad(0) && rotation < deg_to_rad(180):
		flip_h = false
	else:
		flip_h = true
	
	if(!shot):
		$Sprite2D.visible =false
	else:
		shot = false
	cd -=delta
	rotation = 0.0
	rotation = get_angle_to(mp) + deg_to_rad(90)
	pass


func _on_area_2d_body_entered(body):
	
	if(body.name.length()>=6):
		var nam = str(body.name)
		if(nam[0] == 'P' and nam[1] == 'l' and nam[2] == 'a' and nam[3] == 'y' and nam[4] == 'e' and nam[5] == 'r'):
			bodies.append(body)
	if(body.is_in_group("enemies")):
			bodies.append(body)
		
	pass # Replace with function body.


func _on_area_2d_body_exited(body):
	
	if(body.name.length()>=6):
		var nam = str(body.name)
		if(nam[0] == 'P' and nam[1] == 'l' and nam[2] == 'a' and nam[3] == 'y' and nam[4] == 'e' and nam[5] == 'r'):
			bodies.erase(body)
	
	if(body.is_in_group("enemies")):
			bodies.erase(body)
	pass # Replace with function body.
