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
@export var policies : Array[Policy]

@export var events_to_process : Array[Event] 

func next_turn() -> void: 
	#Construction Processing
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
	
	#Event Processing
	var already_enacted_event_families = []
	var already_visited_event_families = []
	
	for x in World.events_pool:
		if x.family in already_enacted_event_families:
			continue
		if x.may_apply_tier_down:
			already_visited_event_families.append(x.family)
			if handle_event(x):
				events_to_process.append(x)
				already_enacted_event_families.append(x.family)
		else:
			if !already_visited_event_families.has(x.family) and handle_event_preliminary(x):
				already_visited_event_families.append(x.family)
				if handle_event(x):
					events_to_process.append(x)
					already_enacted_event_families.append(x.family)
				
			
	
	turn_counter += 1
		
func handle_event(event:Event) -> bool:
	for x in event.conditions:
		var cond = x.split(" ")
		if cond[0] == "RAND":
			var randfval = randf_range(0, 100)
			print(event.event_name)
			print(randfval)
			if float(cond[2]) < randfval:
				return false
	return true
	
func handle_event_preliminary(event:Event) -> bool:
	for x in event.conditions:
		var cond = x.split(" ")
		if cond[0] == "RAND":
			pass
	return true
	
func handle_event_effects() -> void:
	var event = events_to_process.pop_front()
	for x in event.effects:
		pass
