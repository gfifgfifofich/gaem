extends CharacterBody2D

const EnemyID = 1
const cost = 5.0

var id = -1;
const SPEED = 50.0
const JUMP_VELOCITY = -900.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var bodies = []
var trg = Vector2(0,0)
var health = 100
var DeathT = 2.0


var VecAccum = Vector2(0,0)
var jumpT = 1;
func _ready():
	
	add_to_group("enemies")
	
	
func die():
	get_parent().get_parent().CreatedEnemyIds.erase(id);
	queue_free()

func _physics_process(delta):
	$ProgressBar.value = health
	
	if $ProgressBar.value >= 100:
		$ProgressBar.visible = false;
	else:
		$ProgressBar.visible = true;
			
	# Add the gravity.
	if(!multiplayer.is_server()):
		if(DeathT<=0):
			die()
	
	var dist = 100000000
	var v = Vector2()
	for x in bodies:
		if((x.global_position-global_position).length_squared() < dist):
			trg = x.global_position
			dist = (x.global_position-global_position).length_squared() 
		pass
	
	if(!multiplayer.is_server()):
		DeathT-=delta
	if(global_position.x<trg.x):
		VecAccum.x += SPEED * delta;
	
	if(global_position.x>trg.x):
		VecAccum.x += -SPEED* delta;
	
	if is_on_floor():
		velocity.y = 0.0
	if is_on_floor() and global_position.y>trg.y + 30:
		velocity.y = JUMP_VELOCITY * delta
	if is_on_floor():
		VecAccum.y += JUMP_VELOCITY * delta
		velocity.x *= 1.0 - delta*10;
	velocity.y += gravity * delta
	
	jumpT -=delta
	if(jumpT<=0.0):
		jumpT=1
		velocity += VecAccum;
		VecAccum = Vector2(0,0)
	# Handle Jump.
	move_and_slide()


func _on_area_2d_body_entered(body):
	if(body.is_in_group("players")):
			bodies.append(body)
	pass # Replace with function body.


func _on_area_2d_body_exited(body):
	if(body.is_in_group("players")):
			bodies.erase(body)
	pass # Replace with function body.
