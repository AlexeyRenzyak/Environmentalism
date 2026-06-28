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
	$Funds.text = "[color=gold]" + tr("TRFUNDS") + " - " + str(World.current_enterprise.funds) + "[/color]"
	$BuildingName.text = building.building_name
	$EventImage.texture = building.image
	$Effects.text = ""
	write_effects()
	
func _process(delta: float) -> void:
	if visible:
		$Funds.text = "[color=gold]" + tr("TRFUNDS") + " - " + str(World.current_enterprise.funds) + "[/color]"


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


func _on_ok_pressed() -> void:
	visible = false
	building = null
	get_parent().reload()
