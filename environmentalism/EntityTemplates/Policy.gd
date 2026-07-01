extends Resource
class_name Policy

@export var policy_name : String
@export_file var image_path : String
@export var image : Texture2D

@export var cost : float

@export var effects : Array[String]

func _init() -> void:
	ObjectSerializer.register_script("Policy", Policy)

func _get_excluded_properties() -> Array[String]:
	return ["image"]

func restore_image():
	image = World.images[policy_name]
