
extends Sprite2D

var bullet = preload("res://bullet.tscn")

var gunrot = 0.0
var parentflip = false
var cd = 1.0
func shoot():
	if(cd<=0):
		cd = 0.25
		var bli = bullet.instantiate()
		bli.position = $end.global_position;
		bli.velocity = $end.global_position	 - global_position
		get_parent().get_parent().get_child(2).add_child(bli)
	pass
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	cd -=delta
	rotation =gunrot
	
	pass
