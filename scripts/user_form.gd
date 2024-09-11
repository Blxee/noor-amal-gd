extends Control

var entry: Entry


func _ready() -> void:
	%RegisterDatePicker


func _on_cancel_pressed() -> void:
	queue_free()


func _on_ok_pressed() -> void:
	_save_entry()
	queue_free()


func _save_entry() -> void:
	var entry: Entry = Entry.new()
	entry.first_name = %FirstNameEdit.text
	entry.last_name = %LastNameEdit.text
	entry.date_register = Time.get_unix_time_from_datetime_dict(
		%RegisterDatePicker.get_date_data()
	)
	entry.assurance = %AssuranceFeeCheckBox


func _on_gui_input(event: InputEvent) -> void:
	_on_cancel_pressed()
