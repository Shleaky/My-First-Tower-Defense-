extends Control
class_name Leaderboard

# ---- NODES ----
@onready var score_list = $VBoxContainer/ScoreList
@onready var back_button = $VBoxContainer/VBoxContainer/BackButton

# ---- SETUP ----
func _ready():
	print("Leaderboard scene ready (Testing Mode).")
	_connect_back_button()
	_show_dummy_leaderboard()

# ---- UI ----
func _show_dummy_leaderboard():
	_clear_score_list()

	var dummy_scores = [
		{ "username": "AAA", "score": 10000 },
		{ "username": "BBB", "score": 8500 },
		{ "username": "CCC", "score": 7000 },
		{ "username": "DDD", "score": 5000 },
		{ "username": "EEE", "score": 3000 }
	]

	for entry in dummy_scores:
		var label = Label.new()
		label.text = "%s - %d" % [entry.username, entry.score]
		score_list.add_child(label)

func _clear_score_list():
	for child in score_list.get_children():
		child.queue_free()

# ---- BUTTON HANDLING ----
func _connect_back_button():
	back_button.connect("pressed", Callable(self, "_on_back_pressed"))


func _on_back_pressed():
	var audio_manager = get_node("AudioManager")
	if audio_manager:
		audio_manager.play_sfx("button_click")

	
	if GameGlobalController:
		GameGlobalController.change_state(GameGlobalController.GameState.ATTRACT_MODE)
	else:
		push_error("Leaderboard.gd could not find GameController.")
