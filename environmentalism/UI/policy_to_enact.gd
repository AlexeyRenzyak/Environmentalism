extends Panel

var policy : Policy

var enacted : bool = false

func _ready() -> void:
	$Effects.text = ""
	var is_enacted = false
	for x in World.current_enterprise.policies:
		if x.policy_name == policy.policy_name:
			enacted = true
			is_enacted = true
			modulate = Color(1.4,1.4,1.4)
			$Button.text = tr("TRACTIONUNENACT")
			break
	if !is_enacted:
		enacted = false
		modulate = Color(1,1,1)
		$Button.text = tr("TRACTIONENACT")
	$Image.texture = policy.image
	$Label.text = tr(policy.policy_name)
	$Effects.text += tr("TRCOST")+ " - " + str(int(floor(policy.cost*get_cost_modifier())))
	write_effects()
	
func write_effects():
	for x in policy.effects:
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
	if !enacted:
		if floor(policy.cost*get_cost_modifier()) <= World.current_enterprise.funds:
			World.current_enterprise.funds -= policy.cost
		else:
			return
		var b = policy.duplicate(true)
		World.current_enterprise.policies.append(b)
		_ready()
	else:
		var counter = 0
		for x in World.current_enterprise.policies:
			if x.policy_name == policy.policy_name:
				World.current_enterprise.policies.remove_at(counter)
				_ready()
				break
			counter += 1
	pass # Replace with function body.

func get_cost_modifier():
	var cost_modifier = 1.0-(int(World.current_enterprise.governance)/100)*0.1
	cost_modifier = clamp(cost_modifier, 0.7, INF)
	return cost_modifier
