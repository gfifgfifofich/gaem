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
var altshoot = false;

var deathTimer = 0.25


var Derevo = preload("res://Scenes/derevo.tscn")
var dagub = preload("res://Scenes/dagun.tscn")

var Weapons = []
var CurrentWeapons = [-1,-1]
var yay = 0
func addWeapon(wep):
	if(wep >-1):
		var wepi = Weapons[wep].instantiate()
		wepi.scale *= Vector2(1.0,1.0)
		wepi.WeaponID = wep
		$Weapons.add_child(wepi)
	
	
func SetWeapons(weparr):
	if($Weapons.get_child_count() ==2):
		if($Weapons.get_child(0).WeaponID == weparr[0] && $Weapons.get_child(1).WeaponID == weparr[1]):
			return
		elif($Weapons.get_child(1).WeaponID == weparr[0] && $Weapons.get_child(0).WeaponID == weparr[1]):
			return
	if($Weapons.get_child_count() ==1 && (weparr[0] ==-1 || weparr[1] == -1) ):
		if($Weapons.get_child(0).WeaponID == weparr[0] || $Weapons.get_child(0).WeaponID == weparr[1]):
			return
	
	if($Weapons.get_child_count() > 0):
		$Weapons.get_child(0).free()
	if($Weapons.get_child_count() > 0):
		$Weapons.get_child(0).free()
	
	addWeapon(weparr[0])
	addWeapon(weparr[1])
	
	CurrentWeapons = weparr

func _ready():
	Weapons.append(Derevo);
	Weapons.append(dagub);
	SetWeapons([1,-1])
	
	pass

func _die(delta):
	if(!multiplayer.is_server()):
		queue_free()
		if(id == 0):
			get_tree().change_scene_to_file("res://MainMenu.tscn")
			pass
	else:
		visible = false;
		deathTimer -= delta
		get_parent().rpc("Deadge",id)
		if(deathTimer<=0):
			queue_free()


func _physics_process(delta):
	if health <= 0:
		_die(delta);
	if(abs(velocity.x)>1):
		$Icon.flip_h = velocity.x<0
	t+=delta
	$Icon.position.y = -2-sin(t)*2;
	
	
	SetWeapons(CurrentWeapons)
	#$Camera2D.limit_bottom = get_parent().get_child(3).limit_bottom
	##$Camera2D.limit_left = get_parent().get_child(3).limit_left
	#$Camera2D.limit_right = get_parent().get_child(3).limit_right
	#$Camera2D.limit_top = get_parent().get_child(3).limit_top
	if($Weapons.get_child_count()==1):
		$Weapons.get_child(0).position = Vector2(0.0,0.0)
		$Weapons.get_child(0).mp = MousePos
		$Weapons.get_child(0).parentflip = $Icon.flip_h ;
		if(shoot):
			$Weapons.get_child(0).shoot();
		
		if(altshoot):
			$Weapons.get_child(0).altshoot();
		
	elif($Weapons.get_child_count()==2):
		$Weapons.get_child(0).position = Vector2(-5.0,0.0)
		$Weapons.get_child(1).position = Vector2(5.0,0.0)
		
		$Weapons.get_child(0).mp = MousePos
		$Weapons.get_child(1).mp = MousePos
		
		$Weapons.get_child(0).parentflip = $Icon.flip_h ;
		$Weapons.get_child(1).parentflip = $Icon.flip_h ;
		if(shoot):
			$Weapons.get_child(0).shoot();
		
		if(altshoot):
			$Weapons.get_child(1).shoot();
	
	if((id !=0) && !(id==-1 && multiplayer.is_server())):
		
		if not is_on_floor():
			velocity.y += gravity * delta
		$Label.text = Nick
		
		$PointLight2D.visible=false;
		move_and_slide()
		return;
	MousePos = get_global_mouse_position();
	
	if(Input.is_action_just_pressed("1")):
		yay+=1;
	if(yay >=3):
		yay =0
	if yay ==0:
		CurrentWeapons = [1,-1]
	if yay ==1:
		CurrentWeapons = [1,0]
	if yay ==2:
		CurrentWeapons = [-1,-1]
	
	
	if(Input.is_action_pressed("MainAttack")):
		shoot = true;
	else:
		shoot = false
	
	if(Input.is_action_pressed("AlternativeAttack")):
		altshoot = true;
	else:
		altshoot = false
	
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
	
	Nick = get_parent().namename
	$Camera2D.enabled = true
	if(!multiplayer.is_server() and multiplayer.connected_to_server):
		if(!get_parent().created):
			
			get_parent().rpc("addPlayer",1,Nick)
			#print ("not obamka")
			rd +=1;
		
		get_parent().rpc("pog",velocity, position,MousePos,shoot,altshoot,CurrentWeapons)
	
	if(multiplayer.is_server()):
		if(!get_parent().created):
			get_parent().createdPlayers.append(0)
			get_parent().createdPlayerNames.append("host")
			get_parent().created=true;
		get_parent().rpc("pog",velocity, position,MousePos,shoot,altshoot,CurrentWeapons)
		
		#if(id==0):
		#	get_parent().rpc("pog",velocity, position,MousePos,shoot,altshoot,CurrentWeapons)
		
	
	$Label.text = Nick
	
	move_and_slide()
	
