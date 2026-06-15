extends Node2D

# Dados da cutscene a exibir — normalmente vem do Configuracao
@export var dados: CutsceneData = null

@onready var label_texto: Label   = $CaixaDialogo/LabelTexto
@onready var label_nome: Label    = $CaixaDialogo/LabelNome
@onready var retrato_pato: Sprite2D  = $RetratoPato
@onready var retrato_garca: Sprite2D = $RetratoGarca

var _indice: int = 0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	# Se veio dados pelo singleton, usa eles (sobrescreve o @export)
	if Configuracao.cutscene_atual != null:
		dados = Configuracao.cutscene_atual

	if dados == null or dados.falas.is_empty():
		_terminar()
		return

	_mostrar_fala()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") or \
	   (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT):
		_avancar()

func _avancar() -> void:
	_indice += 1
	if _indice >= dados.falas.size():
		_terminar()
	else:
		_mostrar_fala()

func _mostrar_fala() -> void:
	var fala: Fala = dados.falas[_indice]
	label_texto.text = fala.texto

	# Destaca o personagem que está falando
	if fala.personagem == "pato":
		label_nome.text = "Pato"
		retrato_pato.modulate = Color(1, 1, 1, 1)         # ativo
		retrato_garca.modulate = Color(0.4, 0.4, 0.4, 1)  # apagado
	else:
		label_nome.text = "Garça"
		retrato_garca.modulate = Color(1, 1, 1, 1)
		retrato_pato.modulate = Color(0.4, 0.4, 0.4, 1)

func _terminar() -> void:
	var destino: String = dados.cena_seguinte if dados else ""
	if destino == "":
		Configuracao.resetar_progresso()
		get_tree().change_scene_to_file("res://scenes/UI/menu.tscn")
	else:
		get_tree().change_scene_to_file(destino)
