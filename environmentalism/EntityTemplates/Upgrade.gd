extends Resource
class_name Upgrade

@export var upgrade_name : String

@export var cost : float

@export var effects : Array[String]

@export var is_installed : bool = false

func _init() -> void:
	ObjectSerializer.register_script("Upgrade", Upgrade)
