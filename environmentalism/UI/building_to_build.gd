extends Panel

var building : Building 

func _ready() -> void:
	$Image.texture = building.image
	$Label.text = tr(building.building_name) + " (" + str(building.base_construction_time)+")"
	$Effects.text += "Cost - " + str(building.cost)



func _on_button_pressed() -> void:
	var b = building.duplicate(true)
	b.construction_time = building.base_construction_time
	World.current_enterprise.construction_queue.append(b)
	pass # Replace with function body.
