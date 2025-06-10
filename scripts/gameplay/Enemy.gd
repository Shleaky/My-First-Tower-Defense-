extends Node2D
class_name Enemy

# ---- CONFIG ----
var max_health: int = 30
var move_speed: float = 100.0
var damage_base: int = 10

# ---- STATE ----
var current_health: int = 0
var path_points: Array = []
var current_target_idx: int = 0

# ---- NODES ----
@onready var health_bar = $HealthBar

# ---- SETUP ----
func _ready():
	print("Enemy ready.")
	current_health = max_health

	# Initialize health bar
	if health_bar:
		health_bar.max_value = max_health
		health_bar.value = max_health

# ---- MAIN LOOP ----
func _process(delta):
	if path_points.is_empty():
		queue_free()
		return

	if current_target_idx >= path_points.size():
		_on_reach_goal()
		return

	var target_point = path_points[current_target_idx]
	var direction = (target_point - global_position).normalized()
	global_position += direction * move_speed * delta

	if global_position.distance_to(target_point) < 10.0:
		current_target_idx += 1

# ---- DAMAGE HANDLING ----
func take_damage(amount: int):
	current_health -= amount

	# Clamp to zero
	if current_health < 0:
		current_health = 0

	print("Enemy took %d damage → remaining health %d" % [amount, current_health])

	# Update health bar
	if health_bar:
		health_bar.value = current_health

	if current_health <= 0:
		_on_enemy_killed()

# ---- ENEMY KILLED ----
func _on_enemy_killed():
	print("Enemy destroyed.")
	
	if GameGlobalController:
		GameGlobalController.increase_score(10)
	else:
		push_error("Enemy.gd could not find GameGlobalController.")

	queue_free()

# ---- REACH BASE ----
func _on_reach_goal():
	print("Enemy reached base → dealing %d damage to base!" % damage_base)

	if GameGlobalController:
		GameGlobalController.damage_base(damage_base)
	else:
		push_error("Enemy.gd could not find GameGlobalController.")

	queue_free()
