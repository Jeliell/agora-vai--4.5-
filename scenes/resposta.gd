extends Area2D

var valor: int = 0
var jogador_dentro: bool = false

@onready var label: Label = $Label

func _ready() -> void:
	add_to_group("resposta")
	body_entered.connect(_ao_entrar)
	body_exited.connect(_ao_sair)

func definir(v: int) -> void:
	valor = v
	label.text = str(v)

func _ao_entrar(corpo: Node2D) -> void:
	if corpo.is_in_group("jogador"):
		jogador_dentro = true

func _ao_sair(corpo: Node2D) -> void:
	if corpo.is_in_group("jogador"):
		jogador_dentro = false
