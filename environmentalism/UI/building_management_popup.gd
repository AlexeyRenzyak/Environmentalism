extends Panel

var building : Building

var upgrade = preload("res://UI/upgrade.tscn")

func reload():
	for x in $Upgrades.get_children():
		x.free()
	for x in building.upgrades:
		var i = upgrade.instantiate()
		i.upgrade = x
		$Upgrades.add_child(i)
	$BuildingName.text = building.building_name
	$EventImage.texture = building.image


func _on_ok_pressed() -> void:
	visible = false
	building = null
	get_parent().reload()
