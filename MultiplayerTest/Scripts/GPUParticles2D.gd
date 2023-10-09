extends GPUParticles2D


# Called when the node enters the scene tree for the first time.
var t = 0
var maxt = 0
var startScale = false
func _ready():
	emitting = true;
	maxt = lifetime;
	t = lifetime;
	if(get_child_count() == 1):
		startScale = get_child(0).scale
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(get_child_count() == 1):
		var stage = t/maxt
		get_child(0).scale = stage * startScale 
		t-=delta
		
		if(not emitting ||get_child(0).scale.x<0.0 || get_child(0).scale.x > startScale.x*2.0):
			queue_free()
		pass
	elif(not emitting):
		queue_free()
	pass
