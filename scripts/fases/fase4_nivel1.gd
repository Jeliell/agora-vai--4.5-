extends "res://scripts/fases/world_base.gd"

# Nível 1 — divisões simples, resultados de 1 a 5, divisor de 2 a 5
# Exemplo: 10 ÷ 2 = 5, 12 ÷ 3 = 4
func _ready() -> void:
	fase_atual = 4
	nivel_atual = 1
	operacao = "divisao"
	numero_min = 2   # divisor mínimo
	numero_max = 5   # divisor máximo
	variacao_errada_min = 1
	variacao_errada_max = 3
	respostas_com_digito_comum = 0
	acertos_para_avançar = 5
	cena_reinicio = "res://scenes/fases/fase4/fase4_nivel1.tscn"
	proxima_cena = "res://scenes/fases/fase4/fase4_nivel2.tscn"
	super._ready()
