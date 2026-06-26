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
	$Effects.text += "Cost - " + str(policy.cost)



func _on_button_pressed() -> void:
	if !enacted:
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
