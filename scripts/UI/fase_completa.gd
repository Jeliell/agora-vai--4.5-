extends Node2D

# Arraste o .tres da cutscene de cada fase no Inspector
# Chave = número da fase (int), Valor = CutsceneData
@export var cutscenes_por_fase: Dictionary = {}

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_botao_proxima_fase_pressed() -> void:
	var destino: String = ""
	var proxima: String = Configuracao.proxima_fase_cena

	if proxima == "":
		# Fim do jogo
		Configuracao.resetar_progresso()
		destino = "res://scenes/UI/menu.tscn"
	else:
		Configuracao.nivel_atual_da_fase = 1
		destino = proxima

	# Verifica se há cutscene para a fase recém-concluída
	var cutscene: CutsceneData = cutscenes_por_fase.get(Configuracao.fase_atual, null)
	if cutscene != null:
		cutscene.cena_seguinte = destino
		Configuracao.cutscene_atual = cutscene
		get_tree().change_scene_to_file("res://scenes/UI/cutscene.tscn")
	else:
		get_tree().change_scene_to_file(destino)

func _on_botao_reiniciar_pressed() -> void:
	Configuracao.nivel_atual_da_fase = 1
	var n: int = Configuracao.fase_atual
	get_tree().change_scene_to_file("res://scenes/fases/fase" + str(n) + "/fase" + str(n) + ".tscn")

func _on_botao_menu_pressed() -> void:
	Configuracao.resetar_progresso()
	get_tree().change_scene_to_file("res://scenes/UI/menu.tscn")
