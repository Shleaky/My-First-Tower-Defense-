extends Node2D
class_name Base

# ---- CONFIG ----
@export var max_health: int = 100

# ---- STATE ----
var current_health: int

# ---- SIGNALS ----
signal base_damaged(new_health)

# ---- SETUP ----
func _ready():
	current_health = max_health

# ---- PUBLIC API ----
func take_damage(amount: int):
	current_health = max(current_health - amount, 0)
	emit_signal("base_damaged", current_health)

	if current_health <= 0:
		_on_base_destroyed()

# ---- GAME OVER LOGIC ----
func _on_base_destroyed():
	var game_controller = get_tree().get_root().get_node("GameController")
	if game_controller:
		game_controller.change_state(GameController.GameState.GAME_OVER)
	else:
		push_error("Base.gd could not find GameController to trigger Game Over.")
