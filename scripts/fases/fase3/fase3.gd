extends "res://scripts/fases/world_base.gd"

func _ready() -> void:
	fase_atual = 3
	operacao = "multiplicacao"
	proxima_fase_cena = "res://scenes/fases/fase4/fase4.tscn"
	super._ready()

func configurar_nivel() -> void:
	# Multiplicação não escala números (mantém contexto da tabuada)
	fator_fixo = -1
	match nivel_atual:
		1:
			numero_min = 1
			numero_max = 5
			variacao_errada_min = Configuracao.ajustar_variacao(1)
			variacao_errada_max = Configuracao.ajustar_variacao(4)
			respostas_com_digito_comum = 0
		2:
			numero_min = 1
			numero_max = 10
			variacao_errada_min = Configuracao.ajustar_variacao(2)
			variacao_errada_max = Configuracao.ajustar_variacao(6)
			respostas_com_digito_comum = 2
		3:
			numero_min = 1
			numero_max = 10
			variacao_errada_min = Configuracao.ajustar_variacao(3)
			variacao_errada_max = Configuracao.ajustar_variacao(8)
			respostas_com_digito_comum = 3
