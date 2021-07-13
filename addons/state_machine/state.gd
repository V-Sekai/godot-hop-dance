extends Node

signal finished(next_state_name)

var state_machine = null :
	set = set_state_machine



func set_state_machine(p_state_machine) -> void:
	state_machine = p_state_machine


func enter() -> void:
	pass


func update(_delta: float) -> void:
	pass

func exit() -> void:
	pass


func change_state(p_state_name: String) -> void:
	emit_signal("finished", p_state_name)
