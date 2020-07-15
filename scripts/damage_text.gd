extends Label


var velocity = Vector2()
var speed = 20

var lifespan = 1.0
var age = 0
var min_scale = 0.8

func _ready():
	rect_position += Vector2(-10, -10)
	velocity = Vector2(randf() * 2.0 - 1, randf() - 2)
	
func _physics_process(delta):
	rect_position += velocity * speed * delta
	age += delta
	
	var new_scale = 1 - (age / lifespan * 1 - min_scale)
	rect_scale = Vector2(new_scale, new_scale)
	
	if age > lifespan:
		queue_free()
