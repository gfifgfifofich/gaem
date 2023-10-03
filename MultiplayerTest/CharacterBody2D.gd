extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -300.0
var maxHealth = 100;
var health = 100;

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var id = -1
var yoMamaId = -1
var isCreated = false;

var rd = 0
var Nick = "abobus"
var t =0;
var MousePos = Vector2(0.0,0.0);
var shoot = false;
func _die():
	if(id == 0):
		get_tree().change_scene_to_file("res://MainMenu.tscn")
		pass
	queue_free()
	

func _physics_process(delta):
	if health <= 0:
		_die();
	if(abs(velocity.x)>1):
		$Icon.flip_h = velocity.x<0
	t+=delta
	$Icon.position.y = -2-sin(t)*2;
	
	
	
	#$Camera2D.limit_bottom = get_parent().get_child(3).limit_bottom
	##$Camera2D.limit_left = get_parent().get_child(3).limit_left
	#$Camera2D.limit_right = get_parent().get_child(3).limit_right
	#$Camera2D.limit_top = get_parent().get_child(3).limit_top
	
	$gun.gunrot = get_angle_to(MousePos) + deg_to_rad(90)
	if(shoot):
		$gun.shoot();
	
	if(multiplayer.is_server() or id !=0 ):
		
		if not is_on_floor():
			velocity.y += gravity * delta
		$Label.text = Nick
		
		$PointLight2D.visible=false;
		move_and_slide()
		return;
	MousePos = get_global_mouse_position();
	$gun.parentflip = $Icon.flip_h ;
	
	if(Input.is_action_pressed("MainAttack")):
		shoot = true;
	else:
		shoot = false
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("Up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if(id==0):
		Nick = get_parent().namename
		$Camera2D.enabled = true
	if(!multiplayer.is_server() and multiplayer.connected_to_server):
		if(!get_parent().created):
			
			get_parent().rpc("addPlayer",1,Nick)
			print ("not obamka")
			rd +=1;
			
		if(id==0):
			get_parent().rpc("pog",velocity, position,MousePos,shoot)
		
	
	$Label.text = Nick
	
	move_and_slide()
	
