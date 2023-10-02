extends Node2D

var pl = preload ("res://node_2d.tscn")

func _on_button_2_button_down():
	
	var clientPeer = ENetMultiplayerPeer.new();
	clientPeer.create_client($TextEdit2.text, 25565);
	multiplayer.multiplayer_peer = clientPeer;
	
	var pli = pl.instantiate()
	pli.namename = $TextEdit.text
	add_child(pli);




func _on_button_button_down():
	var serverPeer = ENetMultiplayerPeer.new();
	serverPeer.create_server(25565, 8);
	multiplayer.multiplayer_peer = serverPeer;
	$Button.visible = false;
	$Button2.visible = false;
	$TextEdit.visible = false;
	visible=false
	var pli = pl.instantiate()
	pli.namename = $TextEdit.text
	add_child(pli);
