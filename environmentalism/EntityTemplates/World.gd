extends Node

@export var current_enterprise : Enterprise

@export var ecosystem : int = 10000

@export var events_pool : Array[Event]

var buildings_pool : Array[Building] = [
	preload("res://GameObjects/Buildings/CoalPowerPlant.tres")
]

var policies_pool : Array[Policy] = [
	preload("res://GameObjects/Policies/ExtendedShifts.tres"),
	preload("res://GameObjects/Policies/MandatorySorting.tres")
]

#TEST
func _ready() -> void:
	current_enterprise = load("res://GameObjects/TestEnterprise.tres")
