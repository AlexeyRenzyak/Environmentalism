extends Panel


# Called when the node enters the scene tree for the first time.
func reload():
	$CurrentManpower.text = str(World.current_enterprise.manpower)+"/"+str(World.current_enterprise.manpower_requirement)
	var price = 5 * (1.0+(int(((10000-World.current_enterprise.social)/1000))*0.2))
	$Price.text = "[color=blue]" + "1 " + tr("TRMANPOWER") + "[/color]" + " = " + "[color=gold]" + str(price) + " " + tr("TRFUNDS") + "[/color]"


#var envmod = 1.0-(int((10000-World.ecosystem)/2000)*0.2)

func _on_bp_1_pressed() -> void:
	var price = 5 * (1.0+(int(((10000-World.current_enterprise.social)/1000))*0.2))
	if World.current_enterprise.funds >= price:
		World.current_enterprise.funds -= price
		World.current_enterprise.manpower += 1
	World.current_enterprise.manpower = clamp(World.current_enterprise.manpower, 0, INF)
	reload()


func _on_bp_10_pressed() -> void:
	var price = 10 * 5 * (1.0+(int(((10000-World.current_enterprise.social)/1000))*0.2))
	if World.current_enterprise.funds >= price:
		World.current_enterprise.funds -= price
		World.current_enterprise.manpower += 10
	World.current_enterprise.manpower = clamp(World.current_enterprise.manpower, 0, INF)
	reload()


func _on_bp_100_pressed() -> void:
	var price = 100 * 5 * (1.0+(int(((10000-World.current_enterprise.social)/1000))*0.2))
	if World.current_enterprise.funds >= price:
		World.current_enterprise.funds -= price
		World.current_enterprise.manpower += 100
	World.current_enterprise.manpower = clamp(World.current_enterprise.manpower, 0, INF)
	reload()


func _on_bp_1000_pressed() -> void:
	var price = 1000 * 5 * (1.0+(int(((10000-World.current_enterprise.social)/1000))*0.2))
	if World.current_enterprise.funds >= price:
		World.current_enterprise.funds -= price
		World.current_enterprise.manpower += 1000
	World.current_enterprise.manpower = clamp(World.current_enterprise.manpower, 0, INF)
	reload()


func _on_bm_1_pressed() -> void:
	World.current_enterprise.manpower -= 1
	World.current_enterprise.manpower = clamp(World.current_enterprise.manpower, 0, INF)
	reload()


func _on_bm_10_pressed() -> void:
	World.current_enterprise.manpower -= 10
	World.current_enterprise.manpower = clamp(World.current_enterprise.manpower, 0, INF)
	reload()


func _on_bm_100_pressed() -> void:
	World.current_enterprise.manpower -= 100
	World.current_enterprise.manpower = clamp(World.current_enterprise.manpower, 0, INF)
	reload()


func _on_bm_1000_pressed() -> void:
	World.current_enterprise.manpower -= 1000
	World.current_enterprise.manpower = clamp(World.current_enterprise.manpower, 0, INF)
	reload()


func _on_ok_pressed() -> void:
	visible = false
	get_parent().reload()
