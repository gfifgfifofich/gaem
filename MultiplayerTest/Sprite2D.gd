extends RigidBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var bodies = []
var damage : int = 70
var lifeTime = 0.0;
var timeToExplode = 3.0;
var particle = preload("res://Particles/Test Particles.tscn")
var explosion = preload("res://Particles/explosion.tscn")

var blew = false

# Called when the node enters the scene tree for the first time.
func _ready():
	
	lifeTime = 0.0
	$Fuse.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	if(blew and !$Explosion.playing):
		queue_free()
	
	lifeTime += delta
	
	$ProgressBar.value = (lifeTime/timeToExplode ) * 100
	
	
	if(lifeTime > timeToExplode and !blew):
		
		var explI = explosion.instantiate()
		explI.global_position = position
		Global.ObjectsNode.add_child(explI)
		
		$Explosion.play()
		$Fuse.stop()
		for b in bodies:
			if(!b.is_in_group("players")):
				b.health -= damage
				var pi = particle.instantiate()
				pi.global_position = b.position
				pi.scale = Vector2(0.3,0.3)
				Global.ObjectsNode.add_child(pi)
		
		visible = false;
		blew = true
	
	


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





func _on_area_2d_2_body_entered(body):
	if(body.is_in_group("enemies")):
		lifeTime = timeToExplode + 10;
	pass # Replace with function body.
