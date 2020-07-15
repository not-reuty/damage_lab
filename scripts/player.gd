extends Area2D

var attack_speed = 1.2
var time_since_last_attack = 0
var is_attacking = false

var projectile = load("res://scenes/projectile.tscn")
var projectile_damage = 10

func _process(delta):
	
	# check that the player is attacking (key set in project settings)
	if is_attacking:
		# also check if the player can attack (attack speed limits this)
		if time_since_last_attack >= 1.0 / float(attack_speed):
			# here we can let the player attack, which means resetting the timer
			time_since_last_attack = 0
			
			# and creating a new projectile
			var new_projectile = projectile.instance()
			new_projectile.damage = projectile_damage
			# and add it to the tree under the player (could be under the world too)
			add_child(new_projectile)
		
	# always add to the timer because it's set to 0 when the player attacks
	time_since_last_attack += delta




# ==== UI FUNCTIONS ====
# the following functions only exist to change the values in the code using the UI,
# if you use this in a real project you can delete all of these!

func _on_attack_toggle_toggled(button_pressed):
	is_attacking = !is_attacking

func _on_attack_speed_slider_value_changed(value):
	attack_speed = value

func _on_damage_slider_value_changed(value):
	projectile_damage = value

func _on_attack_button_pressed():# and creating a new projectile
	var new_projectile = projectile.instance()
	new_projectile.damage = projectile_damage
	# and add it to the tree under the player (could be under the world too)
	add_child(new_projectile)
