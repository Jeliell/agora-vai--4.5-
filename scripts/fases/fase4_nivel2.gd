extends "res://scripts/fases/world_base.gd"

func _ready() -> void:
	fase_atual = 4
	nivel_atual = 2
	numero_min = 50
	numero_max = 90
	variacao_errada_min = 6
	variacao_errada_max = 14
	respostas_com_digito_comum = 3
	acertos_para_avançar = 5
	cena_reinicio = "res://scenes/fases/fase4/fase4_nivel1.tscn"
	proxima_cena = "res://scenes/fases/fase4/fase4_nivel3.tscn"
	super._ready()
