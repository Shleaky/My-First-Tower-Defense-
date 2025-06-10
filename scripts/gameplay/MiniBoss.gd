extends "res://scripts/gameplay/Enemy.gd"
class_name MiniBoss

# ---- UNIQUE PROPERTIES ----
var aura_radius: float = 200.0
var aura_speed_bonus: float = 1.5
var aura_check_interval: float = 1.0

# ---- STATE ----
var aura_timer: float = 0.0
var enemy_container: Node = null

# ---- OVERRIDES ----
func _ready():
	._ready() # Call parent _ready()
	
	# Adjust stats
	max_health = 200.0
	current_health = max_health
	speed = 40.0
	reward_score = 300

	# Get reference to enemy container
	enemy_container = get_tree().get_root().get_node("GameController/EnemySpawner/EnemyContainer")

	print("MiniBoss spawned with HP: %d" % max_health)

# ---- MAIN LOOP ----
func _process(delta):
	._process(delta) # Retain movement logic

	aura_timer -= delta
	if aura_timer <= 0.0:
		_apply_aura_to_nearby_enemies()
		aura_timer = aura_check_interval

# ---- AURA LOGIC ----
func _apply_aura_to_nearby_enemies():
	if not enemy_container:
		return

	for enemy in enemy_container.get_children():
		if enemy == self or not is_instance_valid(enemy):
			continue

		var dist = global_position.distance_to(enemy.global_position)
		if dist <= aura_radius:
			if enemy.has_method("apply_speed_multiplier"):
				enemy.apply_speed_multiplier(aura_speed_bonus)

# ---- DEATH OVERRIDE ----
func _on_die():
	print("MiniBoss defeated!")
	_clear_aura_from_all()
	._on_die() # Call parent method for score + cleanup

# ---- AURA CLEANUP ----
func _clear_aura_from_all():
	if not enemy_container:
		return

	for enemy in enemy_container.get_children():
		if is_instance_valid(enemy) and enemy.has_method("remove_speed_multiplier"):
			enemy.remove_speed_multiplier()
