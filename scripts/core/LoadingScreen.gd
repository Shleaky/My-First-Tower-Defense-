extends Control
class_name LoadingScreen

# ---- NODES ----
@onready var animation_player = $AnimationPlayer

# ---- SETUP ----
func _ready():
	print("LoadingScreen shown.")
	# Optional: play fade-in animation
	if animation_player:
		animation_player.play("FadeIn")

# ---- PUBLIC API ----
func play_fade_out():
	if animation_player:
		animation_player.play("FadeOut")
