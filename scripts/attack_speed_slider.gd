extends HSlider

func _ready():
	$"../attack_speed_label".text = "attack speed: " + str(self.value)

func _on_attack_speed_slider_value_changed(value):
	$"../attack_speed_label".text = "attack speed: " + str(self.value)
