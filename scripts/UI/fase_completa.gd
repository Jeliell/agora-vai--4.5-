extends Node2D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_botao_proxima_fase_pressed() -> void:
	var cena: String = Configuracao.proxima_fase_cena
	if cena == "":
		Configuracao.resetar_progresso()
		get_tree().change_scene_to_file("res://scenes/UI/menu.tscn")
	else:
		Configuracao.nivel_atual_da_fase = 1
		get_tree().change_scene_to_file(cena)

func _on_botao_reiniciar_pressed() -> void:
	Configuracao.nivel_atual_da_fase = 1
	var n: int = Configuracao.fase_atual
	get_tree().change_scene_to_file("res://scenes/fases/fase" + str(n) + "/fase" + str(n) + ".tscn")

func _on_botao_menu_pressed() -> void:
	Configuracao.resetar_progresso()
	get_tree().change_scene_to_file("res://scenes/UI/menu.tscn")
