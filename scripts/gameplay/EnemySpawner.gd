extends Node
class_name EnemySpawner

# ---- CONFIG ----
var enemy_scene = preload("res://scenes/gameplay/Enemy.tscn")
var miniboss_scene = preload("res://scenes/gameplay/MiniBoss.tscn")

# ---- SPAWN TIMING ----
var spawn_interval: float = 20.0      # Time between waves
var enemy_spawn_delay: float = 1   # Time between enemies within wave
var miniboss_interval: int = 5       # Spawn miniboss every N waves

# ---- STATE ----
var wave_count: int = 0
var spawning_wave: bool = false

# ---- NODES ----
@onready var spawn_point = $SpawnPoint
@onready var enemy_container = $EnemyContainer
@onready var path_node = $Path

# ---- SETUP ----
func _ready():
	print("EnemySpawner ready.")

	# Start first wave after short delay
	_start_next_wave()

# ---- MAIN LOOP ----
func _process(delta):
	pass  # No longer using spawn_timer

# ---- START NEXT WAVE ----
func _start_next_wave():
	if not spawning_wave:
		spawning_wave = true
		wave_count += 1
		print("Starting Wave %d" % wave_count)

		await _spawn_enemies(5)  # Example: 5 enemies per wave

		# If miniboss wave → spawn miniboss after enemies
		if wave_count % miniboss_interval == 0:
			await _spawn_miniboss_delayed(0.5)  # 0.5 second delay after enemies

		# Wait before starting next wave
		await get_tree().create_timer(spawn_interval).timeout
		spawning_wave = false
		_start_next_wave()

# ---- SPAWN ENEMIES ----
func _spawn_enemies(count: int):
	for i in range(count):
		spawn_enemy()
		await get_tree().create_timer(enemy_spawn_delay).timeout

# ---- SPAWN MINIBOSS WITH DELAY ----
func _spawn_miniboss_delayed(delay_time: float):
	await get_tree().create_timer(delay_time).timeout
	spawn_miniboss()


# ---- SPAWN ENEMY ----
func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	enemy.global_position = spawn_point.global_position
	enemy.path_points = _get_path_points()
	enemy_container.add_child(enemy)

# ---- SPAWN MINIBOSS ----
func spawn_miniboss():
	print("Spawning MiniBoss!")
	var miniboss = miniboss_scene.instantiate()
	miniboss.global_position = spawn_point.global_position
	miniboss.path_points = _get_path_points()
	enemy_container.add_child(miniboss)

# ---- PATH HELPER ----
func _get_path_points() -> Array:
	var points = []
	for child in path_node.get_children():
		if child is Node2D:
			points.append(child.global_position)
	return points
