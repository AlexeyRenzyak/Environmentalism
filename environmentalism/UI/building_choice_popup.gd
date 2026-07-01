extends Panel

var building_to_build = preload("res://UI/building_to_build.tscn")

func reload():
	for x in $BuildingChooser/VBoxContainer.get_children():
		x.free()
	$Funds.text = "[color=gold]" + tr("TRFUNDS") + " - " + str(snapped(World.current_enterprise.funds, 0.1)) + "[/color]"
	for x in World.buildings_pool:
		var i = building_to_build.instantiate()
		i.building = x
		$BuildingChooser/VBoxContainer.add_child(i)
		
func _process(delta: float) -> void:
	if visible:
		$Funds.text = "[color=gold]" + tr("TRFUNDS") + " - " + str(snapped(World.current_enterprise.funds, 0.1)) + "[/color]"

func _on_ok_pressed() -> void:
	visible = false
	get_parent().reload()
