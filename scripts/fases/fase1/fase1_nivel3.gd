extends "res://scripts/fases/world_base.gd"

func _ready() -> void:
	fase_atual = 1
	nivel_atual = 3
	numero_min = 25
	numero_max = 75
	variacao_errada_min = 5
	variacao_errada_max = 15
	respostas_com_digito_comum = 3
	acertos_para_avançar = 5
	cena_reinicio = "res://scenes/fases/fase1/fase1_nivel1.tscn"
	proxima_cena = "res://scenes/fases/fase2/fase2_nivel1.tscn"
	super._ready()
