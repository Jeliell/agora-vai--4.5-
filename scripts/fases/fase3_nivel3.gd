extends "res://scripts/fases/world_base.gd"

# Nível 3 — tabuadas completas de 1 a 10
# Resultado máximo: 10 x 10 = 100
func _ready() -> void:
	fase_atual = 3
	nivel_atual = 3
	operacao = "multiplicacao"
	numero_min = 1
	numero_max = 10
	fator_fixo = -1
	variacao_errada_min = 3
	variacao_errada_max = 8
	respostas_com_digito_comum = 3
	acertos_para_avançar = 5
	cena_reinicio = "res://scenes/fases/fase3/fase3_nivel1.tscn"
	proxima_cena = "res://scenes/fases/fase4/fase4_nivel1.tscn"
	super._ready()
