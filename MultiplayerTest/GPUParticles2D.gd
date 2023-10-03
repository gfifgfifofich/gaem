extends GPUParticles2D


# Called when the node enters the scene tree for the first time.
var t = 0
func _ready():
	emitting = true;
	t = lifetime;
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(not emitting):
		t-=delta
	if(t<=0):
		queue_free()
	pass
