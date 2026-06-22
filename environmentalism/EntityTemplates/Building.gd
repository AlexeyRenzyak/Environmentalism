extends Resource
class_name Building

@export var building_name : String
@export var image : Image

@export var cost : float
@export var base_construction_time : int
@export var construction_time : int
@export var effects : Array[String]
@export var upgrades : Array[Upgrade]
