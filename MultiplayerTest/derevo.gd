
extends Sprite2D


var gunrot = 0.0
var parentflip = false
func shoot():
	gunrot  = 3.14159 *0.5
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation =gunrot
	
	if(parentflip):
		pass
	else:
		pass
		#rotation =gunrot
	pass
