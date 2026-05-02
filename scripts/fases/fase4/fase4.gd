extends "res://scripts/fases/world_base.gd"

func _ready() -> void:
	fase_atual = 4
	operacao = "divisao"
	proxima_fase_cena = ""  # fim do jogo
	resultado_max = 10
	super._ready()

func configurar_nivel() -> void:
	match nivel_atual:
		1:
			numero_min = 2
			numero_max = 5
			variacao_errada_min = Configuracao.ajustar_variacao(1)
			variacao_errada_max = Configuracao.ajustar_variacao(3)
			respostas_com_digito_comum = 0
		2:
			numero_min = 2
			numero_max = 9
			variacao_errada_min = Configuracao.ajustar_variacao(2)
			variacao_errada_max = Configuracao.ajustar_variacao(5)
			respostas_com_digito_comum = 2
		3:
			numero_min = 2
			numero_max = 10
			variacao_errada_min = Configuracao.ajustar_variacao(2)
			variacao_errada_max = Configuracao.ajustar_variacao(6)
			respostas_com_digito_comum = 3
