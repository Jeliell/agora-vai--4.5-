extends Node2D

@onready var label_atual: Label = $Dificuldade
@onready var garca_patrulheira = $GarcaMenu
@onready var ponto_origem = $PontoOrigem
@onready var botao_jogar = $BotaoJogar
var resgatando: bool = false

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
