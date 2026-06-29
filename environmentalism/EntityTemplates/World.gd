extends Node

@export var current_enterprise : Enterprise

var enterprise_template = preload("res://GameObjects/TestEnterprise.tres")

@export var ecosystem : int = 10000

@export var events_pool : Array[Event]

var lang = "en"

var buildings_pool : Array[Building] = [
	preload("res://GameObjects/Buildings/CoalPowerPlant.tres")
]

var policies_pool : Array[Policy] = [
	preload("res://GameObjects/Policies/ExtendedShifts.tres"),
	preload("res://GameObjects/Policies/MandatorySorting.tres")
]

#TEST
func _ready() -> void:
	randomize()
	if !FileAccess.file_exists("user://world_state.json"):
		_save()
	else:
		_load()
	TranslationServer.set_locale(lang)
	
func _save() -> void:
	var file = FileAccess.open("user://world_state.json", FileAccess.WRITE)
	var line = JSON.stringify(ecosystem)
	file.store_line(line)
	file.store_line(lang)
	file.close()
	if current_enterprise != null:
		file = FileAccess.open("user://enterprise.json", FileAccess.WRITE)
		var enterprise = DictionarySerializer.serialize_json(current_enterprise)
		file.store_line(enterprise)
		file.close()

func _load() -> void:
	var file = FileAccess.open("user://world_state.json", FileAccess.READ)
	var line = file.get_line()
	var json = JSON.new()
	ecosystem = JSON.parse_string(line)
	lang = file.get_line()
	file.close()
	
	file = FileAccess.open("user://enterprise.json", FileAccess.READ)
	if file == null:
		return
	var enterprise : Enterprise = DictionarySerializer.deserialize_json(file.get_line())
	for x in enterprise.buildings:
		x.restore_image()
	for x in enterprise.policies:
		x.restore_image()
	for x in enterprise.construction_queue:
		x.restore_image()
	for x in enterprise.events_to_process:
		x.restore_image()
	current_enterprise = enterprise
	file.close()
