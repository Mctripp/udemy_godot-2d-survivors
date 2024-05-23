extends CharacterBody2D

const MAX_SPEED = 150

var magnet = false


func _ready():
	$Area2D.area_entered.connect(on_area_entered)


func _process(delta):
	var player_node = get_tree().get_first_node_in_group("player") as Node2D
	if global_position.distance_to(player_node.global_position) <= 5:
		on_collide_with_player()
	if magnet:
		var direction = get_direction_to_player()
		velocity = direction * MAX_SPEED
		move_and_slide()


func on_area_entered(other_area: Area2D):
	magnet = true


func on_collide_with_player():
	GameEvents.emit_experience_vial_collected(1)
	queue_free()


func get_direction_to_player():
	var player_node = get_tree().get_first_node_in_group("player") as Node2D
	if player_node != null:
		return (player_node.global_position - global_position).normalized()
	return Vector2.ZERO
