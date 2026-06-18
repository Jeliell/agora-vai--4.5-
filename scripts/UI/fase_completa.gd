extends CanvasLayer

# Arraste o .tres da cutscene de cada fase no Inspector
@export var cutscenes_por_fase: Dictionary = {}

func _ready() -> void:
	visible = false

# Chamado pelo world_base quando a fase é concluída
func abrir() -> void:
	visible = true
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_botao_proxima_fase_pressed() -> void:
	get_tree().paused = false

	var destino: String = ""
	var proxima: String = Configuracao.proxima_fase_cena

	if proxima == "":
		Configuracao.resetar_progresso()
		destino = "res://scenes/UI/menu.tscn"
	else:
		Configuracao.nivel_atual_da_fase = 1
		destino = proxima

	var cutscene: CutsceneData = cutscenes_por_fase.get(Configuracao.fase_atual, null)
	if cutscene != null:
		cutscene.cena_seguinte = destino
		Configuracao.cutscene_atual = cutscene
		get_tree().change_scene_to_file("res://scenes/UI/cutscene.tscn")
	else:
		get_tree().change_scene_to_file(destino)

func _on_botao_reiniciar_pressed() -> void:
	get_tree().paused = false
	Configuracao.nivel_atual_da_fase = 1
	var n: int = Configuracao.fase_atual
	get_tree().change_scene_to_file("res://scenes/fases/fase" + str(n) + "/fase" + str(n) + ".tscn")

func _on_botao_menu_pressed() -> void:
	get_tree().paused = false
	Configuracao.resetar_progresso()
	get_tree().change_scene_to_file("res://scenes/UI/menu.tscn")
