extends Area2D

var direction = Vector2(1,0)
var speed = 500
var gforce = 5

var damage = 10.0
var age = 0

func _physics_process(delta):
	
	position += direction.normalized() * speed * delta
	
	age += delta
	if age > 3:
		queue_free()


func _on_projectile_area_shape_entered(area_id, area, area_shape, self_shape):
	if area.is_in_group('enemies'):
		area.take_damage(damage)
		queue_free()
