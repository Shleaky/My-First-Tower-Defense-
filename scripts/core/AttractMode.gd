extends Control
class_name AttractMode

# ---- NODES ----
@onready var press_enter_label = $VBoxContainer/PressEnterLabel
@onready var animation_player = $AnimationPlayer

# ---- SETUP ----
func _ready():
	print("AttractMode active.")
	if animation_player:
		animation_player.play("Pulse") # Optional, or remove if not defined.

# ---- INPUT HANDLING ----
func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"): # Enter key
		_start_game()

# ---- START GAME ----
func _start_game():
	var audio_manager = get_tree().get_root().get_node_or_null("AudioManager")
	if audio_manager:
		audio_manager.play_sfx("button_click")

	if GameGlobalController:
		GameGlobalController.change_state(GameGlobalController.GameState.LOADING)
	else:
		push_error("AttractMode.gd could not find GameGlobalController singleton.")
