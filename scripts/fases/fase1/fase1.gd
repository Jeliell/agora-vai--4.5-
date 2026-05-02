extends "res://scripts/fases/world_base.gd"

# Soma máxima por dificuldade (apenas no nível 1)
const SOMA_MAX_NIVEL1 = {
	"facil":   10,
	"medio":   15,
	"dificil": 20,
}

func _ready() -> void:
	fase_atual = 1
	operacao = "adicao"
	proxima_fase_cena = "res://scenes/fases/fase2/fase2.tscn"
	super._ready()

func configurar_nivel() -> void:
	respostas_com_digito_comum = 0

	match nivel_atual:
		1:
			numero_min = Configuracao.ajustar_numero(1)
			numero_max = Configuracao.ajustar_numero(9)
			variacao_errada_min = Configuracao.ajustar_variacao(1)
			variacao_errada_max = Configuracao.ajustar_variacao(3)
		2:
			numero_min = Configuracao.ajustar_numero(10)
			numero_max = Configuracao.ajustar_numero(49)
			variacao_errada_min = Configuracao.ajustar_variacao(3)
			variacao_errada_max = Configuracao.ajustar_variacao(9)
		3:
			numero_min = Configuracao.ajustar_numero(25)
			numero_max = Configuracao.ajustar_numero(75)
			variacao_errada_min = Configuracao.ajustar_variacao(5)
			variacao_errada_max = Configuracao.ajustar_variacao(15)
			respostas_com_digito_comum = 3

# Sobrescreve para limitar a soma no nível 1
func _nova_pergunta() -> void:
	if nivel_atual != 1:
		super._nova_pergunta()
		return

	var soma_max: int = SOMA_MAX_NIVEL1.get(Configuracao.dificuldade, 15)
	var a := 0
	var b := 0
	while a + b > soma_max or a + b == 0:
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
	var usados: Array[int] = [resposta_correta]

	for i in respostas.size():
		if i == idx_correto:
			respostas[i].definir(resposta_correta)
		else:
			var v := _valor_errado_simples(resposta_correta, usados)
			usados.append(v)
			respostas[i].definir(v)
