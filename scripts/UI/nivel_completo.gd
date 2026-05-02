extends Node2D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_botao_proximo_nivel_pressed() -> void:
	get_tree().change_scene_to_file(_caminho_fase_atual())

func _on_botao_reiniciar_pressed() -> void:
	get_tree().change_scene_to_file(_caminho_fase_atual())

func _on_botao_menu_pressed() -> void:
	Configuracao.resetar_progresso()
	get_tree().change_scene_to_file("res://scenes/UI/menu.tscn")

func _caminho_fase_atual() -> String:
	var n: int = Configuracao.fase_atual
	return "res://scenes/fases/fase" + str(n) + "/fase" + str(n) + ".tscn"
