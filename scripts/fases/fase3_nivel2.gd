extends "res://scripts/fases/world_base.gd"

func _ready() -> void:
	fase_atual = 3
	nivel_atual = 2
	numero_min = 40
	numero_max = 80
	variacao_errada_min = 5
	variacao_errada_max = 12
	respostas_com_digito_comum = 2
	acertos_para_avançar = 5
	cena_reinicio = "res://scenes/fases/fase3/fase3_nivel1.tscn"
	proxima_cena = "res://scenes/fases/fase3/fase3_nivel3.tscn"
	super._ready()
