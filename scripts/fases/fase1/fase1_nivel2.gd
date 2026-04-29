extends "res://scripts/fases/world_base.gd"

func _ready() -> void:
	fase_atual = 1
	nivel_atual = 2
	numero_min = 10
	numero_max = 49
	variacao_errada_min = 3
	variacao_errada_max = 9
	respostas_com_digito_comum = 0
	acertos_para_avançar = 5
	cena_reinicio = "res://scenes/fases/fase1/fase1_nivel1.tscn"
	proxima_cena = "res://scenes/fases/fase1/fase1_nivel3.tscn"
	super._ready()
