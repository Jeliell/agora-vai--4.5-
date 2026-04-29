extends "res://scripts/fases/world_base.gd"

# Nível 1 — tabuadas do 2 e do 3, fator variando de 1 a 5
# Resultado máximo: 3 x 5 = 15
func _ready() -> void:
	fase_atual = 3
	nivel_atual = 1
	operacao = "multiplicacao"
	numero_min = 1
	numero_max = 5
	fator_fixo = -1          # ambos aleatórios dentro de 1-5
	variacao_errada_min = 1
	variacao_errada_max = 4
	respostas_com_digito_comum = 0
	acertos_para_avançar = 5
	cena_reinicio = "res://scenes/fases/fase3/fase3_nivel1.tscn"
	proxima_cena = "res://scenes/fases/fase3/fase3_nivel2.tscn"
	super._ready()
