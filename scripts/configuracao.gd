extends Node

# Singleton - registra em Projeto → Configurações → Autoload com nome "Configuracao"

# Dificuldade selecionada
var dificuldade: String = "medio"

# Estado da progressão de fase/nível
var nivel_atual_da_fase: int = 1
var fase_atual: int = 1
var proxima_fase_cena: String = ""
var cena_fase_atual: String = ""

# Tempos por dificuldade
const TEMPOS = {
	"facil":   30.0,
	"medio":   20.0,
	"dificil": 10.0,
}

const VARIACAO_OFFSET = {
	"facil":   2,
	"medio":   0,
	"dificil": -1,
}

const NUMERO_FATOR = {
	"facil":   0.7,
	"medio":   1.0,
	"dificil": 1.3,
}

func get_tempo() -> float:
	return TEMPOS.get(dificuldade, 20.0)

func ajustar_variacao(valor: int) -> int:
	return max(1, valor + VARIACAO_OFFSET.get(dificuldade, 0))

func ajustar_numero(valor: int) -> int:
	return max(1, int(valor * NUMERO_FATOR.get(dificuldade, 1.0)))

# Reseta a progressão (chamado ao voltar ao menu ou começar do zero)
func resetar_progresso() -> void:
	nivel_atual_da_fase = 1
