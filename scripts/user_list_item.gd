extends Panel

const CANCEL = preload("res://assets/cancel.svg")
const CHECK = preload("res://assets/check.svg")
const CHEVRON = preload("res://assets/chevron.svg")

@onready var entry: Entry:
	set(value):
		entry = value
		_update_data()


func _ready() -> void:
	_update_data()


func _update_data() -> void:
	if is_node_ready() and entry != null:
		%FirstName.text = entry.first_name
		%LastName.text = entry.last_name
		%Registration.text = Time.get_date_string_from_unix_time(entry.date_register)
		%Assurance.texture = CHECK if entry.assurance else CANCEL
		
		var last_payment: Dictionary = Time.get_date_dict_from_unix_time(entry.last_payment)
		var current_date: Dictionary = Time.get_date_dict_from_system()
		var months_due: int = (current_date.get('year') - last_payment.get('year')) * 12 + (current_date.get('month') - last_payment.get('month'))
		
		if months_due > 0:
			%Payment.modulate = Color('#f52c58')
			%Payment/Month.show()
			%Payment/Month.text = str(abs(months_due))
			%Payment/Texture.texture = CHEVRON
			%Payment/Texture.flip_v = true
		elif months_due < 0:
			%Payment.modulate = Color('#45d918')
			%Payment/Month.show()
			%Payment/Month.text = str(abs(months_due))
			%Payment/Texture.texture = CHEVRON
			%Payment/Texture.flip_v = false
		elif months_due == 0:
			%Payment.modulate = Color('#45d918')
			%Payment/Month.hide()
			%Payment/Texture.texture = CHECK
			%Payment/Texture.flip_v = false


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		get_node('/root/MainScene').edit_user(entry)
