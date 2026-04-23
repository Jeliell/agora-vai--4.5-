extends "res://scripts/fases/world_base.gd"

# Nível 2 — divisores de 2 a 9, resultados de 1 a 9
# Exemplo: 56 ÷ 7 = 8, 36 ÷ 6 = 6
func _ready() -> void:
	fase_atual = 4
	nivel_atual = 2
	operacao = "divisao"
	numero_min = 2   # divisor mínimo
	numero_max = 9   # divisor máximo
	variacao_errada_min = 2
	variacao_errada_max = 5
	respostas_com_digito_comum = 2
	acertos_para_avançar = 5
	cena_reinicio = "res://scenes/fases/fase4/fase4_nivel1.tscn"
	proxima_cena = "res://scenes/fases/fase4/fase4_nivel3.tscn"
	super._ready()
