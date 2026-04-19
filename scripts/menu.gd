extends Node2D
 
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
 
func _on_botao_jogar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world.tscn")
 
func _on_botao_dificuldade_pressed() -> void:
	# Funcionalidade a implementar futuramente
	pass
 
func _on_botao_sair_pressed() -> void:
	if OS.has_feature("editor"):
		get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	else:
		get_tree().quit()
