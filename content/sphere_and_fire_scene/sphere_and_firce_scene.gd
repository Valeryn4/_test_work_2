extends Spatial

export(String, FILE, "*.tscn") var back_path := ""

func _on_ButtonBack_pressed() -> void:
	if ResourceLoader.exists(back_path) :
		get_tree().change_scene(back_path)
