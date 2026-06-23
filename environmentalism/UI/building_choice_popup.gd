extends Panel

var building_to_build = preload("res://UI/building_to_build.tscn")

func reload():
	for x in $BuildingChooser/VBoxContainer.get_children():
		x.free()
	$Funds.text = "[color=gold]Funds - " + str(World.current_enterprise.funds) + "[/color]"
	for x in World.buildings_pool:
		var i = building_to_build.instantiate()
		i.building = x
		$BuildingChooser/VBoxContainer.add_child(i)
		


func _on_ok_pressed() -> void:
	visible = false
	get_parent().reload()
