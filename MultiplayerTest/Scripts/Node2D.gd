extends Node2D

var pl = preload("res://Scenes/character_body_2d.tscn");
var namename = "stock"
var en1 = preload("res://Scenes/Bleb.tscn");
var en2 = preload("res://Scenes/BlebSus.tscn");
var en3 = preload("res://Scenes/ghost_pidar.tscn");


var enemyPreloads =[preload("res://Scenes/Bleb.tscn"),
					preload("res://Scenes/BlebSus.tscn"),
					preload("res://Scenes/ghost_pidar.tscn"),
					preload("res://Scenes/demon.tscn")]
					
var enemyInstances =[]
var enemiesIDs =[]
var enemiesTypes =[]
var enemyHealths =[]
var enemyPositions =[]
var enemyTrgs =[]
var CreatedEnemyIds =[]


var SpawnPositions = []
# Called when the node enters the scene tree for the first time.
func _ready():
	Global.MainNode = self;
	Global.ObjectsNode = $Objects;
	
	for enemy in enemyPreloads:
		enemyInstances.append(enemy.instantiate())
	
	
	
	for i in $Objects/Spawners.get_children():
		SpawnPositions.append(i.position)
	
	
	
	if(!multiplayer.is_server()):
		addPlayer(1,namename);
		rpc("addPlayer",1,namename)
	else:
		localaddPlayer(-1,namename);
		
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
	if(multiplayer.get_remote_sender_id() not in createdPlayers):
		
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
		if (get_child(x).id == multiplayer.get_remote_sender_id() and get_child(x).id != 0) || ((get_child(x).id == -1 and multiplayer.get_remote_sender_id() ==1)):
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

@rpc("any_peer")
func UpdateEmenies(id,pos,vel,health,trg,type):
	if(!multiplayer.is_server()):
		var exists = false;
		for i in range(0,$Enemies.get_child_count()):
			if($Enemies.get_child(i).id == id):
				$Enemies.get_child(i).position = pos;
				$Enemies.get_child(i).velocity = vel;
				$Enemies.get_child(i).health = health;
				$Enemies.get_child(i).trg = trg;
				$Enemies.get_child(i).DeathT = 2.0;
				exists = true
		if(!exists):
			CreateEmeny(type,pos,id)
			$Enemies.get_child($Enemies.get_child_count()-1).health = health
			$Enemies.get_child($Enemies.get_child_count()-1).trg = trg
			

@rpc("any_peer")
func EnDeadge(id):
	for i in range(0,$Enemies.get_child_count()):
		if($Enemies.get_child(i).id == id):
			CreatedEnemyIds.erase(id);
			$Enemies.get_child(i).die()
	pass

@rpc("any_peer")
func EnAttack(id, attackid,timer, pos, trg):
	if(!multiplayer.is_server()):
		for i in range(0,$Enemies.get_child_count()):
			if($Enemies.get_child(i).id == id):
				$Enemies.get_child(i).global_position = pos;
				$Enemies.get_child(i).timeAfterAttack = timer;
				$Enemies.get_child(i).trg = trg;
				$Enemies.get_child(i).Attack(attackid,timer)
	pass

var SpawnTime =1.0
var WaveTimeLeft =0.0;

var waveDuration = 30.0
var wavePointGain = 3.0

var wavePoints =30.0

var wavevariation = [2]


func s_spawnEEEEE(type,pos):
	var a = Vector2(randf_range(-25,25),randf_range(-25,25))
	
	CreateEmeny(type,pos +a,$Enemies.get_child_count())
	
	rpc("CreateEmeny",type,pos+a,$Enemies.get_child_count())

func s_SpawnEnemy():
	
	var tryes2 = 3;
	for y in range(0, tryes2):
		var type = -1
		var lcst = -1;
		var i = 0 
		
		var tryes = 1;
		for x in range(0, tryes):
			i = randi_range(0,wavevariation.size()-1)
			if(enemyInstances[wavevariation[i]].cost <=wavePoints && enemyInstances[wavevariation[i]].cost>=lcst):
				type = i;
				lcst = enemyInstances[wavevariation[i]].cost;
		
		if(lcst>=0):
			var cnt = floor(wavePoints/lcst)
			for pohyi in range(1,cnt):
				s_spawnEEEEE(wavevariation[type], SpawnPositions[randi_range(0,SpawnPositions.size()-1)])
				wavePoints -= lcst;
	
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if(multiplayer.is_server()):
		
		SpawnTime -= delta;
		wavePoints += wavePointGain*delta
		WaveTimeLeft-=delta
		
		if(WaveTimeLeft<=0.0):
			if($Enemies.get_child_count()<=0):
				WaveTimeLeft=waveDuration
		else:
			if(SpawnTime<=0):
				SpawnTime = 3.0
				s_SpawnEnemy()
		
		
		if(Input.is_action_just_pressed("1")):
			var a=Vector2(randf_range(-500,200),randf_range(-100,200))
			CreateEmeny(0,a,$Enemies.get_child_count())
			rpc("CreateEmeny",0,a,$Enemies.get_child_count())
		
		var iiii = 4
		while iiii < get_child_count():
			
			if(get_child(iiii).id not in multiplayer.get_peers() and get_child(iiii).id != -1):
				Deadge(get_child(iiii).id)
				rpc("Deadge",get_child(iiii).id)
			iiii+=1;
		
		var daids = []
		for x in range (4,get_child_count()):
			daids.append(get_child(x).id);
			rpc("UpdateHealth",get_child(x).id, get_child(x).health)
		rpc("UpdatePlayers",daids);
		
		
		var iii = 0
		while iii < $Enemies.get_child_count():
			if($Enemies.get_child(iii).health<=0):
				EnDeadge($Enemies.get_child(iii).id)
				rpc("EnDeadge",$Enemies.get_child(iii).id)
				iii+=1;
			else:
				iii+=1;
		
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
	


