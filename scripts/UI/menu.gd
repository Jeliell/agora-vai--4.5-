extends Node2D

@onready var garca_patrulheira = $GarcaMenu
@onready var ponto_origem = $PontoOrigem
@onready var botao_jogar = $BotaoJogar
var resgatando: bool = false

func _on_zona_de_queda_body_entered(body: Node2D) -> void:
    print("Algo caiu na zona de queda: ", body.name) # Print para teste!
    
    if body.name == "player" and not resgatando:
        resgatando = true
        var pos_segura = ponto_origem.global_position
        body.velocity = Vector2.ZERO
        body.set_physics_process(false)
        garca_patrulheira.iniciar_resgate(body, pos_segura)

func _on_zona_de_queda_area_entered(area: Area2D) -> void:
    pass
