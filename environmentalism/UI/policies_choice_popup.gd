extends Panel

var policy_to_enact = preload("res://UI/policy_to_enact.tscn") 

func reload():
	for x in $PoliciesChooser/VBoxContainer.get_children():
		x.free()
	$Funds.text = "[color=gold]" + tr("TRFUNDS") + " - " + str(World.current_enterprise.funds) + "[/color]"
	for x in World.policies_pool:
		var i = policy_to_enact.instantiate()
		i.policy = x
		$PoliciesChooser/VBoxContainer.add_child(i)
		
func _process(delta: float) -> void:
	if visible:
		$Funds.text = "[color=gold]" + tr("TRFUNDS") + " - " + str(World.current_enterprise.funds) + "[/color]"


func _on_ok_pressed() -> void:
	visible = false
	get_parent().reload()
