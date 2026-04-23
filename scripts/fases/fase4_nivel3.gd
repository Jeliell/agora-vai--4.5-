extends "res://scripts/fases/world_base.gd"

# Nível 3 — tabuadas completas, divisores de 2 a 10, resultados de 1 a 10
# Exemplo: 100 ÷ 10 = 10, 72 ÷ 8 = 9
func _ready() -> void:
	fase_atual = 4
	nivel_atual = 3
	operacao = "divisao"
	numero_min = 2    # divisor mínimo
	numero_max = 10   # divisor máximo
	variacao_errada_min = 2
	variacao_errada_max = 6
	respostas_com_digito_comum = 3
	acertos_para_avançar = 5
	cena_reinicio = "res://scenes/fases/fase4/fase4_nivel1.tscn"
	proxima_cena = ""  # fim do jogo
	super._ready()
