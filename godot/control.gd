extends Control

var showing_detail := false
var current_item := {}

var db := SQLite.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_items()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_items():
	
	db.path = "res://../data.db"
	var ok = db.open_db()
	if not ok:
		print("DB open failed")
		return
	
	db.query("SELECT * FROM items ORDER BY id DESC LIMIT 1")
	var rows = db.query_result
	
	if rows.size() == 0:
		$MarginContainer/VBoxContainer/Label.text = "There is no data"
		return
		
	#var item = rows[0]
	current_item = rows[0]
	$MarginContainer/VBoxContainer/Label.text = current_item["label"]


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		toggle_detail()
		#print("foo")
	pass # Replace with function body.

func toggle_detail():
	if showing_detail:
		#$MarginContainer/VBoxContainer/Label.text = current_item["label"]
		$MarginContainer/VBoxContainer/Label2.text = ""
		showing_detail = false
	else:
		$MarginContainer/VBoxContainer/Label2.text = current_item["detail"]
		showing_detail = true


func _on_button_pressed() -> void:
	next_item()
	pass # Replace with function body.
	
func next_item():
	var current_id = current_item["id"]
	
	db.query("SELECT * FROM items WHERE id != %d ORDER BY RANDOM() LIMIT 1" % current_id)
	var rows = db.query_result
	
	if rows.size() == 0:
		return
		
	current_item = rows[0]
	
	$MarginContainer/VBoxContainer/Label.text = current_item["label"]
	$MarginContainer/VBoxContainer/Label2.text = ""
	
	
	
	pass
