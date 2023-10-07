extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var CurrentWeapons =[]

func SetWeapons(weparr):
	var WepCount = ($CanvasLayer/FirstArm/Pos.get_child_count()) + ($CanvasLayer/SecondArm/Pos.get_child_count()) 
	var id1 = -1;
	var id2 = -1;
	if($CanvasLayer/FirstArm/Pos.get_child_count()>0):
		id1 = $CanvasLayer/FirstArm/Pos.get_child(0).WeaponID
	
	if($CanvasLayer/SecondArm/Pos.get_child_count()>0):
		id2 = $CanvasLayer/SecondArm/Pos.get_child(0).WeaponID 
	
	if(id1 == weparr[0] && id2 == weparr[1]):
		return
	
	if($CanvasLayer/FirstArm/Pos.get_child_count() > 0):
		$CanvasLayer/FirstArm/Pos.get_child(0).free()
	if($CanvasLayer/SecondArm/Pos.get_child_count() > 0):
		$CanvasLayer/SecondArm/Pos.get_child(0).free()
		
	if(weparr[0] >-1 && weparr[0] < Global.WeaponsArr.size()):
		var wepi = Global.WeaponsArr[weparr[0]].instantiate()
		wepi.scale *= Vector2(2.0,2.0)
		wepi.WeaponID = weparr[0]
		$CanvasLayer/FirstArm/Pos.add_child(wepi)
	if(weparr[1] >-1 && weparr[1] < Global.WeaponsArr.size()):
		var wepi = Global.WeaponsArr[weparr[1]].instantiate()
		wepi.scale *= Vector2(2.0,2.0)
		wepi.WeaponID = weparr[1]
		$CanvasLayer/SecondArm/Pos.add_child(wepi)
	
	CurrentWeapons = weparr
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$CanvasLayer/HealthBar.value = Global.Player.health
	SetWeapons(Global.Player.CurrentWeapons);
