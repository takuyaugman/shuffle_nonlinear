extends Control

var data
var items = []
var order = []
var pointer = 0
var current_item
var detail_visible = false

func _ready():
	# 文字列でクラスを検索（これなら未定義エラーで落ちない）
	var file = FileAccess.open("res://data.db",FileAccess.READ)
	var text = file.get_as_text()
	data = JSON.parse_string(text)
	
	items = data["items"]
	
	make_new_order()
	show_next_item()
	$MarginContainer/VBoxContainer/Label2.text = ""
	#print("JSON 読み込み成功")

# 全部表示するためにシャッフルする
func make_new_order():
	for i in range(items.size()):
		order.append(i)
	order.shuffle()
	pointer = 0

func show_next_item():
	
	if pointer >= order.size():
		make_new_order()
	
	var index = order[pointer]
	pointer += 1
	
	var item  = items[index]
	
	$MarginContainer/VBoxContainer/Label.text = item["label"]
	$MarginContainer/VBoxContainer/Label2.text = ""
	
	detail_visible = false
	#$MarginContainer/VBoxContainer/Label2.visible = false
	current_item = item

func toggle_detail():
	detail_visible = !detail_visible
	if detail_visible:
		$MarginContainer/VBoxContainer/Label2.text = current_item["detail"]
	else:
		$MarginContainer/VBoxContainer/Label2.text = ""
	#$MarginContainer/VBoxContainer/Label2.visible = detail_visible
	

func _on_button_pressed() -> void:
	show_next_item()


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.is_pressed():
		toggle_detail()
	pass # Replace with function body.
