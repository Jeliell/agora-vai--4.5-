extends Node2D

# Arraste a cutscene de abertura no Inspector
@export var cutscene_inicio: CutsceneData = null

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_botao_jogar_pressed() -> void:
	Configuracao.resetar_progresso()

	# Se há cutscene de início, exibe antes da fase 1
	if cutscene_inicio != null:
		cutscene_inicio.cena_seguinte = "res://scenes/fases/fase1/fase1.tscn"
		Configuracao.cutscene_atual = cutscene_inicio
		get_tree().change_scene_to_file("res://scenes/UI/cutscene.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/fases/fase1/fase1.tscn")

func _on_botao_selecionar_fase_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/UI/selecionar_fase.tscn")

func _on_botao_dificuldade_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/UI/selecionar_dificuldade.tscn")

func _on_botao_sair_pressed() -> void:
	if OS.has_feature("editor"):
		get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	else:
		get_tree().quit()
