extends Resource
class_name Enterprise

@export var company_name : String
@export var turn_counter : int

@export var funds : float
@export var manpower : int
@export var environmental : int
@export var social : int
@export var governance : int

@export var buildings : Array[Building]
@export var construction_queue : Array[Building]
@export var policies : Array

func next_turn():
	var counter = 0
	var to_delete : Array[int] = []
	for x in construction_queue:
		if x.construction_time == 1:
			x.construction_time = 0
			buildings.append(x)
			to_delete.append(counter)
		else:
			x.construction_time -= 1
		counter += 1
	to_delete.reverse()
	for x in to_delete:
		construction_queue.remove_at(x)
	
	turn_counter += 1
		
