extends Control

var savePath = "res://Scenes/prefs.cfg"
var config = ConfigFile.new()
var loadResponse = config.load(savePath)

var pl = preload ("res://Scenes/node_2d.tscn")
var ui = preload("res://Scenes/player_interface.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.

var t =0
func _process(delta):
	t+=delta
	$Sprite2D2.material.set_shader_parameter("line_color", Color((sin(t*1)+1.0)*0.125,(sin(t*0.3)+1.0)*0.125,(sin(t*0.5)+1.0)*0.125,1.0))
	
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
	
	$Sprite2D2.visible = false;
	$ServerMenu.visible = false;
	$MainMenu.visible = false;
	$SettingsMenu.visible = false;
	var clientPeer = ENetMultiplayerPeer.new();
	clientPeer.create_client(ip, port);
	multiplayer.multiplayer_peer = clientPeer;
	
	var pli = pl.instantiate()
	pli.namename = config.get_value("UserData", "Username", "PlayerDefault")
	add_child(pli);
	var uii = ui.instantiate()
	add_child(uii)
	


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
	
	$Sprite2D2.visible = false;
	$ServerMenu.visible = false;
	$MainMenu.visible = false;
	$SettingsMenu.visible = false;
	var pli = pl.instantiate()
	pli.namename = "testName"
	add_child(pli);
	


func _on_host_menu_open_pressed():
	$ServerMenu/HostMenu.visible = true


func _on_close_button_pressed():
	config.set_value("UserData", "Username", $SettingsMenu/TabContainer/User/LineEdit.text)
	config.save(savePath)
	$MainMenu.visible = true
	$SettingsMenu.visible = false
	


func _on_tab_container_tab_selected(tab):
	pass # Replace with function body.







func _on_user_ready():
	$SettingsMenu/TabContainer/User/LineEdit.text = config.get_value("UserData", "Username", "PlayerDefault")
	pass # Replace with function body.


func _on_item_list_ready():
	var serverList = config.get_value("UserData", "ServerList", ["Localhost 127.0.0.1:25565"])
	if serverList == null:
		return
	for s in serverList:
		if(s == "Localhost 127.0.0.1:25565"):
			continue
		$ServerMenu/ItemList.add_item(s);
		


func _on_server_menu_focus_exited():
	var serverArray = []
	print("saving server list")
	for i in range(0,$ServerMenu/ItemList.item_count):
		serverArray.append($ServerMenu/ItemList.get_item_text(i))
	config.set_value("UserData", "ServerList", serverArray)
	config.save(savePath)


func _on_add_server_to_list_pressed():
	var ServerNameLine = $ServerMenu/ServerNameLineEdit
	var ipLine = $ServerMenu/IpLineEdit
	var portLine = $ServerMenu/PortLineEdit
	
	
	$ServerMenu/ItemList.add_item("{name} {ip}:{port}".format({"name": ServerNameLine.text, "ip": ipLine.text, "port":portLine.text}))
	ServerNameLine.text = ""
	ipLine.text = ""
	portLine.text = ""
	
	var serverArray = []
	print("saving server list")
	for i in range(0,$ServerMenu/ItemList.item_count):
		serverArray.append($ServerMenu/ItemList.get_item_text(i))
	config.set_value("UserData", "ServerList", serverArray)
	config.save(savePath)
	



func _on_remove_server_from_list_pressed():
	if not $ServerMenu/ItemList.is_anything_selected():
		return
	$ServerMenu/ItemList.remove_item($ServerMenu/ItemList.get_selected_items()[0])
	
	var serverArray = []
	print("saving server list")
	for i in range(0,$ServerMenu/ItemList.item_count):
		serverArray.append($ServerMenu/ItemList.get_item_text(i))
	config.set_value("UserData", "ServerList", serverArray)
	config.save(savePath)


func _on_item_list_item_activated(index):
	var ipPort = $ServerMenu/ItemList.get_item_text(index).split(" ")[1]
	var ip = ipPort.split(":")[0]
	var port = int(float(ipPort.split(":")[1]))
	
	var clientPeer = ENetMultiplayerPeer.new();
	clientPeer.create_client(ip, port);
	multiplayer.multiplayer_peer = clientPeer;
	
	$Sprite2D2.visible = false;
	$ServerMenu.visible = false;
	$MainMenu.visible = false;
	$SettingsMenu.visible = false;
	
	var pli = pl.instantiate()
	pli.namename = config.get_value("UserData", "Username", "PlayerDefault")
	add_child(pli);
	var uii = ui.instantiate()
	add_child(uii)


func _on_check_button_pressed():
	
	var isPressed = $SettingsMenu/TabContainer/Graphics/CheckButton.button_pressed
	if isPressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else :
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	config.set_value("UserData", "Fullscreen", isPressed)
	config.save(savePath)


func _on_check_button_ready():
	var isPressed = config.get_value("UserData", "Fullscreen")
	if isPressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else :
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	pass # Replace with function body.
