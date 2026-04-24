extends "res://scripts/fases/world_base.gd"

func _ready() -> void:
	fase_atual = 2
	nivel_atual = 3
	operacao = "subtracao"
	usar_stamina = true
	numero_min = 25
	numero_max = 99
	variacao_errada_min = 5
	variacao_errada_max = 15
	respostas_com_digito_comum = 3
	acertos_para_avançar = 5
	cena_reinicio = "res://scenes/fases/fase2/fase2_nivel1.tscn"
	proxima_cena = "res://scenes/fases/fase3/fase3_nivel1.tscn"
	super._ready()
