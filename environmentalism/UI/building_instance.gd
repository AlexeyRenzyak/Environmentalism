extends Button

var building : Building

func _ready() -> void:
	icon = building.image
	text = tr(building.building_name)
	if building.construction_time != 0:
		$NotBuilt.visible = true
		$NotBuilt/Counter.text = str(building.construction_time)
		


func _on_pressed() -> void:
	get_parent().get_parent().get_parent().open_building_menu(building)
	pass # Replace with function body.
