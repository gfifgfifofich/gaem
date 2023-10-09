extends CharacterBody2D

const EnemyID = 3
const cost = 100.0

var id = -1;
const SPEED = 100.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var projectile = preload("res://Scenes/pidarGun.tscn")

var bodies = []
var trg = Vector2(0,0)

var maxHealth = 10000
var health
var DeathT = 2.0
var attackCooldown = 5.0
var timeAfterAttack =0.0;


var VecAccum = Vector2(0,0)
var jumpT = 1;
func _ready():
	health = maxHealth
	
	
	add_to_group("enemies")
	
	
func die():
	get_parent().get_parent().CreatedEnemyIds.erase(id);
	queue_free()

func _physics_process(delta):
	$ProgressBar.value = ( health / maxHealth ) * 100
	
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
	
	var kiksus = 1;
	if((trg - global_position).x>0.0):
		$CharacterBody2D.flip_h = true
		kiksus = 1;
	else:
		$CharacterBody2D.flip_h = false
		kiksus = -1
		
	
	
	if((trg - global_position).length()>200):
		velocity = (trg - global_position).normalized() * SPEED
		
	move_and_slide()


func _on_area_2d_body_entered(body):
	if(body.is_in_group("players")):
			bodies.append(body)
	pass # Replace with function body.


func _on_area_2d_body_exited(body):
	if(body.is_in_group("players")):
			bodies.erase(body)
	pass # Replace with function body.
