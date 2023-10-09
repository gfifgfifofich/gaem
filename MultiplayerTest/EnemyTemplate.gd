extends CharacterBody2D

var enemyID : int
var id : int = -1;
var spawningCost : float

var maxHealth : float
var currentHealth : float

var targetPosition : Vector2
var distanceToTarget : float
var isTargetingCrystal : bool

var visiblePlayerBodies : Array

func _basicEnemyProcess():
	_updateHealthBar()
	_findTarget()
	
func GetDamage(value : float):
	maxHealth -= value
	if maxHealth <= 0:
		_die()
	
func _die():
	Global.MainNode.CreatedEnemyIds.erase(id)
	queue_free()
	
func _updateHealthBar():
	$HealthBar.value = (currentHealth / maxHealth) * 100
func _findTarget():
	if(visiblePlayerBodies.size() <= 0 or isTargetingCrystal):
		#Ставить таргет на кристалл, Global.Crystal.Position
		pass
	else:
		for body in visiblePlayerBodies:
			if (body.global_position - global_position).length_squared() < distanceToTarget:
				targetPosition = body.global_position
				distanceToTarget = (body.global_position - global_position).length_squared()
	
func _ready():
	currentHealth = maxHealth
	
	add_to_group("enemies")
	_findTarget()
	
func _physics_process(delta):
	
	_basicEnemyProcess();
	
	#Code


func _on_vision_area_body_entered(body):
	if body.is_in_group("players"):
		visiblePlayerBodies.append(body)


func _on_vision_area_body_exited(body):
	if body.is_in_group("players"):
		visiblePlayerBodies.erase(body)
