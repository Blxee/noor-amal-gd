extends Control

enum State { NEW, EDIT }
const CANCEL = preload("res://assets/cancel.svg")
const CHECK = preload("res://assets/check.svg")
const CHEVRON = preload("res://assets/chevron.svg")

var database: DataBase
var state: State

var entry: Entry:
	set(value):
		entry = value
		%FirstNameEdit.text = entry.first_name
		%LastNameEdit.text = entry.last_name
		%RegisterFeeCheckbox.button_pressed = entry.register_fee
		%AssuranceFeeCheckBox.button_pressed = entry.assurance
		_update_data()


func add_user() -> void:
	state = State.NEW
	entry = Entry.new()
	show()
	%Title.text = 'إضافة عضو جديد'
	%Actions.hide()
	$PanelContainer/VBoxContainer/FieldsForm/Payment.hide()
	%DateCover.hide()
	_on_edit_pressed()


func edit_user(entry: Entry) -> void:
	state = State.EDIT
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
	$PanelContainer/VBoxContainer/FieldsForm/Payment.show()


func _on_cancel_pressed() -> void:
	hide()


func _on_ok_pressed() -> void:
	_save_entry()
	hide()
	get_tree().get_root().add_child(Toast.create_toast(
		'تمت اضافة عضو بنجاح!'
		if state == State.NEW else 
		'تم تعديل عضو بنجاح!'
	))


func _save_entry() -> void:
	if state == State.NEW:
		var entry: Entry = Entry.new()
	entry.first_name = %FirstNameEdit.text
	entry.last_name = %LastNameEdit.text
	if state == State.NEW:
		entry.date_register = Time.get_unix_time_from_datetime_dict(
			%RegisterDatePicker.get_date_data()
		)
		entry.last_payment = entry.date_register
	entry.register_fee = %RegisterFeeCheckbox.button_pressed
	entry.assurance = %AssuranceFeeCheckBox.button_pressed
	
	if state == State.NEW:
		database.add_entry(entry)
	else:
		DataBase.save_data(database)


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_released():
		_on_cancel_pressed()


func _on_delete_pressed() -> void:
	var prompt: Prompt = Prompt.create_prompt(
		'أنت على وشك مسح هذا العضو،\nهل أنت متأكد؟',
		false,
		func():
			database.remove_entry(entry)
			get_tree().get_root().add_child(Toast.create_toast('تمت حذف عضو بنجاح!'))
			hide()
	)
	get_tree().get_root().add_child(prompt)


func _on_edit_pressed() -> void:
	%FirstNameEdit.editable = true
	%LastNameEdit.editable = true
	%RegisterFeeCheckbox.disabled = false
	%AssuranceFeeCheckBox.disabled = false


func _on_pay_month_pressed() -> void:
	entry.last_payment += 30 * 24 * 60 * 60
	_update_data()


func _on_unpay_month_pressed() -> void:
	entry.last_payment -= 30 * 24 * 60 * 60
	_update_data()


func _update_data() -> void:
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
