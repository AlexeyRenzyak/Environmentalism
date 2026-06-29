extends Resource
class_name Event

@export var event_name : String
@export_file var image_path : String
@export var image : Texture2D
@export var description : String

@export var family : String
@export var effects : Array[String]
@export var conditions : Array[String]

@export var may_apply_tier_down = true


func _init() -> void:
	ObjectSerializer.register_script("Event", Event)

func _get_excluded_properties() -> Array[String]:
	return ["image"]

func restore_image():
	var img = Image.load_from_file(image_path)
	var texture = ImageTexture.create_from_image(img)
	image = texture
