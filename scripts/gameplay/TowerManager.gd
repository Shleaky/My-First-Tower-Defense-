extends Node
class_name TowerManager

# ---- CONFIG ----
var tower_scene = preload("res://scenes/gameplay/Tower.tscn")

# ---- STATE ----
var awarded_tower_type: String = ""  # Empty when no tower awarded

# ---- NODES ----
@onready var tower_slot_container = $TowerSlotContainer

# ---- SETUP ----
func _ready():
	print("TowerManager ready.")

	if GameGlobalController:
		GameGlobalController.connect("new_tower_awarded", Callable(self, "_on_new_tower_awarded"))
	else:
		push_error("TowerManager.gd could not find GameGlobalController singleton.")

# ---- SIGNAL HANDLER ----
func _on_new_tower_awarded(tower_type: String):
	print("TowerManager received new tower award: %s" % tower_type)
	awarded_tower_type = tower_type

# ---- PUBLIC API ----
func place_or_upgrade_tower(tower_slot):
	if awarded_tower_type == "":
		print("No tower awarded → cannot place.")
		return

	if tower_slot.has_tower():
		print("Upgrading existing tower at slot.")
		tower_slot.upgrade_tower()
	else:
		print("Placing new tower at slot.")
		var tower_instance = tower_scene.instantiate()
		tower_instance.position = Vector2.ZERO

		tower_slot.add_child(tower_instance)
		tower_slot.set_has_tower(true)

	# After placing/upgrading, consume the awarded tower
	awarded_tower_type = ""
