extends Node2D

# --- VARIÁVEIS DA CUTSCENE ---
@export var cutscene_inicio: CutsceneData = null

# --- VARIÁVEIS DO MENU INTERATIVO (Resgate) ---
@onready var garca_patrulheira = $GarcaMenu
@onready var ponto_origem = $PontoOrigem
@onready var botao_jogar = $BotaoJogar
var resgatando: bool = false

func _ready() -> void:
	# Garante que o mouse aparece no menu
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

# --- FUNÇÃO DO BOTÃO JOGAR (Cutscene / Início) ---
func _on_botao_jogar_pressed() -> void:
	Configuracao.resetar_progresso()
	
	# Se há cutscene de início, exibe antes da fase 1
	if cutscene_inicio != null:
		cutscene_inicio.cena_seguinte = "res://scenes/fases/fase1/fase1.tscn"
		Configuracao.cutscene_atual = cutscene_inicio
		get_tree().change_scene_to_file("res://scenes/UI/cutscene.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/fases/fase1/fase1.tscn")

# --- FUNÇÕES DA ZONA DE QUEDA (Resgate) ---
func _on_zona_de_queda_body_entered(body: Node2D) -> void:
	print("Algo caiu na zona de queda: ", body.name) # Print para teste!
	
	if body.name == "player" and not resgatando:
		resgatando = true
		var pos_segura = ponto_origem.global_position
		body.velocity = Vector2.ZERO
		body.set_physics_process(false)
		garca_patrulheira.iniciar_resgate(body, pos_segura)

func _on_zona_de_queda_area_entered(area: Area2D) -> void:
	pass
