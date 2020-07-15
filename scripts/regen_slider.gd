extends HSlider

func _ready():
	$"../regen_label".text = "Healing: " + str(value)


func _on_regen_slider_value_changed(value):
	$"../regen_label".text = "Healing: " + str(value)
