extends Node

const MAX_RANGE = 100

@export var sword_ability: PackedScene

var damage = 5
var base_wait_time
var size_scaling = 1
var quantity = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	base_wait_time = $Timer.wait_time
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var enemies = get_tree().get_nodes_in_group("enemy")
	enemies = enemies.filter(func(enemy: Node2D):
		return enemy.global_position.distance_squared_to(player.global_position) < pow(MAX_RANGE, 2) && enemy.dead == false
	)
	
	if enemies.size() == 0:
		return
	
	enemies.sort_custom(func(a: Node2D, b: Node2D):
		return a.global_position.distance_squared_to(player.global_position) < b.global_position.distance_squared_to(player.global_position)
	)
	
	for i in range(min(quantity, enemies.size())):
		var sword_instance = sword_ability.instantiate() as SwordAbility
		sword_instance.scale = Vector2(size_scaling, size_scaling)
		var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
		foreground_layer.add_child(sword_instance)
		sword_instance.hitbox_component.damage = damage
		
		if(enemies[i] == null):
			continue
		
		sword_instance.global_position = enemies[i].global_position
		sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4
		
		var enemy_direction = enemies[i].global_position - sword_instance.global_position
		sword_instance.rotation = enemy_direction.angle()
		
		await get_tree().create_timer(0.12).timeout
	
func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "sword_rate":
		var percent_reduction = current_upgrades["sword_rate"]["quantity"] * 0.1
		$Timer.wait_time = base_wait_time * (1 - percent_reduction)
		$Timer.start()
		
	if upgrade.id == "sword_size":
		var scale = current_upgrades["sword_size"]["quantity"] * 0.2
		size_scaling = 1 + scale
		
	if upgrade.id == "sword_quantity":
		quantity = current_upgrades["sword_quantity"]["quantity"] + 1
		
