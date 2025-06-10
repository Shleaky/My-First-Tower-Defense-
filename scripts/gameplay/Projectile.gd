extends Node2D
class_name Projectile

# ---- CONFIG ----
var speed: float = 300.0
var damage: int = 10
var target: Node2D = null

# ---- SETUP ----
func _ready():
	print("Projectile ready → damage %d" % damage)

# ---- MAIN LOOP ----
func _process(delta):
	if target == null or not is_instance_valid(target):
		queue_free()
		return

	# Move toward target
	var direction = (target.global_position - global_position).normalized()
	global_position += direction * speed * delta

	# Check if close enough to hit
	if global_position.distance_to(target.global_position) < 10.0:
		_on_hit_target()

# ---- HIT HANDLING ----
func _on_hit_target():
	print("Projectile hit target → dealing %d damage" % damage)

	# Check if target has "take_damage" method
	if target.has_method("take_damage"):
		target.take_damage(damage)
	else:
		push_error("Target has no take_damage() method!")

	# Destroy projectile
	queue_free()
