extends Panel

const CANCEL = preload("res://assets/cancel.svg")
const CHECK = preload("res://assets/check.svg")

@onready var entry: Entry:
	set(value):
		entry = value
		%FirstName.text = entry.first_name
		%LastName.text = entry.last_name
		%Assurance.texture = CHECK if entry.assurance else CANCEL


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		get_node('/root/MainScene').edit_user(entry)
