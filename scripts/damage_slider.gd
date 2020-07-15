extends HSlider
func _ready():
	$"../damage_label".text = "damage: " + str(value)

func _on_damage_slider_value_changed(value):
	$"../damage_label".text = "damage: " + str(value)
