extends "res://scripts/fases/world_base.gd"

func _ready() -> void:
	fase_atual = 2
	operacao = "subtracao"
	usar_stamina = true
	proxima_fase_cena = "res://scenes/fases/fase3/fase3.tscn"
	super._ready()

func configurar_nivel() -> void:
	match nivel_atual:
		1:
			numero_min = Configuracao.ajustar_numero(1)
			numero_max = Configuracao.ajustar_numero(10)
			variacao_errada_min = Configuracao.ajustar_variacao(1)
			variacao_errada_max = Configuracao.ajustar_variacao(3)
			respostas_com_digito_comum = 0
		2:
			numero_min = Configuracao.ajustar_numero(10)
			numero_max = Configuracao.ajustar_numero(50)
			variacao_errada_min = Configuracao.ajustar_variacao(3)
			variacao_errada_max = Configuracao.ajustar_variacao(9)
			respostas_com_digito_comum = 2
		3:
			numero_min = Configuracao.ajustar_numero(25)
			numero_max = Configuracao.ajustar_numero(99)
			variacao_errada_min = Configuracao.ajustar_variacao(5)
			variacao_errada_max = Configuracao.ajustar_variacao(15)
			respostas_com_digito_comum = 3
