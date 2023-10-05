extends Node2D

var pl = preload("res://Scenes/character_body_2d.tscn");

var en1 = preload("res://Scenes/Bleb.tscn");

var enemyPreloads =[]
var enemiesIDs =[]
var enemiesTypes =[]
var enemyHealths =[]
var enemyPositions =[]
var enemyTrgs =[]
var CreatedEnemyIds =[]
var namename = "stock"
# Called when the node enters the scene tree for the first time.
func _ready():
	enemyPreloads.append(en1)
	
	
	if(!multiplayer.is_server()):
		
		addPlayer(1,namename);
		
		
		rpc("addPlayer",1,namename)
	else:
		$Objects/PointLight2D.editor_only = false;
		pass
		#$Objects.visible=false
		#$Objects.queue_free()
	
	pass

var createdPlayers = [];
var createdPlayerNames = [];


var created = false


@rpc("any_peer")
func sendCreated(id, idis, names, enemiesType,enemiesID,enemyHealth,enemyPosition,enemyTrg):
	if(id == multiplayer.get_unique_id()):
		
		
		print("created player")
		created = true;
		for x in range(0,idis.size()):
			if id != idis[x]:
				localaddPlayer(idis[x],names[x])
		
		for x in range(0,enemiesID.size()):
			CreateEmeny(enemiesType[x],enemyPosition[x],enemiesID[x])
			$Enemies.get_child($Enemies.get_child_count()-1).health = enemyHealth[x]
			$Enemies.get_child($Enemies.get_child_count()-1).trg = enemyTrg[x]

var sus = "12345"
var createdids = -1;
func localaddPlayer(id, nick):
	if(id not in createdPlayers):
		var pli = pl.instantiate()
		pli.position = Vector2(-576,262)
		pli.id = id;
		pli.Nick = nick;
		add_child(pli);
		createdPlayers.append(pli.id)
		createdPlayerNames.append(pli.Nick)
		


@rpc("any_peer")
func addPlayer(id, nick):
	
	if(!multiplayer.is_server() and multiplayer.get_remote_sender_id() not in createdPlayers):
		
		var pli = pl.instantiate();
		
		pli.position = Vector2(-576,262)
		pli.id = multiplayer.get_remote_sender_id();
		pli.Nick = nick;
		add_child(pli,true);
		createdids = pli.id
		createdPlayers.append(pli.id)
		createdPlayerNames.append(pli.Nick)
		
	elif(multiplayer.get_remote_sender_id() not in createdPlayers):
		
		var pli = pl.instantiate();
		pli.position = Vector2(-576,262)
		pli.id = multiplayer.get_remote_sender_id();
		pli.Nick = nick;
		add_child(pli,true);
		createdPlayers.append(pli.id)
		createdPlayerNames.append(pli.Nick)
		
	if(multiplayer.is_server()):
		rpc("sendCreated",multiplayer.get_remote_sender_id(),createdPlayers,createdPlayerNames,enemiesTypes,enemiesIDs,enemyHealths,enemyPositions,enemyTrgs)
	#players.append(pli);
	

@rpc("any_peer")
func pog(vel, pos,MousePos,shoot,altshoot,weapons):
	#if(multiplayer.is_server()):
	
	for x in range (4,get_child_count()):
		if get_child(x).id == multiplayer.get_remote_sender_id() and get_child(x).id != 0:
			get_child(x).position = pos
			get_child(x).velocity = vel
			get_child(x).MousePos = MousePos
			get_child(x).shoot = shoot
			get_child(x).altshoot = altshoot
			get_child(x).CurrentWeapons = weapons

@rpc("any_peer")
func UpdateHealth(id,hp):
	if(!multiplayer.is_server()):
		for x in range (4,get_child_count()):
			if get_child(x).id == id:
				get_child(x).health = hp
			elif(get_child(x).id == 0 and multiplayer.get_unique_id() == id):
				get_child(x).health = hp
	pass
@rpc("any_peer")
func Deadge(id):
	if(!multiplayer.is_server()):
		for x in range (4,get_child_count()):
			if get_child(x).id == id:
				get_child(x).health = -10
			elif(get_child(x).id == 0 and multiplayer.get_unique_id() == id):
				get_child(x).health = -10
	pass

@rpc("any_peer")
func UpdatePlayers(ids):
	if(!multiplayer.is_server()):
		for x in range (4,get_child_count()):
			if get_child(x).id not in ids && get_child(x).id !=0:
				get_child(x).health = -10
				#get_child(x)._die()
	pass

@rpc("any_peer")
func CreateEmeny(enID,posiion,id):
	if(id not in CreatedEnemyIds):
		
		var inst = enemyPreloads[enID].instantiate();
		inst.position= posiion;
		inst.trg= posiion;
		inst.id = id;
		CreatedEnemyIds.append(id)
		$Enemies.add_child(inst);
	pass
@rpc("any_peer")
func UpdateEmenies(id,pos,vel,health,trg,type):
	if(!multiplayer.is_server()):
		var exists = false;
		for i in range(0,$Enemies.get_child_count()):
			if($Enemies.get_child(i).id == id):
				$Enemies.get_child(id).position = pos;
				$Enemies.get_child(id).velocity = vel;
				$Enemies.get_child(id).health = health;
				$Enemies.get_child(id).trg = trg;
				$Enemies.get_child(id).DeathT = 2.0;
				exists = true
		if(!exists):
			CreateEmeny(type,pos,id)
			$Enemies.get_child($Enemies.get_child_count()-1).health = health
			$Enemies.get_child($Enemies.get_child_count()-1).trg = trg
			

@rpc("any_peer")
func EnDeadge(id):
	for i in range(0,$Enemies.get_child_count()):
		if($Enemies.get_child(i).id == id):
			CreatedEnemyIds.erase(id)
			$Enemies.get_child(i).die()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	CreatedEnemyIds.resize($Enemies.get_child_count())
	for i in range(0,$Enemies.get_child_count()):
		CreatedEnemyIds[i] = $Enemies.get_child(i).id
	
	if(multiplayer.is_server()):
		
		if(Input.is_action_just_pressed("1")):
			
			var a=Vector2(randf_range(-500,200),randf_range(-100,200))
			CreateEmeny(0,a,$Enemies.get_child_count())
			rpc("CreateEmeny",0,a,$Enemies.get_child_count())
		var daids = []
		for x in range (4,get_child_count()):
			daids.append(get_child(x).id);
			rpc("UpdateHealth",get_child(x).id, get_child(x).health)
		rpc("UpdatePlayers",daids);
		
		
		enemiesIDs.resize($Enemies.get_child_count())
		enemiesTypes.resize($Enemies.get_child_count())
		enemyHealths.resize($Enemies.get_child_count())
		enemyPositions.resize($Enemies.get_child_count())
		enemyTrgs.resize($Enemies.get_child_count())
		CreatedEnemyIds.resize($Enemies.get_child_count())
		for i in range(0,$Enemies.get_child_count()):
			enemiesIDs[i]=$Enemies.get_child(i).id
			enemiesTypes[i]=$Enemies.get_child(i).EnemyID
			enemyHealths[i]=$Enemies.get_child(i).health
			enemyPositions[i]=$Enemies.get_child(i).position
			enemyTrgs[i]=$Enemies.get_child(i).trg
			CreatedEnemyIds[i] = $Enemies.get_child(i).id
			rpc("UpdateEmenies",$Enemies.get_child(i).id,$Enemies.get_child(i).position,$Enemies.get_child(i).velocity,$Enemies.get_child(i).health,$Enemies.get_child(i).trg,$Enemies.get_child(i).EnemyID)
			if($Enemies.get_child(i).health<=0):
				EnDeadge($Enemies.get_child(i).id)
				rpc("EnDeadge",$Enemies.get_child(i).id)
		
		var v = Vector2(0,0)
		var n = 0
		var maxx = -100000
		var mix = 1000000
		for x in range (4,get_child_count()):
			v+=get_child(x).position
			var vvv = get_child(x).position;
			if(vvv.x<mix):
				mix=vvv.x
			if(vvv.x>maxx):
				maxx=vvv.x
			
			n+=1
		
		
		
		$Camera2D.enabled = true
		if(n>0):
			var dif = abs((maxx - mix))
			
			#$Camera2D.zoom = Vector2(max(1- log(dif/1024),1.0),max(1.0,1-log(dif/1024)))
			$Camera2D.zoom = Vector2(1,1)
			v/=n
			$Camera2D.position = v
			
	pass
	


