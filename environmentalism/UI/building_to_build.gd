extends Panel

var building : Building 

func _ready() -> void:
	$Image.texture = building.image
	$Label.text = tr(building.building_name) + " (" + str(int(floor(building.base_construction_time*get_ctime_modifier())))+")"
	$Effects.text += tr("TRCOST")+ " - " + str(building.cost)
	write_effects()
	

func write_effects():
	for x in building.effects:
		var effect = x.split(" ")
		var category = effect[0]
		var number = float(effect[2])
		var mod = effect[1]
		var string = ""
		var category_name 
		
		if category == "environmental":
			category_name = tr("TRENV")
		if category == "social":
			category_name = tr("TRSOC")
		if category == "governance":
			category_name = tr("TRGOV")
		if category == "funds":
			category_name = tr("TRFUNDS")
			
		if mod == "+":
			if category_name == tr("TRFUNDS") or category_name ==  tr("TRSOC"):
				string = tr("TRGAIN") + " " + category_name + " " + str(int(number))
			else:
				string = category_name + " +" + str(int(number))
		if mod == "-":
			if category_name == tr("TRFUNDS") or category_name ==  tr("TRSOC"):
				string = tr("TRUPKEEP") + " " + category_name + " " + str(int(number))
			else:
				string = category_name + " -" + str(int(number))
		if mod == "+*":
			if category_name == tr("TRFUNDS") or category_name ==  tr("TRSOC"):
				string = tr("TRGAIN") + " " + category_name + " " + str(int(number*100))+"%"
			else:
				string = tr("TRPOSITIVE") + " " + category_name + " " + str(int(number*100))+"%"
		if mod == "-*":
			if category_name == tr("TRFUNDS") or category_name ==  tr("TRSOC"):
				string = tr("TRUPKEEP") + " " + category_name + " " + str(int(number*100))+"%"
			else:
				string = tr("TRNEGATIVE") + " " + category_name + " " + str(int(number*100))+"%"
			
		if category == "environmental":
			string = "[color=green]"+string+"[/color]"
		if category == "social":
			string = "[color=cyan]"+string+"[/color]"
		if category == "governance":
			string = "[color=white]"+string+"[/color]"
		if category == "funds":
			string = "[color=gold]"+string+"[/color]"
		string += " "
		$Effects.text += "\n"
		$Effects.text += string
	print($Effects.text)

func _on_button_pressed() -> void:
	if building.cost <= World.current_enterprise.funds:
		World.current_enterprise.funds -= building.cost
	else:
		return
	var b = building.duplicate(true)
	b.construction_time = floor(building.base_construction_time*get_ctime_modifier())
	World.current_enterprise.construction_queue.append(b)
	pass # Replace with function body.

func get_ctime_modifier():
	var ctime_modifier = 1.0-(int(World.current_enterprise.governance)/100)*0.05
	ctime_modifier = clamp(ctime_modifier, 0.3, INF)
	return ctime_modifier
