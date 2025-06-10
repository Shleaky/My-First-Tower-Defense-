extends CanvasLayer
class_name UIManager

# ---- NODES ----
@onready var score_label = $VBoxContainer/ScoreLabel
@onready var base_health_label = $VBoxContainer/BaseHealthLabel
@onready var next_tower_panel = $VBoxContainer/NextTowerPanel
@onready var next_tower_label = $VBoxContainer/NextTowerPanel/NextTowerLabel

# ---- SETUP ----
func _ready():
	print("UIManager ready.")

	if GameGlobalController:
		GameGlobalController.connect("score_updated", Callable(self, "_on_score_updated"))
		GameGlobalController.connect("base_health_updated", Callable(self, "_on_base_health_updated"))
		GameGlobalController.connect("new_tower_awarded", Callable(self, "_on_new_tower_awarded"))
		GameGlobalController.connect("game_state_changed", Callable(self, "_on_game_state_changed"))
	else:
		push_error("UIManager.gd could not find GameGlobalController singleton.")

	# Hide next tower panel initially
	next_tower_panel.visible = false

# ---- SIGNAL HANDLERS ----
func _on_score_updated(new_score):
	score_label.text = "Score: %d" % new_score

func _on_base_health_updated(new_health):
	base_health_label.text = "Base HP: %d" % new_health

func _on_new_tower_awarded(tower_type):
	next_tower_label.text = "Next Tower: %s" % tower_type
	next_tower_panel.visible = true

func _on_game_state_changed(new_state):
	if new_state != GameGlobalController.GameState.IN_GAME:
		next_tower_panel.visible = false
