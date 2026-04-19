extends Node2D

@export var numero_min: int = 1
@export var numero_max: int = 10
@export var variacao_errada_min: int = 1
@export var variacao_errada_max: int = 4

@onready var label_alvo: Label     = $LabelAlvo
@onready var label_pontos: Label   = $LabelPontos
@onready var label_feedback: Label = $LabelFeedback
@onready var cronometro            = $cornometro

var pontuacao: int = 0
var resposta_correta: int = 0
var _timer_feedback: float = 0.0
var _mostrar_feedback: bool = false

func _ready() -> void:
	add_to_group("mundo")
	# Conecta o sinal do cronômetro
	cronometro.tempo_esgotado.connect(_ao_fim_do_tempo)
	await get_tree().process_frame
	_nova_pergunta()

func _process(delta: float) -> void:
	if _mostrar_feedback:
		_timer_feedback -= delta
		if _timer_feedback <= 0:
			label_feedback.text = ""
			_mostrar_feedback = false

# Chamado pelo cronômetro ao zerar
func _ao_fim_do_tempo() -> void:
	var respostas := get_tree().get_nodes_in_group("resposta")

	# Procura qual área o jogador está dentro
	var resposta_atual: Node = null
	for r in respostas:
		if r.jogador_dentro:
			resposta_atual = r
			break

	if resposta_atual == null:
		# Jogador não estava em nenhuma área — considera errado
		_errou()
	elif resposta_atual.valor == resposta_correta:
		_acertou()
	else:
		_errou()

	# Reseta o jogador para a posição inicial
	var jogadores := get_tree().get_nodes_in_group("jogador")
	if not jogadores.is_empty():
		jogadores[0].resetar()

func _acertou() -> void:
	pontuacao += 1
	label_pontos.text = "Pontos: " + str(pontuacao)
	_exibir_feedback("✓ Correto!", Color(0.2, 0.85, 0.3))
	_nova_pergunta()

func _errou() -> void:
	_exibir_feedback("✗ Errado!", Color(0.9, 0.15, 0.15))
	_nova_pergunta()

func _nova_pergunta() -> void:
	var a := randi_range(numero_min, numero_max)
	var b := randi_range(numero_min, numero_max)
	resposta_correta = a + b
	label_alvo.text = str(a) + " + " + str(b) + " = ?"

	var respostas := get_tree().get_nodes_in_group("resposta")
	if respostas.is_empty():
		push_warning("Nenhum nó no grupo 'resposta' encontrado!")
		return

	var idx_correto := randi() % respostas.size()
	for i in respostas.size():
		if i == idx_correto:
			respostas[i].definir(resposta_correta)
		else:
			respostas[i].definir(_valor_errado(resposta_correta, respostas, i))

func _valor_errado(correto: int, respostas: Array, idx_atual: int) -> int:
	var usados: Array[int] = [correto]
	for i in idx_atual:
		usados.append(respostas[i].valor)

	for _tentativa in 20:
		var sinal := 1 if randi() % 2 == 0 else -1
		var offset := randi_range(variacao_errada_min, variacao_errada_max)
		var candidato := correto + sinal * offset
		if candidato > 0 and candidato not in usados:
			return candidato

	return correto + idx_atual + 1

func _exibir_feedback(texto: String, cor: Color) -> void:
	label_feedback.text = texto
	label_feedback.add_theme_color_override("font_color", cor)
	_timer_feedback = 1.5
	_mostrar_feedback = true
