extends  Node


var gvariableEboai = "Eboai";
var MainNode = null;
var ObjectsNode = null;

var CrystallPosition : Vector2 = Vector2(0,0)

var WeaponsArr = [
				preload("res://Scenes/derevo.tscn"),
				preload("res://Scenes/dagun.tscn"),
				preload("res://Scenes/grenade_canon.tscn")
				]



var Player = false;
# Called when the node enters the scene tree for the first time.
func _ready():
	gvariableEboai = "G ready Eboai";
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	gvariableEboai = "G _process Eboai";
	pass
