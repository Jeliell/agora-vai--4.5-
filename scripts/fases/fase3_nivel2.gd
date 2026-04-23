extends "res://scripts/fases/world_base.gd"

# Nível 2 — tabuadas de 1 a 5, fator variando de 1 a 10
# Resultado máximo: 5 x 10 = 50
func _ready() -> void:
	fase_atual = 3
	nivel_atual = 2
	operacao = "multiplicacao"
	numero_min = 1
	numero_max = 10
	fator_fixo = -1
	variacao_errada_min = 2
	variacao_errada_max = 6
	respostas_com_digito_comum = 2
	acertos_para_avançar = 5
	cena_reinicio = "res://scenes/fases/fase3/fase3_nivel1.tscn"
	proxima_cena = "res://scenes/fases/fase3/fase3_nivel3.tscn"
	super._ready()
