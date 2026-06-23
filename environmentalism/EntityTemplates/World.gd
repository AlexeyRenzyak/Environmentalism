extends Node

@export var current_enterprise : Enterprise

@export var ecosystem : int = 10000

var events_pool : Array

var buildings_pool : Array[Building] = [
	preload("res://GameObjects/Buildings/CoalPowerPlant.tres")
]

#TEST
func _ready() -> void:
	current_enterprise = load("res://GameObjects/TestEnterprise.tres")
