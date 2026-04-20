extends "res://scripts/fases/world_base.gd"

func _ready() -> void:
	fase_atual = 2
	nivel_atual = 2
	operacao = "subtracao"
	numero_min = 10
	numero_max = 50        # ex: 47 - 12 = 35, resultado máx 49
	variacao_errada_min = 3
	variacao_errada_max = 9
	respostas_com_digito_comum = 2
	acertos_para_avançar = 5
	cena_reinicio = "res://scenes/fases/fase2/fase2_nivel1.tscn"
	proxima_cena = "res://scenes/fases/fase2/fase2_nivel3.tscn"
	super._ready()
