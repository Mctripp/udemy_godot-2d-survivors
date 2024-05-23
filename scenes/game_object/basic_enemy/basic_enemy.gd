extends CharacterBody2D

const MAX_SPEED = 40

@export var dead = false

@onready var health_component: HealthComponent = $HealthComponent

func _ready():
	(health_component as HealthComponent).died.connect(on_died)
	(health_component as HealthComponent).damaged.connect(on_damaged)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not dead:
		var direction = get_direction_to_player()
		velocity = direction * MAX_SPEED
		move_and_slide()


func get_direction_to_player():
	var player_node = get_tree().get_first_node_in_group("player") as Node2D
	if player_node != null:
		return (player_node.global_position - global_position).normalized()
	return Vector2.ZERO


func on_damaged():
	$AnimationPlayer.play("damaged")


func on_died():
	dead = true
	$HurtboxComponent.monitoring = false
	$HurtboxComponent.monitorable = false
	$AnimationPlayer.play("death")
	
