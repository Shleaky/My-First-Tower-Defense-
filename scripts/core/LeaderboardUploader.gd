extends Node
class_name LeaderboardUploader

# ---- CONFIG ----
const LEADERBOARD_POST_URL = "https://your-backend-url.com/api/leaderboard" # Change to your actual API
const LEADERBOARD_GET_URL = "https://your-backend-url.com/api/leaderboard"

# ---- STATE ----
var is_request_in_progress: bool = false

# ---- NODES ----
@onready var http_request = $HTTPRequest

# ---- SETUP ----
func _ready():
	print("LeaderboardUploader ready.")

# ---- PUBLIC API ----
# Submit score → (name: String, score: int)
func submit_score(name: String, score: int):
	if is_request_in_progress:
		print("LeaderboardUploader: Request already in progress.")
		return

	# Sanitize name
	name = name.strip_edges().substr(0, 12) # Max 12 chars
	name = name.to_upper()

	var payload = {
		"username": name,
		"score": score
	}

	var json_payload = JSON.stringify(payload)


	is_request_in_progress = true

	print("Submitting score: %s" % json_payload)

	var err = http_request.request(
		LEADERBOARD_POST_URL,
		[],
		true, # Use SSL
		HTTPClient.METHOD_POST,
		json_payload
	)

	if err != OK:
		push_error("LeaderboardUploader: Failed to start POST request.")
		is_request_in_progress = false

# Fetch leaderboard → expects to emit signal with results
func fetch_leaderboard():
	if is_request_in_progress:
		print("LeaderboardUploader: Request already in progress.")
		return

	is_request_in_progress = true

	print("Fetching leaderboard...")

	var err = http_request.request(LEADERBOARD_GET_URL)

	if err != OK:
		push_error("LeaderboardUploader: Failed to start GET request.")
		is_request_in_progress = false

# ---- SIGNAL HANDLERS ----
func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	is_request_in_progress = false

	if result != OK or response_code != 200:
		push_error("LeaderboardUploader: Request failed. Response code: %d" % response_code)
		emit_signal("leaderboard_fetch_failed")
		return

	# Attempt to parse response
	var json_result = {}
	var json = JSON.new()
	var parse_error = json.parse(body.get_string_from_utf8())
	
	if parse_error != OK:
		push_error("LeaderboardUploader: JSON parse failed.")
		emit_signal("leaderboard_fetch_failed")
		return

	json_result = json.data

# Emit success signal
	emit_signal("leaderboard_fetched", json_result)


# ---- SIGNALS ----
signal leaderboard_fetched(scores) # Scores is array of dicts → [{ username, score }, ...]
signal leaderboard_fetch_failed()
