extends Sprite2D

var t = 0;
func _ready():
	t = randf_range(0.0,1000.0)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var s = 0.7 + 0.3*(abs(sin(t)*0.5) + abs(sin(t*10.231))*0.1 +  abs(sin(t*6.342))*0.2 +  abs(sin(t*2.321))*0.3)
	s*= 0.4
	t+= delta 
	$PointLight2D.scale = Vector2(s,s);
	pass
