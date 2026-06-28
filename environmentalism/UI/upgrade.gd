extends Panel

var upgrade : Upgrade

func _ready() -> void:
	reload()

func reload() -> void:
	$Effects.text = ""
	if upgrade.is_installed:
		$Effects.text += tr("TRINSTALLED")+"\n"
		$Button.visible = false
	$Effects.text += tr("TRCOST") + " - " + str(upgrade.cost) +"\n"
	$Effects.text += tr(upgrade.upgrade_name)
	write_effects()

func write_effects():
	for x in upgrade.effects:
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
			if category_name == tr("TRFUNDS") or category_name == tr("TRSOC"):
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
	if upgrade.cost <= World.current_enterprise.funds:
		World.current_enterprise.funds -= upgrade.cost
	else:
		return
	upgrade.is_installed = true
	reload()
	pass # Replace with function body.
