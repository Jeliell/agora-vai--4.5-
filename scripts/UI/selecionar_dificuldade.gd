extends Node2D

@onready var label_atual: Label = $LabelAtual

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_atualizar_label()

func _atualizar_label() -> void:
	label_atual.text = "Dificuldade atual: " + Configuracao.dificuldade.capitalize()

func _on_botao_facil_pressed() -> void:
	Configuracao.dificuldade = "facil"
	_atualizar_label()

func _on_botao_medio_pressed() -> void:
	Configuracao.dificuldade = "medio"
	_atualizar_label()

func _on_botao_dificil_pressed() -> void:
	Configuracao.dificuldade = "dificil"
	_atualizar_label()

func _on_botao_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/UI/menu.tscn")
