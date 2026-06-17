extends Node2D

# ── Configurações ajustáveis pelos scripts de fase ──
@export var numero_min: int = 1
@export var numero_max: int = 10
@export var variacao_errada_min: int = 1
@export var variacao_errada_max: int = 4
@export var vidas_iniciais: int = 3
@export var acertos_para_avançar: int = 5
@export var respostas_com_digito_comum: int = 0
@export var operacao: String = "adicao"
@export var fator_fixo: int = -1
@export var resultado_max: int = 10
@export var usar_stamina: bool = false

@export var fase_atual: int = 1
@export var proxima_fase_cena: String = ""

var nivel_atual: int = 1

@onready var label_alvo: Label     = $HUD/LabelAlvo
@onready var label_pontos: Label   = $HUD/LabelPontos
@onready var label_feedback: Label = $HUD/LabelFeedback
@onready var label_vidas: Label    = $HUD/LabelVidas
@onready var label_fase: Label     = $HUD/LabelFase
@onready var cronometro            = $HUD/cornometro
@onready var barra_stamina: ProgressBar = $HUD/BarraStamina
@onready var pause = $Pause
@onready var popup_nivel = $NivelCompleto
@onready var popup_fase  = $FaseCompleta

var pontuacao: int = 0
var acertos: int = 0
var vidas: int = 3
var resposta_correta: int = 0
var _timer_feedback: float = 0.0
var _mostrar_feedback: bool = false

func _ready() -> void:
	add_to_group("mundo")
	vidas = vidas_iniciais

	nivel_atual = Configuracao.nivel_atual_da_fase
	configurar_nivel()

	_atualizar_vidas()
	_atualizar_fase()
	cronometro.tempo_esgotado.connect(_ao_fim_do_tempo)

	# Conecta o botão de pause do HUD (se existir)
	var botao_pause = $HUD.get_node_or_null("BotaoPause")
	if botao_pause:
		botao_pause.pressed.connect(_on_botao_pause_pressed)

	# Garante que os pop-ups começam escondidos
	if popup_nivel:
		popup_nivel.visible = false
	if popup_fase:
		popup_fase.visible = false

	await get_tree().process_frame
	var jogadores := get_tree().get_nodes_in_group("jogador")
	if not jogadores.is_empty():
		var player = jogadores[0]
		player.stamina_ativa = usar_stamina
		player.barra_stamina = barra_stamina
		player.stamina = player.stamina_max

	barra_stamina.visible = usar_stamina
	_nova_pergunta()

func configurar_nivel() -> void:
	pass

func _process(delta: float) -> void:
	if _mostrar_feedback:
		_timer_feedback -= delta
		if _timer_feedback <= 0:
			label_feedback.text = ""
			_mostrar_feedback = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_alternar_pause()
	if Configuracao.debug_ativo:
		_processar_debug(event)

func _processar_debug(event: InputEvent) -> void:
	if not event is InputEventKey or not event.pressed or event.echo:
		return

	match event.keycode:
		KEY_F1:
			vidas -= 1
			_atualizar_vidas()
			if vidas <= 0:
				_errou()
		KEY_F2:
			vidas += 1
			_atualizar_vidas()
		KEY_F3:
			acertos = acertos_para_avançar
			_avancar()
		KEY_F4:
			Configuracao.fase_atual = fase_atual
			Configuracao.proxima_fase_cena = proxima_fase_cena
			Configuracao.nivel_atual_da_fase = 1
			if proxima_fase_cena != "":
				get_tree().change_scene_to_file(proxima_fase_cena)
		KEY_F5:
			var fase_anterior: int = fase_atual - 1
			if fase_anterior >= 1:
				Configuracao.nivel_atual_da_fase = 1
				get_tree().change_scene_to_file("res://scenes/fases/fase" + str(fase_anterior) + "/fase" + str(fase_anterior) + ".tscn")
		KEY_F6:
			Configuracao.nivel_atual_da_fase = nivel_atual
			get_tree().reload_current_scene()
		KEY_F7:
			_mudar_dificuldade(1)
		KEY_F8:
			_mudar_dificuldade(-1)
		KEY_F9:
			cronometro.tempo_travado = not cronometro.tempo_travado

func _mudar_dificuldade(direcao: int) -> void:
	var ordem := ["facil", "medio", "dificil"]
	var atual: int = ordem.find(Configuracao.dificuldade)
	var novo: int = clamp(atual + direcao, 0, ordem.size() - 1)
	Configuracao.dificuldade = ordem[novo]

func _alternar_pause() -> void:
	# Não permite pausar se um pop-up de fim já está aberto
	if (popup_nivel and popup_nivel.visible) or (popup_fase and popup_fase.visible):
		return
	if pause.visible:
		pause.fechar()
	else:
		pause.abrir()

func _on_botao_pause_pressed() -> void:
	pause.abrir()

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
		_avancar()
		return

	_nova_pergunta()

func _avancar() -> void:
	Configuracao.fase_atual = fase_atual
	Configuracao.proxima_fase_cena = proxima_fase_cena

	if nivel_atual < 3:
		# Próximo nível — abre o pop-up overlay (sem trocar de cena)
		Configuracao.nivel_atual_da_fase = nivel_atual + 1
		popup_nivel.abrir()
	else:
		# Completou a fase — abre o pop-up de fase completa
		Configuracao.nivel_atual_da_fase = 1
		popup_fase.abrir()

func _errou() -> void:
	vidas -= 1
	_atualizar_vidas()
	_exibir_feedback("Errado!", Color(0.9, 0.15, 0.15))

	if vidas <= 0:
		await get_tree().create_timer(1.0).timeout
		Configuracao.nivel_atual_da_fase = 1
		Configuracao.cena_fase_atual = scene_file_path
		get_tree().change_scene_to_file("res://scenes/UI/game_over.tscn")
		return

	_nova_pergunta()

func _atualizar_vidas() -> void:
	label_vidas.text = "♥ ".repeat(vidas)

func _atualizar_fase() -> void:
	label_fase.text = "Fase " + str(fase_atual) + "  Nível " + str(nivel_atual)

func _nova_pergunta() -> void:
	var a := 0
	var b := 0

	match operacao:
		"subtracao":
			a = randi_range(numero_min, numero_max)
			b = randi_range(numero_min, a)
			resposta_correta = a - b
			while resposta_correta == 0:
				b = randi_range(numero_min, a - 1)
				resposta_correta = a - b
			label_alvo.text = str(a) + " - " + str(b) + " = ?"

		"multiplicacao":
			if fator_fixo >= 1:
				a = fator_fixo
				b = randi_range(numero_min, numero_max)
			else:
				a = randi_range(numero_min, numero_max)
				b = randi_range(numero_min, numero_max)
			if a > b:
				var tmp = a; a = b; b = tmp
			resposta_correta = a * b
			label_alvo.text = str(a) + " x " + str(b) + " = ?"

		"divisao":
			var quociente := randi_range(1, resultado_max)
			var divisor   := randi_range(numero_min, numero_max)
			var dividendo := quociente * divisor
			resposta_correta = quociente
			label_alvo.text = str(dividendo) + " ÷ " + str(divisor) + " = ?"

		_:
			a = randi_range(numero_min, numero_max)
			b = randi_range(numero_min, numero_max)
			resposta_correta = a + b
			label_alvo.text = str(a) + " + " + str(b) + " = ?"

	var respostas := get_tree().get_nodes_in_group("resposta")
	if respostas.is_empty():
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

	var base: int = (correto / 10) * 10
	for d in range(10):
		var candidato := base + d
		if candidato > 0 and candidato != correto and candidato not in usados:
			return candidato

	return correto + 1

func _valor_errado_simples(correto: int, usados: Array) -> int:
	if operacao == "multiplicacao":
		for _tentativa in 20:
			var fa := randi_range(numero_min, numero_max)
			var fb := randi_range(numero_min, numero_max)
			var candidato := fa * fb
			if candidato > 0 and candidato != correto and candidato not in usados:
				return candidato

	if operacao == "divisao":
		for _tentativa in 20:
			var candidato := randi_range(1, resultado_max)
			if candidato != correto and candidato not in usados:
				return candidato

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
