extends Control

var building_instance = preload("res://UI/building_instance.tscn")

func _ready() -> void:
	reload()
	
func reload():
	$CompanyName.text = World.current_enterprise.company_name + " (" + str(World.current_enterprise.turn_counter)+")"
	for x in $BuildingList/HFlowContainer.get_children():
		x.free()
	for x in World.current_enterprise.buildings:
		var i = building_instance.instantiate()
		i.building = x
		$BuildingList/HFlowContainer.add_child(i)
	for x in World.current_enterprise.construction_queue:
		var i = building_instance.instantiate()
		i.building = x
		$BuildingList/HFlowContainer.add_child(i)
	
	if World.current_enterprise.events_to_process.size() > 0:
		$EventPopup.visible = true
		$EventPopup/EventName.text = tr(World.current_enterprise.events_to_process[0].event_name)
		$EventPopup/EventImage.texture = World.current_enterprise.events_to_process[0].image
		$EventPopup/Description.text = tr(World.current_enterprise.events_to_process[0].description)
	else:
		$EventPopup.visible = false
	
	$Indicators.text = ""
	
	$Indicators.text += "[color=gold]" + tr("TRFUNDS") + " - " + str(World.current_enterprise.funds) + "[/color]"
	$Indicators.text += "[color=blue] \n" + tr("TRMPOWER") + " - " + str(World.current_enterprise.manpower)+"/"+"NEEDED"+ "[/color]"
	$Indicators.text += "[color=green] \n" + tr("TRENV") + " - " + str(World.current_enterprise.environmental) + "[/color]"
	$Indicators.text += "[color=cyan] \n" + tr("TRSOC") + " - " + str(World.current_enterprise.social) + "[/color]"
	$Indicators.text += "[color=white] \n" + tr("TRGOV") + " - " + str(World.current_enterprise.governance) + "[/color]"
	$Indicators.text += "[color=lightgreen] \n" + tr("TRECO") + " - " + str(World.ecosystem) + "[/color]"
		
func open_building_menu(building:Building):
	$BuildingManagementPopup.building = building
	$BuildingManagementPopup.reload()
	$BuildingManagementPopup.visible = true


func _on_build_pressed() -> void:
	$BuildingChoicePopup.reload()
	$BuildingChoicePopup.visible = true
	pass # Replace with function body.


func _on_turn_pressed() -> void:
	World.current_enterprise.next_turn()
	reload()
	pass # Replace with function body.


func _on_policies_pressed() -> void:
	$PoliciesChoicePopup.reload()
	$PoliciesChoicePopup.visible = true
	pass # Replace with function body.


func _on_ok_pressed() -> void:
	World.current_enterprise.handle_event_effects()
	reload()
	pass # Replace with function body.
