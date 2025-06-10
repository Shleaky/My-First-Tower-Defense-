extends Node2D
class_name Tower

# ---- CONFIG ----
var projectile_scene = preload("res://scenes/gameplay/Projectile.tscn")

# ---- STATS ----
var level: int = 1
var damage: int = 10
var fire_rate: float = 1.0  # seconds between shots
var range: float = 150.0

# ---- STATE ----
var fire_timer: float = 0.0

# ---- TARGETING ----
var current_target: Node2D = null

# ---- SETUP ----
func _ready():
	print("Tower ready → level %d" % level)
	fire_timer = fire_rate

# ---- MAIN LOOP ----
func _process(delta):
	if current_target == null or not is_instance_valid(current_target):
		current_target = _find_target()

	fire_timer -= delta
	if fire_timer <= 0.0:
		if current_target:
			fire_projectile()
		fire_timer = fire_rate

# ---- TARGETING ----
func _find_target() -> Node2D:
	var enemy_container = get_tree().get_root().get_node_or_null("Game/EnemySpawner/EnemyContainer")
	if enemy_container == null:
		return null

	var closest_enemy: Node2D = null
	var closest_distance = INF

	for enemy in enemy_container.get_children():
		if not enemy is Node2D:
			continue

		var dist = global_position.distance_to(enemy.global_position)
		if dist <= range and dist < closest_distance:
			closest_distance = dist
			closest_enemy = enemy

	return closest_enemy

# ---- FIRE PROJECTILE ----
func fire_projectile():
	print("Tower firing at target → level %d → damage %d" % [level, damage])

	var projectile = projectile_scene.instantiate()
	projectile.global_position = global_position
	projectile.target = current_target
	projectile.damage = damage

	get_tree().get_root().add_child(projectile)

# ---- UPGRADE ----
func upgrade():
	level += 1
	damage += 5
	fire_rate = max(0.2, fire_rate * 0.9)  # Increase firing speed
	range += 20.0
	print("Tower upgraded → new level %d → damage %d → fire rate %.2f → range %.1f" % [level, damage, fire_rate, range])
