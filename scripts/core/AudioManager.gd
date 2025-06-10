extends Node
class_name AudioManager

# ---- AUDIO PLAYERS ----
@onready var music_player = $MusicPlayer
@onready var sfx_player = $SFXPlayer
@onready var ambience_player = $AmbiencePlayer

# ---- CONFIGURABLE AUDIO ----
# Replace with actual paths to your .ogg/.wav files
var music_tracks = {
	"menu": preload("res://assets/sounds/music/menu_theme.mp3"),
	"game": preload("res://assets/sounds/music/game_theme.mp3"),
	"game_over": preload("res://assets/sounds/music/game_over_theme.mp3"),
}

var sfx_sounds = {
	"tower_fire": preload("res://assets/sounds/shot.mp3"),
	"enemy_die": preload("res://assets/sounds/cocking.mp3"),
	"base_hit": preload("res://assets/sounds/cocking.mp3"),
	"button_click": preload("res://assets/sounds/cocking.mp3"),
}

var ambience_loop = preload("res://assets/sounds/music/game_over_theme.mp3")

# ---- SETUP ----
func _ready():
	print("AudioManager ready.")
	# Play ambient loop during attract mode by default
	ambience_player.stream = ambience_loop
	ambience_player.play()

	# Connect signals
	var game_controller = get_tree().get_root().get_node("GameController")
	if GameGlobalController:
		GameGlobalController.connect("game_state_changed", Callable(self, "_on_game_state_changed"))
		GameGlobalController.connect("game_over", Callable(self, "_on_game_over"))
	else:
		push_error("AudioManager could not find GameGlobalController.")


# ---- PUBLIC API ----
func play_music(track_name: String):
	if not music_tracks.has(track_name):
		push_warning("Unknown music track: %s" % track_name)
		return

	music_player.stop()
	music_player.stream = music_tracks[track_name]
	music_player.play()

func play_sfx(sfx_name: String):
	if not sfx_sounds.has(sfx_name):
		push_warning("Unknown SFX: %s" % sfx_name)
		return

	sfx_player.stream = sfx_sounds[sfx_name]
	sfx_player.play()

# ---- SIGNAL RESPONDERS ----
func _on_game_state_changed(new_state):
	match new_state:
		GameController.GameState.ATTRACT_MODE:
			play_music("menu")
			ambience_player.play()
		GameController.GameState.IN_GAME:
			play_music("game")
			ambience_player.stop()
		GameController.GameState.GAME_OVER:
			# Will be handled by separate signal below
			pass
		GameController.GameState.SHOW_LEADERBOARD:
			play_music("menu")
			ambience_player.play()

func _on_game_over():
	play_music("game_over")
	ambience_player.play()
