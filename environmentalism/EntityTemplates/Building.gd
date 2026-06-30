extends Resource
class_name Building

@export var building_name : String
@export_file var image_path : String
@export var image : Texture2D

@export var cost : float
@export var manpower_requirement : int
@export var base_construction_time : int
@export var construction_time : int
@export var effects : Array[String]
@export var upgrades : Array[Upgrade]


func _init() -> void:
	ObjectSerializer.register_script("Building", Building)
	
func _get_excluded_properties() -> Array[String]:
	return ["image"]

func restore_image():
	var img = Image.load_from_file(image_path)
	var texture = ImageTexture.create_from_image(img)
	image = texture
