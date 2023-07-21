extends Control

const IDX_BUTTON_MOVE := 3
const ANIMATION_SIZE := 1.2
const ANIMATION_DURACTION := 0.3
const ANIMATION_INTERVAL := 0.1


export(String, FILE, "*.tscn") var button_1_next_scene := ""
export(bool) var enable_button_1 := true
export(bool) var enable_button_2 := true
export(bool) var enable_button_3 := true
export(bool) var enable_button_4 := true

onready var _buttons_container := $"%GridContainerButtons"
onready var _tween := $TweenButtonsEffect


##### BUTTON 1 #####
func _on_Button1_pressed() -> void:
	if not enable_button_1 :
		return
	
	var popup := ConfirmationDialog.new()
	popup.window_title = tr("Следующая сцена")
	popup.resizable = true
	popup.dialog_text = tr("Ты уверен?")
	
	popup.get_ok().text = tr("Переход")
	popup.get_ok().connect("pressed", self, "_on_button_1_change_scene")
	popup.get_ok().connect("pressed", popup, "queue_free")
	
	popup.get_cancel().connect("pressed", popup, "queue_free")
	popup.get_cancel().text = tr("Отмена")
	
	add_child(popup)
	popup.popup_centered_minsize()


func _on_button_1_change_scene() -> void :
	if ResourceLoader.exists(button_1_next_scene) :
		get_tree().change_scene(button_1_next_scene)


##### BUTTON 2 #####
func _on_Button2_pressed() -> void:
	if not enable_button_2 :
		return
	
	_tween.stop_all()
	_tween.seek(0)
	_tween.remove_all()
	for i in _buttons_container.get_child_count() :
		var root_buttons := _buttons_container.get_child(i)
		var button := root_buttons.get_child(0) as Button
		_tween.interpolate_property(
			button,
			"rect_scale",
			Vector2.ONE,
			Vector2.ONE * ANIMATION_DURACTION,
			ANIMATION_DURACTION,
			Tween.TRANS_BACK,
			Tween.EASE_IN_OUT,
			i * ANIMATION_INTERVAL
		)
		
		_tween.interpolate_property(
			button,
			"rect_scale",
			Vector2.ONE * ANIMATION_DURACTION,
			Vector2.ONE,
			ANIMATION_DURACTION,
			Tween.TRANS_BACK,
			Tween.EASE_IN_OUT,
			ANIMATION_DURACTION + i * ANIMATION_INTERVAL
		)
	
	_tween.start()


#### BUTTON 3 ####
func _on_Button3_pressed() -> void:
	if not enable_button_3 :
		return
	
	var move_button := _buttons_container.get_child(IDX_BUTTON_MOVE)
	_buttons_container.move_child(move_button, IDX_BUTTON_MOVE - 1)



#### BUTTON 4 ####
func _on_Button4_pressed() -> void:
	if not enable_button_4 :
		return
	
	var popup := AcceptDialog.new()
	popup.window_title = tr("Выход")
	popup.dialog_text = tr("Ты уверен?")
	
	popup.get_ok().connect("pressed", get_tree(), "quit")
	popup.get_ok().text = tr("да")
	
	popup.add_cancel(tr("нет")).connect("pressed", popup, "queue_free")
	
	add_child(popup)
	popup.popup_centered_minsize()
