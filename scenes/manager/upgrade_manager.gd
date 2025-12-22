extends Node

@export var upgrade_pool: Array[AbilityUpgrade]
@export var experience_manager: Node
@export var upgrade_screen_scene: PackedScene

var current_upgrades = {}
var choices = 2 # Number of upgrades the player can select from during level up


func _ready():
	experience_manager.level_up.connect(on_level_up)


func on_level_up(current_level: int):
	var available_upgrades := upgrade_pool.filter(func(upgrade: AbilityUpgrade) -> bool:
		return upgrade.level < upgrade.max_level
	)

	var chosen_upgrades = [] as Array[AbilityUpgrade]
	for i in choices:
		if available_upgrades.size() == 0:
			break
		var chosen_upgrade = available_upgrades.pick_random() as AbilityUpgrade
		if chosen_upgrade == null:
			break
		chosen_upgrades.append(chosen_upgrade)
		available_upgrades = available_upgrades.filter(func (upgrade): return upgrade.id != chosen_upgrade.id)
	var upgrade_screen_instance = upgrade_screen_scene.instantiate()
	add_child(upgrade_screen_instance)
	upgrade_screen_instance.set_ability_upgrades(chosen_upgrades)
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)


func apply_upgrade(upgrade: AbilityUpgrade):
		
	var has_upgrade = current_upgrades.has(upgrade.id)
	if !has_upgrade:
		upgrade.level = 1
		current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1
		}
	else:
		upgrade.level += 1
		current_upgrades[upgrade.id]["quantity"] += 1
		print(current_upgrades)
		
	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)


func on_upgrade_selected(upgrade: AbilityUpgrade):
	apply_upgrade(upgrade)
