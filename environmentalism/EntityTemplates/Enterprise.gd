extends Resource
class_name Enterprise

@export var company_name : String
@export var turn_counter : int

@export var funds : float
@export var manpower : int
@export var manpower_requirement : int = 0
@export var environmental : int
@export var social : int
@export var governance : int

@export var buildings : Array[Building]
@export var construction_queue : Array[Building]
@export var policies : Array[Policy]

@export var events_to_process : Array[Event] 

func _init() -> void:
	ObjectSerializer.register_script("Enterprise", Enterprise)

func next_turn() -> void: 
	#Effect Processing
	var effects = {"environmental":{}, "governance":{}, "social":{}, "funds":{}, "manpower":{}}
	manpower_requirement = 0
	for x in buildings:
		manpower_requirement += x.manpower_requirement
		for y in x.effects:
			var effect = y.split(" ")
			if !effects[effect[0]].has(effect[1]):
				effects[effect[0]][effect[1]] = float(effect[2])
			else:
				effects[effect[0]][effect[1]] += float(effect[2])
		for y in x.upgrades:
			if !y.is_installed:
				continue
			for z in y.effects:
				var effect = z.split(" ")
				if !effects[effect[0]].has(effect[1]):
					effects[effect[0]][effect[1]] = float(effect[2])
				else:
					effects[effect[0]][effect[1]] += float(effect[2])
	for x in policies:
		for y in x.effects:
			var effect = y.split(" ")
			if !effects[effect[0]].has(effect[1]):
				effects[effect[0]][effect[1]] = float(effect[2])
			else:
				effects[effect[0]][effect[1]] += float(effect[2])
	
	var order = ["+", "-", "+*", "-*"]
	
			
	var future_mp_coefficient = float(World.current_enterprise.manpower)/float(World.current_enterprise.manpower_requirement)
	
	if is_nan(future_mp_coefficient) or future_mp_coefficient == -INF or future_mp_coefficient == INF:
		future_mp_coefficient = 0
	future_mp_coefficient = clamp(future_mp_coefficient, 0, 1)
	
	for x in effects.keys():
		if effects[x].has("+*"):
			effects[x]["+*"] = clamp(effects[x]["+*"], -1, INF)
			if effects[x].has("+"):
				effects[x]["+"] *= 1 + effects[x]["+*"]
		if effects[x].has("-*"):
			effects[x]["-*"] = clamp(effects[x]["-*"], -1, INF)
			if effects[x].has("-"):
				if x == "funds" or x == "environmental" or x == "social":
					effects[x]["-"] *= 1 + effects[x]["-*"]
				else:
					effects[x]["-"] *= 1 + effects[x]["-*"]
	
	
	
	var additions = {"social":0.0, "funds":0.0}
	var values = {"environmental":0, "governance":0}
	additions["social"] = floor(future_mp_coefficient*get_result_or_zero(effects, "social", "+") - future_mp_coefficient*get_result_or_zero(effects, "social", "-"))
	
	var envmod = 1.0-(int((10000-World.ecosystem)/2000)*0.2)
	additions["funds"] = (floor(future_mp_coefficient*get_result_or_zero(effects, "funds", "+")*envmod) - future_mp_coefficient*get_result_or_zero(effects, "funds", "-")) - World.current_enterprise.manpower

	values["environmental"] = floor(future_mp_coefficient*get_result_or_zero(effects, "environmental", "+") - future_mp_coefficient*get_result_or_zero(effects, "environmental", "-"))
	values["governance"] = floor(get_result_or_zero(effects, "governance", "+") - get_result_or_zero(effects, "governance", "-"))
	
	social = clamp(social + additions["social"], 0, 10000)
	funds += additions["funds"]
	
	environmental = values["environmental"]
	governance = values["governance"]
	
	governance -= manpower
	
	World.ecosystem += 10
	if environmental <= 0:
		World.ecosystem += environmental
	elif environmental > 0:
		World.ecosystem += floor(environmental*0.5)
	World.ecosystem = clamp(World.ecosystem, 0, 10000)
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
	World._save()

func get_result_or_zero(effects:Dictionary, modifier:String, category:String):
	if effects[modifier].has(category):
		return effects[modifier][category]
	else:
		return 0.0

func handle_event(event:Event) -> bool:
	for x in event.conditions:
		var cond = x.split(" ")
		
		if cond[0] == "RAND":
			var randfval = randf_range(0, 100)
			print(event.event_name)
			print(randfval)
			if float(cond[2]) < randfval:
				return false
				

		if cond[0] == "ecosystem":
			if cond[1] == "<":
				if float(cond[2]) < World.ecosystem:
					return false
			elif cond[1] == ">":
				if float(cond[2]) > World.ecosystem:
					return false

		if cond[0] == "environmental":
			if cond[1] == "<":
				if float(cond[2]) < environmental:
					return false
			elif cond[1] == ">":
				if float(cond[2]) > environmental:
					return false

		if cond[0] == "social":
			if cond[1] == "<":
				if float(cond[2]) < social:
					return false
			elif cond[1] == ">":
				if float(cond[2]) > social:
					return false

		if cond[0] == "governance":
			if cond[1] == "<":
				if float(cond[2]) < governance:
					return false
			elif cond[1] == ">":
				if float(cond[2]) > governance:
					return false
					
		if cond[0] == "funds":
			if cond[1] == "<":
				if float(cond[2]) < funds:
					return false
			elif cond[1] == ">":
				if float(cond[2]) > funds:
					return false
					
		if cond[0] == "manpower":
			if cond[1] == "<":
				if float(cond[2]) < manpower:
					return false
			elif cond[1] == ">":
				if float(cond[2]) > manpower:
					return false
	return true
	
func handle_event_preliminary(event:Event) -> bool:
	for x in event.conditions:
		var cond = x.split(" ")
		
		if cond[0] == "RAND":
			pass

		if cond[0] == "ecosystem":
			if cond[1] == "<":
				if float(cond[2]) < World.ecosystem:
					return false
			elif cond[1] == ">":
				if float(cond[2]) > World.ecosystem:
					return false

		if cond[0] == "environmental":
			if cond[1] == "<":
				if float(cond[2]) < environmental:
					return false
			elif cond[1] == ">":
				if float(cond[2]) > environmental:
					return false

		if cond[0] == "social":
			if cond[1] == "<":
				if float(cond[2]) < social:
					return false
			elif cond[1] == ">":
				if float(cond[2]) > social:
					return false

		if cond[0] == "governance":
			if cond[1] == "<":
				if float(cond[2]) < governance:
					return false
			elif cond[1] == ">":
				if float(cond[2]) > governance:
					return false
					
		if cond[0] == "funds":
			if cond[1] == "<":
				if float(cond[2]) < funds:
					return false
			elif cond[1] == ">":
				if float(cond[2]) > funds:
					return false
					
		if cond[0] == "manpower":
			if cond[1] == "<":
				if float(cond[2]) < manpower:
					return false
			elif cond[1] == ">":
				if float(cond[2]) > manpower:
					return false
					
	return true
	
func handle_event_effects() -> void:
	var event = events_to_process.pop_front()
	for x in event.effects:
		var effect = x.split(" ")
		var action
		if effect[1] == "+":
			action = "+"
		else:
			action = "-"
			
		if action == "+":
			set(effect[0], get(effect[0])+float(effect[2]))
		elif action == "-":
			set(effect[0], get(effect[0])-float(effect[2]))
		
	clamp(social, 0, 10000)
	clamp(manpower, 0, INF)
