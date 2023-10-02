extends Control

var pl = preload ("res://node_2d.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_exit_pressed():
	get_tree().quit()


func _on_settings_pressed():
	$MainMenu.visible = false
	$SettingsMenu.visible = true


func _on_play_pressed():
	$MainMenu.visible = false
	$ServerMenu.visible = true


func _on_return_pressed():
	$MainMenu.visible = true
	$ServerMenu.visible = false


func _on_connect_pressed():
	
	var ip = $ServerMenu/DirectJoinMenu/IpEdit.text
	var port = int(float($ServerMenu/DirectJoinMenu/PortEdit.text))
	
	if(port == null or ip == null):
		return;
	
	var clientPeer = ENetMultiplayerPeer.new();
	clientPeer.create_client(ip, port);
	multiplayer.multiplayer_peer = clientPeer;
	
	var pli = pl.instantiate()
	pli.namename = "testName"
	add_child(pli);
	


func _on_close_pressed():
	$ServerMenu/DirectJoinMenu.visible = false
	$ServerMenu/DirectJoinMenu/IpEdit.text = '127.0.0.1'
	$ServerMenu/DirectJoinMenu/PortEdit.text = '25565'


func _on_join_pressed():
	$ServerMenu/DirectJoinMenu.visible = true


func _on_host_close_pressed():
	$ServerMenu/HostMenu.visible = false
	$ServerMenu/HostMenu/PortEdit.text = "25565"
	$ServerMenu/HostMenu/PlayerCountEdit.text = "8"


func _on_host_pressed():
	
	var port = int(float($ServerMenu/HostMenu/PortEdit.text))
	
	var maxPlayers = int(float($ServerMenu/HostMenu/PlayerCountEdit.text))
	var serverPeer = ENetMultiplayerPeer.new();
	
	serverPeer.create_server(port, maxPlayers);
	multiplayer.multiplayer_peer = serverPeer;
	
	
	var pli = pl.instantiate()
	pli.namename = "testName"
	add_child(pli);
	


func _on_host_menu_open_pressed():
	$ServerMenu/HostMenu.visible = true
