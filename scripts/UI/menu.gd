extends Node2D

@onready var garca_patrulheira = $GarcaMenu
@onready var ponto_origem = $PontoOrigem
var resgatando: bool = false

func _on_zona_de_queda_body_entered(body: Node2D) -> void:
    if body.is_in_group("player") and not resgatando:
        resgatando = true
        var pos_segura = ponto_origem.global_position
        body.velocity = Vector2.ZERO
        body.set_physics_process(false)
        garca_patrulheira.iniciar_resgate(body, pos_segura)
        
        # Prevenção: Reseta a variável após 3 segundos para a garça poder resgatar de novo
        await get_tree().create_timer(3.0).timeout
        resgatando = false
