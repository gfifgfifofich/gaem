extends Node2D

var pl = preload("res://character_body_2d.tscn");

var namename = "stock"
# Called when the node enters the scene tree for the first time.
func _ready():
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
func sendCreated(id, idis, names):
	if(id == multiplayer.get_unique_id()):
		
		
		print("created player")
		created = true;
		for x in range(0,idis.size()):
			if id != x:
				localaddPlayer(idis[x],createdPlayerNames[x])

var sus = "12345"
var createdids = -1;
func localaddPlayer(id, nick):
	if(id not in createdPlayers):
		var pli = pl.instantiate()
		pli.position = Vector2(500,400)
		pli.id = id;
		pli.Nick = nick;
		add_child(pli);
		createdPlayers.append(pli.id)
		createdPlayerNames.append(pli.Nick)
		


@rpc("any_peer")
func addPlayer(id, nick):
	
	if(!multiplayer.is_server() and multiplayer.get_remote_sender_id() not in createdPlayers):
		
		var pli = pl.instantiate();
		
		pli.position = Vector2(0,0)
		pli.id = multiplayer.get_remote_sender_id();
		pli.Nick = nick;
		add_child(pli);
		createdids = pli.id
		createdPlayers.append(pli.id)
		createdPlayerNames.append(pli.Nick)
		
	elif(multiplayer.get_remote_sender_id() not in createdPlayers):
		
		var pli = pl.instantiate();
		
		pli.position = Vector2(500,400)
		pli.id = multiplayer.get_remote_sender_id();
		pli.Nick = nick;
		add_child(pli);
		createdPlayers.append(pli.id)
		createdPlayerNames.append(pli.Nick)
		
	if(multiplayer.is_server()):
		rpc("sendCreated",multiplayer.get_remote_sender_id(),createdPlayers)
	#players.append(pli);
	

@rpc("any_peer")
func pog(vel, pos,MousePos,shoot):
	#if(multiplayer.is_server()):
	
	for x in range (4,get_child_count()):
		if get_child(x).id == multiplayer.get_remote_sender_id() and get_child(x).id != 0:
			get_child(x).position = pos
			get_child(x).velocity = vel
			get_child(x).MousePos = MousePos
			get_child(x).shoot = shoot
			

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if(multiplayer.is_server() ):
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
	


