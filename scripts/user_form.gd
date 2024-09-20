extends Control

var database: DataBase

var entry: Entry:
	set(value):
		entry = value
		%FirstNameEdit.text = entry.first_name
		%LastNameEdit.text = entry.last_name
		#entry.date_register = Time.get_unix_time_from_datetime_dict(
			#%RegisterDatePicker.get_date_data()
		#)
		#entry.last_payment = entry.date_register
		%RegisterFeeCheckbox.button_pressed = entry.register_fee
		%AssuranceFeeCheckBox.button_pressed = entry.assurance


func add_user() -> void:
	entry = Entry.new()
	show()
	%Title.text = 'إضافة عضو جديد'
	%Actions.hide()
	_on_edit_pressed()


func edit_user(entry: Entry) -> void:
	self.entry = entry
	show()
	%Title.text = 'تعديل عضو'
	%Actions.show()
	%FirstNameEdit.editable = false
	%LastNameEdit.editable = false
	%RegisterDatePicker
	%RegisterFeeCheckbox.disabled = true
	%AssuranceFeeCheckBox.disabled = true
	%DateCover.show()


func _on_cancel_pressed() -> void:
	hide()


func _on_ok_pressed() -> void:
	_save_entry()
	hide()


func _save_entry() -> void:
	var entry: Entry = Entry.new()
	
	entry.first_name = %FirstNameEdit.text
	entry.last_name = %LastNameEdit.text
	entry.date_register = Time.get_unix_time_from_datetime_dict(
		%RegisterDatePicker.get_date_data()
	)
	entry.last_payment = entry.date_register
	entry.register_fee = %RegisterFeeCheckbox.button_pressed
	entry.assurance = %AssuranceFeeCheckBox.button_pressed
	
	database.add_entry(entry)
	get_tree().get_root().add_child(Toast.create_toast('User Added successfully!'))


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_released():
		_on_cancel_pressed()


func _on_delete_pressed() -> void:
	var prompt: Prompt = Prompt.create_prompt(
		'You are about ot delete this user!\nAre you sure?',
		false,
		func():
			database.remove_entry(entry)
			get_tree().get_root().add_child(Toast.create_toast('User deleted successfully!'))
			hide()
	)
	get_tree().get_root().add_child(prompt)


func _on_edit_pressed() -> void:
	%FirstNameEdit.editable = true
	%LastNameEdit.editable = true
	%RegisterDatePicker
	%RegisterFeeCheckbox.disabled = false
	%AssuranceFeeCheckBox.disabled = false
	%DateCover.hide()
