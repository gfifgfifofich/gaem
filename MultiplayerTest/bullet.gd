extends CharacterBody2D



var partic = preload("res://Particles/Test Particles.tscn")

var t = 15.0

func _physics_process(delta):
	t-=delta
	if(t<=0.0):
		dead()
	move_and_slide()

func dead():
	var pi = partic.instantiate()
	pi.position = position
	pi.scale = Vector2(0.3,0.3)
	get_parent().add_child(pi)
	
	



func _on_area_2d_body_entered(body):
	dead()
	if(body.name.length()>=6):
		var nam = str(body.name)
		if(nam[0] == 'P' and nam[1] == 'l' and nam[2] == 'a' and nam[3] == 'y' and nam[4] == 'e' and nam[5] == 'r'):
			body.health -= 10;
	queue_free();
	pass # Replace with function body.
