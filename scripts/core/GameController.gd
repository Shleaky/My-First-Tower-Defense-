extends Node
class_name GameController

# ---- GAME STATE ----
enum GameState { ATTRACT_MODE, LOADING, IN_GAME, GAME_OVER, SHOW_LEADERBOARD }

var current_state = GameState.ATTRACT_MODE

# ---- SIGNALS ----
signal score_updated(new_score)
signal base_health_updated(new_health)
signal new_tower_awarded(tower_type)
signal game_state_changed(new_state)

# ---- NODES ----
var loading_screen = preload("res://scenes/main/LoadingScreen.tscn")
var attract_mode_scene = preload("res://scenes/main/AttractMode.tscn")
var game_scene = preload("res://scenes/main/Game.tscn")
var leaderboard_scene = preload("res://scenes/main/Leaderboard.tscn")

# ---- STATE ----
var score: int = 0
var base_health: int = 100

# ---- SETUP ----
func _ready():
	print("GameController ready.")
	change_state(GameState.ATTRACT_MODE)

# ---- STATE CHANGE ----
func change_state(new_state):
	print("Changing state to %s" % str(new_state))

	# Clear current scene (except GameController itself)
	for child in get_tree().get_root().get_children():
		if child != self:
			child.queue_free()

	current_state = new_state
	emit_signal("game_state_changed", current_state)

	# ---- ATTRACT MODE ----
	if new_state == GameState.ATTRACT_MODE:
		var attract_instance = attract_mode_scene.instantiate()
		get_tree().get_root().add_child.call_deferred(attract_instance)

	# ---- LOADING SCREEN ----
	elif new_state == GameState.LOADING:
		var loading_instance = loading_screen.instantiate()
		get_tree().get_root().add_child(loading_instance)

		await get_tree().create_timer(1.0).timeout

		loading_instance.queue_free()

		var game_instance = game_scene.instantiate()
		get_tree().get_root().add_child(game_instance)

		current_state = GameState.IN_GAME
		emit_signal("game_state_changed", current_state)

	# ---- IN GAME ----
	elif new_state == GameState.IN_GAME:
		var game_instance = game_scene.instantiate()
		get_tree().get_root().add_child(game_instance)

	# ---- GAME OVER → SHOW NAME ENTRY (you can add NameEntry scene here later)
	elif new_state == GameState.GAME_OVER:
		# For now → directly show leaderboard
		change_state(GameState.SHOW_LEADERBOARD)

	# ---- SHOW LEADERBOARD ----
	elif new_state == GameState.SHOW_LEADERBOARD:
		var leaderboard_instance = leaderboard_scene.instantiate()
		get_tree().get_root().add_child(leaderboard_instance)

# ---- SCORE HANDLING ----
func increase_score(amount: int):
	score += amount
	emit_signal("score_updated", score)

# ---- BASE HEALTH HANDLING ----
func damage_base(amount: int):
	base_health -= amount
	if base_health < 0:
		base_health = 0
	emit_signal("base_health_updated", base_health)

	if base_health == 0:
		print("Base destroyed! Game over.")
		change_state(GameState.GAME_OVER)

# ---- TOWER AWARD ----
func award_new_tower(tower_type: String):
	print("Awarded new tower: %s" % tower_type)
	emit_signal("new_tower_awarded", tower_type)
