extends Node

const MAX_RANGE = 100

@export var axe_ability: PackedScene

var damage = 10
var base_wait_time
var size_scaling = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	base_wait_time = $Timer.wait_time
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
		
	var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
	if foreground_layer == null:
		return
	
	var axe_instance = axe_ability.instantiate() as AxeAbility
	axe_instance.scale = Vector2(size_scaling, size_scaling)
	foreground_layer.add_child(axe_instance)
	axe_instance.global_position = player.global_position
	axe_instance.hitbox_component.damage = damage
	
func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):	
	if upgrade.id == "axe_rate":
		var percent_reduction = current_upgrades["axe_rate"]["quantity"] * 0.1
		$Timer.wait_time = base_wait_time * (1 - percent_reduction)
		$Timer.start()
		
	if upgrade.id == "axe_size":
		var scale = current_upgrades["axe_size"]["quantity"] * 0.2
		size_scaling = 1 + scale
		
