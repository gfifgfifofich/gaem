extends ProgressBar
var node2d
# Called when the node enters the scene tree for the first time.
func _ready():
	node2d = get_parent().get_parent().get_parent().get_child(4)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for x in range (4,node2d.get_child_count()):
			if node2d.get_child(x).id == 0:
				value = node2d.get_child(x).health 
