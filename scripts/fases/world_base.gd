extends Node2D

@export var numero_min: int = 1
@export var numero_max: int = 10
@export var variacao_errada_min: int = 1
@export var variacao_errada_max: int = 4
@export var vidas_iniciais: int = 3
@export var acertos_para_avançar: int = 5
@export var proxima_cena: String = ""
@export var cena_reinicio: String = ""
@export var respostas_com_digito_comum: int = 0
@export var fase_atual: int = 1
@export var nivel_atual: int = 1

# "adicao" ou "subtracao"
@export var operacao: String = "adicao"

@onready var label_alvo: Label     = $HUD/LabelAlvo
@onready var label_pontos: Label   = $HUD/LabelPontos
@onready var label_feedback: Label = $HUD/LabelFeedback
@onready var label_vidas: Label    = $HUD/LabelVidas
@onready var label_fase: Label     = $HUD/LabelFase
@onready var cronometro            = $HUD/cornometro

var pontuacao: int = 0
var acertos: int = 0
var vidas: int = 3
var resposta_correta: int = 0
var _timer_feedback: float = 0.0
var _mostrar_feedback: bool = false

func _ready() -> void:
	add_to_group("mundo")
	vidas = vidas_iniciais
	_atualizar_vidas()
	_atualizar_fase()
	cronometro.tempo_esgotado.connect(_ao_fim_do_tempo)
	await get_tree().process_frame
	_nova_pergunta()

func _process(delta: float) -> void:
	if _mostrar_feedback:
		_timer_feedback -= delta
		if _timer_feedback <= 0:
			label_feedback.text = ""
			_mostrar_feedback = false

func _ao_fim_do_tempo() -> void:
	var respostas := get_tree().get_nodes_in_group("resposta")
	var resposta_atual: Node = null
	for r in respostas:
		if r.jogador_dentro:
			resposta_atual = r
			break

	if resposta_atual == null:
		_errou()
	elif resposta_atual.valor == resposta_correta:
		_acertou()
	else:
		_errou()

	var jogadores := get_tree().get_nodes_in_group("jogador")
	if not jogadores.is_empty():
		jogadores[0].resetar()

func _acertou() -> void:
	pontuacao += 1
	acertos += 1
	label_pontos.text = "Pontos: " + str(pontuacao)
	_exibir_feedback("Correto!", Color(0.2, 0.85, 0.3))

	if acertos >= acertos_para_avançar:
		await get_tree().create_timer(1.0).timeout
		get_tree().set_meta("proxima_cena", proxima_cena)
		get_tree().change_scene_to_file("res://scenes/ui/fase_completa.tscn")
		return

	_nova_pergunta()

func _errou() -> void:
	vidas -= 1
	_atualizar_vidas()
	_exibir_feedback("Errado!", Color(0.9, 0.15, 0.15))

	if vidas <= 0:
		await get_tree().create_timer(1.0).timeout
		get_tree().set_meta("cena_reinicio", cena_reinicio)
		get_tree().change_scene_to_file("res://scenes/ui/game_over.tscn")
		return

	_nova_pergunta()

func _atualizar_vidas() -> void:
	label_vidas.text = "♥ ".repeat(vidas)

func _atualizar_fase() -> void:
	label_fase.text = "Fase " + str(fase_atual) + "  Nível " + str(nivel_atual)

func _nova_pergunta() -> void:
	var a := 0
	var b := 0

	if operacao == "subtracao":
		# Garante que a >= b para o resultado nunca ser negativo
		a = randi_range(numero_min, numero_max)
		b = randi_range(numero_min, a)  # b nunca maior que a
		resposta_correta = a - b
		# Evita resultado zero — pouco didático
		while resposta_correta == 0:
			b = randi_range(numero_min, a - 1)
			resposta_correta = a - b
		label_alvo.text = str(a) + " - " + str(b) + " = ?"
	else:
		a = randi_range(numero_min, numero_max)
		b = randi_range(numero_min, numero_max)
		resposta_correta = a + b
		label_alvo.text = str(a) + " + " + str(b) + " = ?"

	var respostas := get_tree().get_nodes_in_group("resposta")
	if respostas.is_empty():
		push_warning("Nenhum nó no grupo 'resposta' encontrado!")
		return

	var indices: Array = range(respostas.size())
	indices.shuffle()

	var idx_correto: int = indices[0]
	var indices_comum := indices.slice(1, 1 + respostas_com_digito_comum)

	var usados: Array[int] = [resposta_correta]

	for i in respostas.size():
		if i == idx_correto:
			respostas[i].definir(resposta_correta)
		elif i in indices_comum:
			var v := _valor_com_digito_comum(resposta_correta, usados)
			usados.append(v)
			respostas[i].definir(v)
		else:
			var v := _valor_errado_simples(resposta_correta, usados)
			usados.append(v)
			respostas[i].definir(v)

func _tem_digito_comum(a: int, b: int) -> bool:
	var digitos_a := str(a)
	var digitos_b := str(b)
	for c in digitos_a:
		if c in digitos_b:
			return true
	return false

func _valor_com_digito_comum(correto: int, usados: Array) -> int:
	for _tentativa in 40:
		var sinal := 1 if randi() % 2 == 0 else -1
		var offset := randi_range(variacao_errada_min, variacao_errada_max)
		var candidato := correto + sinal * offset
		if candidato > 0 and candidato not in usados and _tem_digito_comum(candidato, correto):
			return candidato

	var base := (correto / 10) * 10
	for d in range(10):
		var candidato := base + d
		if candidato > 0 and candidato != correto and candidato not in usados:
			return candidato

	return correto + 1

func _valor_errado_simples(correto: int, usados: Array) -> int:
	for _tentativa in 20:
		var sinal := 1 if randi() % 2 == 0 else -1
		var offset := randi_range(variacao_errada_min, variacao_errada_max)
		var candidato := correto + sinal * offset
		if candidato > 0 and candidato not in usados:
			return candidato

	return correto + usados.size()

func _exibir_feedback(texto: String, cor: Color) -> void:
	label_feedback.text = texto
	label_feedback.add_theme_color_override("font_color", cor)
	_timer_feedback = 1.5
	_mostrar_feedback = true
