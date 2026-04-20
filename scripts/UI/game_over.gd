extends Node2D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_botao_reiniciar_pressed() -> void:
	var cena: String = get_tree().get_meta(
		"cena_reinicio",
		"res://scenes/fases/fase1/fase1_nivel1.tscn"
	)
	get_tree().change_scene_to_file(cena)

func _on_botao_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/menu.tscn")
