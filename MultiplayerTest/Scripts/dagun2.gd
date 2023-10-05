
extends Sprite2D
var partic = preload("res://Particles/Test Particles2.tscn")
var bullet = preload("res://Scenes/bullet.tscn")
var mp = Vector2(0.0,0.0)
var parentflip = false
var cd = 1.0
var WeaponID = -1
var shot = false;

var damage = 250;
func shoot():
	shot = true
	damage = 250
	$Sprite2D/PointLight2D.color = Color.LIGHT_SKY_BLUE
	$Sprite2D.scale.x = 0.025
	$Sprite2D.visible =true
	$Sprite2D.scale.y = 0.039 * (((($RayCast2D.get_collision_point() - global_position)).length()-(global_position - $Sprite2D.global_position).length())*0.2 )
	
	var pi = partic.instantiate()
	pi.global_position = $RayCast2D.get_collision_point()
	pi.scale = Vector2(0.3,0.3)
	get_parent().get_parent().get_parent().get_child(2).add_child(pi)
	pass

func altshoot():
	shot = true
	damage = 100
	$Sprite2D/PointLight2D.color = Color.DARK_RED
	$Sprite2D.scale.x = 0.1
	$Sprite2D.visible =true
	$Sprite2D.scale.y = 0.078 * (((($RayCast2D.get_collision_point() - global_position)).length()-(global_position - $Sprite2D.global_position).length())*0.2 )
	
	pass

var bodies = []

func _process(delta):
	if($Sprite2D.visible ==true):
		for b in bodies:
			if(!b.is_in_group("players")):
				b.health -= delta * damage
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
	
	#if(body.is_in_group("players")):
			#bodies.append(body)
	if(body.is_in_group("enemies")):
			bodies.append(body)


func _on_area_2d_body_exited(body):
	
	#if(body.is_in_group("players")):
		#bodies.erase(body)
	if(body.is_in_group("enemies")):
			bodies.erase(body)
