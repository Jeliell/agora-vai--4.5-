extends Node2D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_botao_proxima_fase_pressed() -> void:
	var cena: String = get_tree().get_meta(
		"proxima_cena",
		"res://scenes/fases/fase1/fase1_nivel1.tscn"
	)
	if cena == "":
		# Fase 4 nível 3 — fim do jogo, tratar futuramente
		get_tree().change_scene_to_file("res://scenes/ui/menu.tscn")
	else:
		get_tree().change_scene_to_file(cena)

func _on_botao_reiniciar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/fases/fase1/fase1_nivel1.tscn")

func _on_botao_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
