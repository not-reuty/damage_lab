extends Area2D


export var max_hitpoints = 100.0
var hitpoints = max_hitpoints

export var armor = 0

export var hp_regen_per_second = 5

export var immunity_time_after_hit = 0.2 # seconds
var time_since_last_hit = 0
var damage_text = load("res://scenes/damage_text.tscn")

# status specific variables
export var can_be_poisoned = false
var is_poisoned = true
var time_between_poison_hits = 0.5
var time_since_last_poison_hit = 0
var poison_duration_remaining = 0 # seconds
var poison_damage_per_tick = 2

export var can_be_burned = false
var is_burning = false
var time_between_burn_hits = 1.0
var time_since_last_burn_hit = 0
var burn_duration_remaining = 0 # seconds
var burn_hit_size = 0

var can_bleed = false
var is_bleeding = false
var time_between_bleed_hits = 1.0
var time_since_last_bleed_hit = 0
var bleed_duration_remaining = 0
var bleed_hit_size = 0

var can_freeze = false
var is_frozen = false
var freeze_duration_remaining = 0

func _physics_process(delta):
	
	# if the enemy is not at maximum health, apply its regeneration
	if hitpoints < max_hitpoints:
		if is_bleeding:
			hitpoints += (hp_regen_per_second * delta) / 2.0
		else:
			hitpoints += (hp_regen_per_second * delta)
			
	# and check for overhealing (only happens with very high regen rates)
	if hitpoints > max_hitpoints:
		hitpoints = max_hitpoints
		
	$health_bar.value = (hitpoints / max_hitpoints) * 100.0
	
	if is_poisoned:
		poison_duration_remaining -= delta
		time_since_last_poison_hit += delta
		if !is_frozen:
			take_poison_damage()
		if poison_duration_remaining <= 0:
			is_poisoned = false
	
	if is_burning:
		burn_duration_remaining -= delta
		time_since_last_burn_hit += delta
		if !is_frozen:
			take_burn_damage()
		if burn_duration_remaining <= 0:
			is_burning = false
			burn_hit_size = 0
			
	if is_bleeding:
		bleed_duration_remaining -= delta
		time_since_last_bleed_hit += delta
		if !is_frozen:
			take_bleed_damage()
		if bleed_duration_remaining <= 0:
			is_bleeding = false
			bleed_hit_size = 0
	
	if is_frozen:
		freeze_duration_remaining -= delta
		if freeze_duration_remaining <= 0:
			is_frozen = false
	
	time_since_last_hit += delta
	
# general function for taking damage
func take_damage(value):
	
	# the very first thing to do is make the enemy is able to take damage
	if time_since_last_hit <= immunity_time_after_hit:
		return
	if is_frozen:
		return
	# at this stage, the enemy is able to take damage, so first lets reset its immunity timer
	time_since_last_hit = 0 # this will be incremented in the physics process above
	
	# to make things simple, we won't allow taking less than 1 damage per hit
	if value <= 1:
		value = 1
	
	var damage_taken = int(min(value, hitpoints))
	hitpoints -= damage_taken
	var hit_text = damage_text.instance()
	hit_text.text = str(damage_taken)
	add_child(hit_text)
	
	if can_be_poisoned:
		apply_poison(value)
	
	if can_be_burned:
		apply_burn(value)
		
	if can_bleed:
		apply_bleed(value)
		
	if can_freeze:
		apply_freeze(value)

func apply_poison(damage):
	is_poisoned = true
	var duration = max(1, damage / 2.0)
	poison_duration_remaining += duration

func take_poison_damage():
	if time_since_last_poison_hit <= time_between_poison_hits:
		return
	time_since_last_poison_hit = 0
		
	hitpoints -= poison_damage_per_tick
	var hit_text = damage_text.instance()
	# set the poison damage text outline to green for effect
	hit_text.get_font("font").set_outline_color(Color(0, 0.4, 0, 1))
	hit_text.text = str(poison_damage_per_tick)
	add_child(hit_text)


func apply_burn(burn_hit):
	is_burning = true
	burn_hit_size = max(burn_hit_size, burn_hit)
	burn_duration_remaining = 4
	
func take_burn_damage():
	if time_since_last_burn_hit <= time_between_burn_hits:
		return
	time_since_last_burn_hit = 0
	
	var damage_taken = max(1, burn_hit_size/10.0 * (burn_duration_remaining + 1))
	hitpoints -= int(damage_taken)
	var hit_text = damage_text.instance()
	# set the burn damage text outline to red for effect
	hit_text.get_font("font").set_outline_color(Color(0.6, 0, 0, 1))
	hit_text.text = str(int(damage_taken))
	add_child(hit_text)


func apply_bleed(bleed_hit):
	is_bleeding = true
	bleed_hit_size = bleed_hit # this overwrites the previous bleed
	bleed_duration_remaining += 4 # but the duration is extended not refreshed
	
func take_bleed_damage():
	if time_since_last_bleed_hit <= time_between_bleed_hits:
		return
	time_since_last_bleed_hit = 0
	
	var damage_taken = max(1, bleed_hit_size/10.0 * (bleed_duration_remaining + 1))
	hitpoints -= int(damage_taken)
	var hit_text = damage_text.instance()
	# set the burn damage text outline to red for effect
	hit_text.get_font("font").set_outline_color(Color(1, 0, 0.2, 1))
	hit_text.text = str(int(damage_taken))
	add_child(hit_text)


func apply_freeze(freeze_hit):
	is_frozen = true
	freeze_duration_remaining = 1
	
	hitpoints -= freeze_hit
	var hit_text = damage_text.instance()
	# set the burn damage text outline to red for effect
	hit_text.get_font("font").set_outline_color(Color(0, 0, 0.8, 1))
	hit_text.text = str(freeze_hit)
	add_child(hit_text)

func _on_regen_slider_value_changed(value):
	hp_regen_per_second = value

func _on_heal_button_pressed():
	hitpoints = max_hitpoints

func _on_burn_toggle_toggled(button_pressed):
	can_be_burned = !can_be_burned

func _on_poison_toggle_toggled(button_pressed):
	can_be_poisoned = !can_be_poisoned

func _on_bleed_toggle_toggled(button_pressed):
	can_bleed = !can_bleed


func _on_clear_ailments_button_pressed():
	is_bleeding = false
	bleed_duration_remaining = 0
	bleed_hit_size = 0
	
	is_poisoned = false
	poison_duration_remaining = 0
	
	is_burning = false
	burn_duration_remaining = 0
	burn_hit_size = 0


func _on_freeze_toggle_toggled(button_pressed):
	can_freeze = !can_freeze
