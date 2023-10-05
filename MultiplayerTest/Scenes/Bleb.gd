extends CharacterBody2D

const EnemyID = 0
var id = -1;
const SPEED = 50.0
const JUMP_VELOCITY = -400.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var bodies = []
var trg = Vector2(0,0)
var health = 100
func _ready():
	
	add_to_group("enemies")
	
	
func die():
	
	
	
	queue_free()
	
func _physics_process(delta):
	# Add the gravity.
	if(health <= 0):
		die()
	
	var dist = 100000000
	var v = Vector2()
	for x in bodies:
		if((x.global_position-global_position).length_squared() < dist):
			trg = x.global_position
			dist = (x.global_position-global_position).length_squared() 
		pass
	
	if(global_position.x<trg.x):
		velocity.x = SPEED;
	
	if(global_position.x>trg.x):
		velocity.x = -SPEED;
	
	if is_on_floor():
		velocity.y = 0.0
	if is_on_floor() and global_position.y>trg.y + 30:
		velocity.y = JUMP_VELOCITY
	
	velocity.y += gravity * delta
	
	# Handle Jump.

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	

	move_and_slide()


func _on_area_2d_body_entered(body):
	if(body.name.length()>=6):
		var nam = str(body.name)
		if(nam[0] == 'P' and nam[1] == 'l' and nam[2] == 'a' and nam[3] == 'y' and nam[4] == 'e' and nam[5] == 'r'):
			bodies.append(body)
	pass # Replace with function body.


func _on_area_2d_body_exited(body):
	if(body.name.length()>=6):
		var nam = str(body.name)
		if(nam[0] == 'P' and nam[1] == 'l' and nam[2] == 'a' and nam[3] == 'y' and nam[4] == 'e' and nam[5] == 'r'):
			bodies.erase(body)
	pass # Replace with function body.