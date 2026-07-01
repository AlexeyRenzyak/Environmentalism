extends Control


func _ready() -> void:
	if World.current_enterprise != null:
		$LoadGame.visible = true
		$GameInfo.text = World.current_enterprise.company_name + " - " + str(World.current_enterprise.turn_counter) + " " + tr("TRTURNS")
	else:
		$LoadGame.visible = false
		$GameInfo.visible = false
	pass

func _on_new_game_pressed() -> void:
	$NewGamePopup.visible = true
	pass 


func _on_language_select_pressed() -> void:
	$LanguageSelectPopup.visible = true
	pass 


func _on_back_pressed() -> void:
	$LanguageSelectPopup.visible = false
	pass # Replace with function body.


func _on_english_pressed() -> void:
	TranslationServer.set_locale("en")
	$LanguageSelectPopup.visible = false
	World.lang = "en"
	World._save()
	pass # Replace with function body.


func _on_russian_pressed() -> void:
	TranslationServer.set_locale("ru")
	$LanguageSelectPopup.visible = false
	World.lang = "ru"
	World._save()
	pass # Replace with function body.


func _on_load_game_pressed() -> void:
	World._load()
	get_tree().change_scene_to_file("res://UI/game_menu.tscn")
	pass # Replace with function body.


func _on_start_pressed() -> void:
	var new_enterprise = World.enterprise_template.duplicate_deep(Resource.DEEP_DUPLICATE_ALL)
	new_enterprise.company_name = $NewGamePopup/CompanyNameEnter.text
	World.current_enterprise = null
	World.current_enterprise = new_enterprise
	World.ecosystem = 10000
	World._save()
	get_tree().change_scene_to_file("res://UI/game_menu.tscn")
	pass # Replace with function body.


func _on_company_name_enter_text_changed(new_text: String) -> void:
	if new_text.length() >= 1:
		$NewGamePopup/Start.visible = true
	else:
		$NewGamePopup/Start.visible = false
	pass # Replace with function body.


func _on_back_ng_pressed() -> void:
	$NewGamePopup.visible = false
	
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
