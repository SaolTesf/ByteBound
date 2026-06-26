@tool
extends EditorPlugin

const FSMachineScript = preload("uid://cvvn3nnoao64s")
const FSMStateScript = preload("uid://dmkapvvb3uge2")
const FSMachine2DScript = preload("res://addons/state_machine/scripts/state_machine_2d.gd")
const FSMachine3DScript = preload("res://addons/state_machine/scripts/state_machine_3d.gd")
const FSMState2DScript = preload("res://addons/state_machine/scripts/state_2d.gd")
const FSMState3DScript = preload("res://addons/state_machine/scripts/state_3d.gd")


func _enable_plugin() -> void:
	# Add autoloads here.
	pass


func _disable_plugin() -> void:
	# Remove autoloads here.
	pass


func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	add_custom_type("FSMachine", "IFSMachine", FSMachineScript, null)
	add_custom_type("FSMachine2D", "FSMachine", FSMachine2DScript, null)
	add_custom_type("FSMachine3D", "FSMachine", FSMachine3DScript, null)
	add_custom_type("FSMState", "IFSMState", FSMStateScript, null)
	add_custom_type("FSMState2D", "FSMState", FSMState2DScript, null)
	add_custom_type("FSMState3D", "FSMState", FSMState3DScript, null)


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	remove_custom_type("FSMachine")
	remove_custom_type("FSMachine2D")
	remove_custom_type("FSMachine3D")
	remove_custom_type("FSMState")
	remove_custom_type("FSMState2D")
	remove_custom_type("FSMState3D")
