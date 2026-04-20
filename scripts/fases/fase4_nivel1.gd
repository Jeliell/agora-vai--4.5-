extends "res://scripts/fases/world_base.gd"

func _ready() -> void:
	fase_atual = 4
	nivel_atual = 1
	numero_min = 30
	numero_max = 70
	variacao_errada_min = 4
	variacao_errada_max = 10
	respostas_com_digito_comum = 2
	acertos_para_avançar = 5
	cena_reinicio = "res://scenes/fases/fase4/fase4_nivel1.tscn"
	proxima_cena = "res://scenes/fases/fase4/fase4_nivel2.tscn"
	super._ready()
