extends "res://scripts/fases/world_base.gd"

func _ready() -> void:
	fase_atual = 1
	nivel_atual = 1
	numero_min = 1
	numero_max = 9
	variacao_errada_min = 1
	variacao_errada_max = 3
	respostas_com_digito_comum = 0
	acertos_para_avançar = 5
	cena_reinicio = "res://scenes/fases/fase1/fase1_nivel1.tscn"
	proxima_cena = "res://scenes/fases/fase1/fase1_nivel2.tscn"
	super._ready()
