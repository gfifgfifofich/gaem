extends  Node


var gvariableEboai = "Eboai";
var MainNode = null;
var ObjectsNode = null;
var WeaponsArr = []

var Derevo = preload("res://Scenes/derevo.tscn")
var dagun = preload("res://Scenes/dagun.tscn")
var grenadeLauncher = preload("res://Scenes/grenade_canon.tscn")



var Player = false;
# Called when the node enters the scene tree for the first time.
func _ready():
	WeaponsArr.append(Derevo)
	WeaponsArr.append(dagun)
	WeaponsArr.append(grenadeLauncher)
	gvariableEboai = "G ready Eboai";
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	gvariableEboai = "G _process Eboai";
	pass
