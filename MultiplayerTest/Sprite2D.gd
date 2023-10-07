extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var bodies = []
var damage : int = 70
var lifeTime = 0.0;
var particle = preload("res://Particles/Test Particles.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	lifeTime = 0.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	lifeTime += delta
	
	if(lifeTime < 7.0):
		return
	
	for b in bodies:
		if(!b.is_in_group("players")):
			b.health -= damage
			var pi = particle.instantiate()
			pi.global_position = b.position
			pi.scale = Vector2(0.3,0.3)
			Global.ObjectsNode.add_child(pi)
	


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
