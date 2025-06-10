extends Control
class_name PauseMenu

# ---- STATE ----
var is_paused: bool = false

# ---- NODES ----
@onready var resume_button = $VBoxContainer/ResumeButton
@onready var restart_button = $VBoxContainer/RestartButton
@onready var quit_button = $VBoxContainer/QuitButton

# ---- SETUP ----
func _ready():
	_set_visible(false)

	# Connect button signals
	resume_button.connect("pressed", Callable(self, "_on_resume_pressed"))
	restart_button.connect("pressed", Callable(self, "_on_restart_pressed"))
	quit_button.connect("pressed", Callable(self, "_on_quit_pressed"))

# ---- INPUT HANDLING ----
func _input(event):
	if event.is_action_pressed("ui_cancel"): # Default "Esc" key
		if not is_paused:
			_pause_game()
		else:
			_resume_game()

# ---- BUTTON HANDLERS ----
func _on_resume_pressed():
	_resume_game()
	_play_button_click()

func _on_restart_pressed():
	_play_button_click()
	_resume_game() # Unpause first → avoid stuck paused state

	var game_controller = get_tree().get_root().get_node("GameController")
	if game_controller:
		game_controller.change_state(GameController.GameState.LOADING)
	else:
		push_error("PauseMenu could not find GameController to restart game.")

func _on_quit_pressed():
	_play_button_click()
	_resume_game()

	var game_controller = get_tree().get_root().get_node("GameController")
	if game_controller:
		game_controller.change_state(GameController.GameState.ATTRACT_MODE)
	else:
		push_error("PauseMenu could not find GameController to quit to attract mode.")

# ---- PAUSE HANDLING ----
func _pause_game():
	get_tree().paused = true
	is_paused = true
	_set_visible(true)

func _resume_game():
	get_tree().paused = false
	is_paused = false
	_set_visible(false)

# ---- UTILS ----
func _set_visible(visible: bool):
	self.visible = visible

func _play_button_click():
	var audio_manager = get_tree().get_root().get_node("AudioManager")
	if audio_manager:
		audio_manager.play_sfx("button_click")
