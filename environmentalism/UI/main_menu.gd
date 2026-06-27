extends Control



func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/game_menu.tscn")
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
	pass # Replace with function body.


func _on_russian_pressed() -> void:
	TranslationServer.set_locale("ru")
	$LanguageSelectPopup.visible = false
	pass # Replace with function body.
