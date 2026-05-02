extends Node2D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_botao_reiniciar_pressed() -> void:
	# Reinicia a fase atual no nível 1
	Configuracao.nivel_atual_da_fase = 1
	var cena: String = Configuracao.cena_fase_atual
	if cena == "":
		cena = "res://scenes/fases/fase1/fase1.tscn"
	get_tree().change_scene_to_file(cena)

func _on_botao_menu_pressed() -> void:
	Configuracao.resetar_progresso()
	get_tree().change_scene_to_file("res://scenes/UI/menu.tscn")
