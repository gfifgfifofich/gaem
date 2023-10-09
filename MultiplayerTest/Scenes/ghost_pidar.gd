extends CharacterBody2D

const EnemyID = 2
const cost = 10.0

var id = -1;
const SPEED = 100.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var projectile = preload("res://Scenes/pidarGun.tscn")

var bodies = []
var trg = Vector2(0,0)
var health = 100
var DeathT = 2.0
var attackCooldown = 5.0
var timeAfterAttack =0.0;


var VecAccum = Vector2(0,0)
var jumpT = 1;
func _ready():
	add_to_group("enemies")
	
func die():
	
	get_parent().get_parent().CreatedEnemyIds.erase(id);
	
	queue_free()


func Attack(atckID, timer):
	
	if(atckID == 0):
		
		if(timer >= attackCooldown ):
			$FlareSound.play()
			var sus = projectile.instantiate();
			sus.position = $FirePoint.global_position
			sus.velocity = (trg - $FirePoint.global_position).normalized() * 300
			Global.ObjectsNode.add_child(sus);
			timeAfterAttack = 0.0
		elif(timer + 0.166666666*4 >=attackCooldown ):
			$CharacterBody2D.play("Attack")
		
		


func _physics_process(delta):
	if health<=0:
		$CharacterBody2D.play("Death")
		
	if(multiplayer.is_server()):
		if(bodies.size() >0):
			timeAfterAttack += delta;
		Global.MainNode.rpc("EnAttack",id,0,timeAfterAttack,global_position,trg);
		Attack(0,timeAfterAttack);
	
	if(!$CharacterBody2D.is_playing()):
		$CharacterBody2D.play("default")
	if(!$CharacterBody2D.animation == "default"):
		return
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
	
	
	if((trg - global_position).x>0.0):
		$CharacterBody2D.flip_h = true
	else:
		$CharacterBody2D.flip_h = false
		
	
	if((trg - global_position).length()>150):
		velocity = (trg - global_position).normalized() * SPEED
	else:
		var a = (trg - global_position).normalized();
		velocity =  Vector2(-a.y,a.x) * SPEED
	move_and_slide()
	
	
	
	


func _on_area_2d_body_entered(body):
	if(body.is_in_group("players")):
			bodies.append(body)
	pass # Replace with function body.


func _on_area_2d_body_exited(body):
	if(body.is_in_group("players")):
			bodies.erase(body)
	pass # Replace with function body.
