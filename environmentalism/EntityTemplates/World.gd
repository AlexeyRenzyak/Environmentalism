extends Node

@export var current_enterprise : Enterprise

var enterprise_template = preload("res://GameObjects/TestEnterprise.tres")

@export var ecosystem : int = 10000

@export var events_pool : Array[Event]

var lang = "en"

var buildings_pool : Array[Building] = [
	preload("res://GameObjects/Buildings/CoalPowerPlant.tres"),
	preload("res://GameObjects/Buildings/ExcavationSite.tres"),
	preload("res://GameObjects/Buildings/ModernFactory.tres"),
	preload("res://GameObjects/Buildings/Office.tres"),
	preload("res://GameObjects/Buildings/RecyclingCenter.tres"),
	preload("res://GameObjects/Buildings/SolarPowerPlant.tres"),
	preload("res://GameObjects/Buildings/Sweatshop.tres"),
	preload("res://GameObjects/Buildings/WelfareCenter.tres"),
]

var policies_pool : Array[Policy] = [
	preload("res://GameObjects/Policies/ExtendedShifts.tres"),
	preload("res://GameObjects/Policies/MandatorySorting.tres"),
	preload("res://GameObjects/Policies/AdministrativeOutsourcing.tres"),
	preload("res://GameObjects/Policies/EmployeeBenefits.tres"),
	preload("res://GameObjects/Policies/Lobbying.tres"),
	preload("res://GameObjects/Policies/UnrestrictedProcurement.tres"),
]

var images = {
	"TRCOALPOWERPLANT":preload("res://Images/Buildings/catazul-power-plant-6807566.jpg"),
	"TREXCAVATIONSITE":preload("res://Images/Buildings/dominik-vanyi-Mk2ls9UBO2E-unsplash.jpg"),
	"TRMODERNFACTORY":preload("res://Images/Buildings/homa-appliances-pWUyHVJgLhg-unsplash.jpg"),
	"TROFFICE":preload("res://Images/Buildings/harry-shelton-pPxhM0CRzl4-unsplash.jpg"),
	"TRRECYCLINGCENTER":preload("res://Images/Buildings/pexels-willians-huerta-2157111846-36397860.jpg"),
	"TRSOLARPOWERPLANT":preload("res://Images/Buildings/american-public-power-association-513dBrMJ_5w-unsplash.jpg"),
	"TRSWEATSHOP":preload("res://Images/Buildings/pexels-equalstock-31019572.jpg"),
	"TRWELFARECENTER":preload("res://Images/Buildings/maciej-drazkiewicz-FjagHmZAq38-unsplash.jpg"),
	
	"TRADMINISTRATIVEOUTSOURCING":preload("res://Images/Policies/pexels-talal-34369598.jpg"),
	"TREMPLOYEEBENEFITS":preload("res://Images/Policies/stevepb-calculator-385506.jpg"),
	"TREXTENDEDSHIFTS":preload("res://Images/Policies/nicolas-arnold-OsB2hKfYqas-unsplash.jpg"),
	"TRLOBBYING":preload("res://Images/Policies/pexels-bia-limova-1908542654-33175650.jpg"),
	"TRMANDATORYSORTING":preload("res://Images/Policies/pawel-czerwinski-RkIsyD_AVvc-unsplash.jpg"),
	"TRUNRESTRICTEDPROCUREMENT":preload("res://Images/Policies/alberto-rodriguez--aCrA9FmT8Y-unsplash.jpg"),
	
	"TRQUITTING3":preload("res://Images/Events/pexels-pixabay-48148.jpg"),
	"TRQUITTING2":preload("res://Images/Events/pexels-pixabay-48148.jpg"),
	"TRQUITTING1":preload("res://Images/Events/pexels-pixabay-48148.jpg"),
	"TRSTRIKES3":preload("res://Images/Events/claudio-schwarz-gWTRInY5AAc-unsplash.jpg"),
	"TRSTRIKES2":preload("res://Images/Events/claudio-schwarz-gWTRInY5AAc-unsplash.jpg"),
	"TRSTRIKES1":preload("res://Images/Events/pexels-olly-3771097.jpg"),
	"TRFINE":preload("res://Images/Events/tingey-injury-law-firm-veNb0DDegzE-unsplash.jpg"),
	"TRSUBSIDY":preload("res://Images/Events/pexels-pixabay-210574.jpg"),
	"TRCORRUPTION":preload("res://Images/Events/tingey-injury-law-firm-veNb0DDegzE-unsplash.jpg")
}

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
	else:
		if FileAccess.file_exists("user://enterprise.json"):
			DirAccess.remove_absolute("user://enterprise.json")
		

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
