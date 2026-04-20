extends "res://scripts/fases/world_base.gd"

func _ready() -> void:
	fase_atual = 3
	nivel_atual = 1
	numero_min = 20
	numero_max = 50
	variacao_errada_min = 3
	variacao_errada_max = 7
	respostas_com_digito_comum = 0
	acertos_para_avançar = 5
	cena_reinicio = "res://scenes/fases/fase3/fase3_nivel1.tscn"
	proxima_cena = "res://scenes/fases/fase3/fase3_nivel2.tscn"
	super._ready()
