extends Panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var is_manpower_ok = true
	if World.current_enterprise.manpower_requirement == 0:
		is_manpower_ok = true
	elif (float(World.current_enterprise.manpower)/float(World.current_enterprise.manpower_requirement)) < 0.1:
		is_manpower_ok = false
		
	if World.ecosystem <= 0:
		visible = true
		$GameOverImage.visible = true
		$GameOverImage2.visible = false
		$Description.text = tr("TRECOSYSTEMEND")
	elif World.current_enterprise.funds <= -5000:
		visible = true
		$GameOverImage.visible = false
		$GameOverImage2.visible = true
		$Description.text = tr("TRFUNDSEND")
	elif World.current_enterprise.funds <= 0 and !is_manpower_ok:
		visible = true
		$GameOverImage.visible = false
		$GameOverImage2.visible = true
		$Description.text = tr("TRFUNDSEND")
	pass


func _on_ok_pressed() -> void:
	#if World.ecosystem <= 0:
	#	World.ecosystem = 10000
	World.ecosystem = 10000
	World.current_enterprise = null
	World._save()
	get_tree().change_scene_to_file("res://UI/MainMenu.tscn")
	pass # Replace with function body.
