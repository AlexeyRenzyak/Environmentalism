extends Panel

var upgrade : Upgrade

func _ready() -> void:
	reload()

func reload() -> void:
	$Text.text = ""
	if upgrade.is_installed:
		$Text.text += tr("TRINSTALLED")+"\n"
		$Button.visible = false
	$Text.text += tr(upgrade.upgrade_name)

func _on_button_pressed() -> void:
	upgrade.is_installed = true
	reload()
	pass # Replace with function body.
