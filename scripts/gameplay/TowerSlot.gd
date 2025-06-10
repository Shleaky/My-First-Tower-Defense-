extends Area2D
class_name TowerSlot

# ---- STATE ----
var current_tower: Node = null
var has_tower_flag: bool = false

# ---- NODES ----
@onready var highlight_sprite = $HighlightSprite

# ---- SETUP ----
func _ready():
	_set_highlight(false)

# ---- INPUT HANDLING ----
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_on_slot_clicked()

# ---- CLICK HANDLER ----
func _on_slot_clicked():
	var tower_manager = get_parent().get_parent().get_node("TowerManager")
	if tower_manager:
		tower_manager.place_or_upgrade_tower(self)
	else:
		push_error("TowerSlot.gd could not find TowerManager.")

# ---- PUBLIC API ----
func has_tower() -> bool:
	return has_tower_flag

func set_has_tower(value: bool):
	has_tower_flag = value
	_set_highlight(false)  # Optional: clear highlight after placing tower

func upgrade_tower():
	if current_tower and is_instance_valid(current_tower):
		if current_tower.has_method("upgrade"):
			current_tower.upgrade()
			print("Tower upgraded!")
		else:
			push_error("Tower at slot has no upgrade() method.")
	else:
		push_error("No tower to upgrade at this slot.")

# ---- HIGHLIGHT ----
func _set_highlight(enabled: bool):
	highlight_sprite.visible = enabled

# ---- SLOT RESET (optional)
func clear_slot():
	if current_tower and is_instance_valid(current_tower):
		current_tower.queue_free()
	current_tower = null
	has_tower_flag = false
	_set_highlight(false)
