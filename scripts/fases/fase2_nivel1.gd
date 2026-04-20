extends "res://scripts/fases/world_base.gd"

func _ready() -> void:
	fase_atual = 2
	nivel_atual = 1
	operacao = "subtracao"
	numero_min = 1
	numero_max = 10        # ex: 9 - 3 = 6, resultado máx 9
	variacao_errada_min = 1
	variacao_errada_max = 3
	respostas_com_digito_comum = 0
	acertos_para_avançar = 5
	cena_reinicio = "res://scenes/fases/fase2/fase2_nivel1.tscn"
	proxima_cena = "res://scenes/fases/fase2/fase2_nivel2.tscn"
	super._ready()
