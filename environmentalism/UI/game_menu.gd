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
		$EventPopup/Description.text += "\n"
		for x in World.current_enterprise.events_to_process[0].effects:
			var effect = x.split(" ")
			if effect[0] == "funds":
				$EventPopup/Description.text += "[color=gold]" + tr("TRFUNDS") + " " + effect[1] + str(effect[2]) + "[/color] \n"
			if effect[0] == "social":
				$EventPopup/Description.text += "[color=cyan]" + tr("TRSOC") + " " + effect[1] + str(effect[2]) + "[/color] \n"
			if effect[0] == "manpower":
				$EventPopup/Description.text += "[color=blue]" + tr("TRMANPOWER") + " " + effect[1] + str(effect[2]) + "[/color] \n"
			
	else:
		$EventPopup.visible = false
	
	$Indicators.text = ""
	var changes = calculate_next_turn()
	var manpower_requirement = 0
	$Indicators.text += "[color=gold]" + tr("TRFUNDS") + " - " + str(snapped(World.current_enterprise.funds, 0.1)) + " ("+ str(snapped(changes[0]["funds"], 0.1)) + ")" + "[/color]"
	$Indicators.text += "[color=blue] \n" + tr("TRMPOWER") + " - " + str(World.current_enterprise.manpower)+"/"+str(World.current_enterprise.manpower_requirement) + " ("+ str(changes[0]["manpower_requirements"]) + ")" +  "[/color]"
	$Indicators.text += "[color=green] \n" + tr("TRENV") + " - " + str(World.current_enterprise.environmental) + " ("+tr("TRWILLBE") +" "+ str(changes[1]["environmental"]) + ")" + "[/color]"
	$Indicators.text += "[color=cyan] \n" + tr("TRSOC") + " - " + str(World.current_enterprise.social) + " ("+ str(changes[0]["social"]) + ")" + "[/color]"
	$Indicators.text += "[color=white] \n" + tr("TRGOV") + " - " + str(World.current_enterprise.governance) + " ("+tr("TRWILLBE") +" "+ str(changes[1]["governance"]) + ")" + "[/color]"
	var envmod = 1.0-(int((10000-World.ecosystem)/2000)*0.2)
	if World.ecosystem <= 8000:
		$Indicators.text += "[color=lightgreen] \n" + tr("TRECO") + " - " + str(World.ecosystem) + "[/color]" + " [color=red](" + tr("TRFUNDS") + " " + "-" +str((1.0-envmod)*100)+"%!" + ")"
	else:
		$Indicators.text += "[color=lightgreen] \n" + tr("TRECO") + " - " + str(World.ecosystem) + "[/color]"
		
func open_building_menu(building:Building):
	$BuildingManagementPopup.building = building
	$BuildingManagementPopup.reload()
	$BuildingManagementPopup.visible = true

func calculate_next_turn():
	var effects = {"environmental":{}, "governance":{}, "social":{}, "funds":{}, "manpower":{}}
	for x in World.current_enterprise.buildings:
		print(x)
		for y in x.effects:
			var effect = y.split(" ")
			if !effects[effect[0]].has(effect[1]):
				effects[effect[0]][effect[1]] = float(effect[2])
			else:
				effects[effect[0]][effect[1]] += float(effect[2])
		for y in x.upgrades:
			if !y.is_installed:
				continue
			for z in y.effects:
				var effect = z.split(" ")
				if !effects[effect[0]].has(effect[1]):
					effects[effect[0]][effect[1]] = float(effect[2])
				else:
					effects[effect[0]][effect[1]] += float(effect[2])
	for x in World.current_enterprise.policies:
		for y in x.effects:
			var effect = y.split(" ")
			if !effects[effect[0]].has(effect[1]):
				effects[effect[0]][effect[1]] = float(effect[2])
			else:
				effects[effect[0]][effect[1]] += float(effect[2])
	print(effects)
	var order = ["+", "-", "+*", "-*"]
	
	var manpower_requirements = 0
	for x in World.current_enterprise.buildings:
		manpower_requirements += x.manpower_requirement
	
	var future_mp_coefficient = float(World.current_enterprise.manpower)/float(manpower_requirements)
	
	if is_nan(future_mp_coefficient) or future_mp_coefficient == -INF or future_mp_coefficient == INF:
		future_mp_coefficient = 0
	future_mp_coefficient = clamp(future_mp_coefficient, 0, 1)
	
	for x in effects.keys():
		if effects[x].has("+*"):
			effects[x]["+*"] = clamp(effects[x]["+*"], -1, INF)
			if effects[x].has("+"):
				effects[x]["+"] *= 1 + effects[x]["+*"]
		if effects[x].has("-*"):
			effects[x]["-*"] = clamp(effects[x]["-*"], -1, INF)
			if effects[x].has("-"):
				if x == "funds" or x == "environmental" or x == "social":
					effects[x]["-"] *= 1 + effects[x]["-*"]
				else:
					effects[x]["-"] *= 1 + effects[x]["-*"]
	
	
	var additions = {"social":0.0, "funds":0.0}
	var values = {"environmental":0, "governance":0}
	
	additions["social"] = floor(future_mp_coefficient*get_result_or_zero(effects, "social", "+") - future_mp_coefficient*get_result_or_zero(effects, "social", "-"))
	
	var envmod = 1.0-(int((10000-World.ecosystem)/2000)*0.2)
	additions["funds"] = (floor(future_mp_coefficient*get_result_or_zero(effects, "funds", "+")*envmod) - future_mp_coefficient*get_result_or_zero(effects, "funds", "-")) - World.current_enterprise.manpower

	values["environmental"] = floor(future_mp_coefficient*get_result_or_zero(effects, "environmental", "+") - future_mp_coefficient*get_result_or_zero(effects, "environmental", "-"))
	values["governance"] = floor(get_result_or_zero(effects, "governance", "+") - get_result_or_zero(effects, "governance", "-"))
	
	values["governance"] -= World.current_enterprise.manpower
	additions["manpower_requirements"] = manpower_requirements
	return [additions, values]

func _on_build_pressed() -> void:
	$BuildingChoicePopup.reload()
	$BuildingChoicePopup.visible = true
	pass # Replace with function body.

func get_result_or_zero(effects:Dictionary, modifier:String, category:String):
	if effects[modifier].has(category):
		return effects[modifier][category]
	else:
		return 0.0

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


func _on_save_quit_pressed() -> void:
	World._save()
	get_tree().change_scene_to_file("res://UI/MainMenu.tscn")
	pass # Replace with function body.


func _on_manpower_pressed() -> void:
	$ManpowerPopup.reload()
	$ManpowerPopup.visible = true
	pass # Replace with function body.
