extends Node2D

const FASES = {
	1: {
		"nome": "Fase 1 - Adição",
		"niveis": {
			1: "res://scenes/fases/fase1/fase1_nivel1.tscn",
			2: "res://scenes/fases/fase1/fase1_nivel2.tscn",
			3: "res://scenes/fases/fase1/fase1_nivel3.tscn",
		}
	},
	2: {
		"nome": "Fase 2 - Subtração",
		"niveis": {
			1: "res://scenes/fases/fase2/fase2_nivel1.tscn",
			2: "res://scenes/fases/fase2/fase2_nivel2.tscn",
			3: "res://scenes/fases/fase2/fase2_nivel3.tscn",
		}
	},
	3: {
		"nome": "Fase 3 - Em breve",
		"niveis": {
			1: "res://scenes/fases/fase3/fase3_nivel1.tscn",
			2: "res://scenes/fases/fase3/fase3_nivel2.tscn",
			3: "res://scenes/fases/fase3/fase3_nivel3.tscn",
		}
	},
	4: {
		"nome": "Fase 4 - Em breve",
		"niveis": {
			1: "res://scenes/fases/fase4/fase4_nivel1.tscn",
			2: "res://scenes/fases/fase4/fase4_nivel2.tscn",
			3: "res://scenes/fases/fase4/fase4_nivel3.tscn",
		}
	},
}

var fase_selecionada: int = -1

@onready var painel_fases: Control  = $PainelFases
@onready var painel_niveis: Control = $PainelNiveis
@onready var label_fase_titulo: Label = $PainelNiveis/LabelTitulo

func _ready() -> void:
	painel_niveis.visible = false
	painel_fases.visible = true

# Chamado por cada BotaoFaseX
func selecionar_fase(fase: int) -> void:
	fase_selecionada = fase
	label_fase_titulo.text = FASES[fase]["nome"]
	painel_fases.visible = false
	painel_niveis.visible = true

# Chamado por cada BotaoNivelX
func selecionar_nivel(nivel: int) -> void:
	var cena: String = FASES[fase_selecionada]["niveis"][nivel]
	get_tree().change_scene_to_file(cena)

func _on_botao_voltar_pressed() -> void:
	painel_niveis.visible = false
	painel_fases.visible = true

func _on_botao_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/menu.tscn")


func _on_menu_pressed() -> void:
	pass # Replace with function body.
