extends "res://scripts/fases/world_base.gd"

func _ready() -> void:
	fase_atual = 4
	nivel_atual = 3
	numero_min = 70
	numero_max = 99
	variacao_errada_min = 8
	variacao_errada_max = 18
	respostas_com_digito_comum = 4
	acertos_para_avançar = 5
	cena_reinicio = "res://scenes/fases/fase4/fase4_nivel1.tscn"
	proxima_cena = "res://scenes/fases/"
	super._ready()
