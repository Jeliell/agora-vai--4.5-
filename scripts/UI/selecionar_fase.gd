extends Node2D

const FASES = {
	1: "res://scenes/fases/fase1/fase1.tscn",
	2: "res://scenes/fases/fase2/fase2.tscn",
	3: "res://scenes/fases/fase3/fase3.tscn",
	4: "res://scenes/fases/fase4/fase4.tscn",
}

var fase_selecionada: int = -1

@onready var painel_fases: Control  = $PainelFases
@onready var painel_niveis: Control = $PainelNiveis
@onready var label_fase_titulo: Label = $PainelNiveis/LabelTitulo

func _ready() -> void:
	painel_niveis.visible = false
	painel_fases.visible = true

func selecionar_fase(fase: int) -> void:
	fase_selecionada = fase
	label_fase_titulo.text = "Fase " + str(fase)
	painel_fases.visible = false
	painel_niveis.visible = true

func selecionar_nivel(nivel: int) -> void:
	Configuracao.nivel_atual_da_fase = nivel
	get_tree().change_scene_to_file(FASES[fase_selecionada])

func _on_botao_voltar_pressed() -> void:
	painel_niveis.visible = false
	painel_fases.visible = true

func _on_botao_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/UI/menu.tscn")
