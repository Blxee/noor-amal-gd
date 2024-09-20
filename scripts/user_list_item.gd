extends Panel

const CANCEL = preload("res://assets/cancel.svg")
const CHECK = preload("res://assets/check.svg")
const CHEVRON = preload("res://assets/chevron.svg")

@onready var entry: Entry:
	set(value):
		entry = value
		%FirstName.text = entry.first_name
		%LastName.text = entry.last_name
		%Assurance.texture = CHECK if entry.assurance else CANCEL
		
		var months_due: int = roundi(Time.get_date_dict_from_unix_time(Time.get_unix_time_from_system() - entry.last_payment).get('month'))
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


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		get_node('/root/MainScene').edit_user(entry)
