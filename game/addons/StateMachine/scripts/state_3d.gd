extends FSMState
class_name FSMState3D
## A [FSMState] that controls a [Node3D] owner.
##
## Identical to [FSMState] but exposes [member body] as a typed [Node3D] for
## autocomplete and static typing. Use with [FSMachine3D].

#region Public Members
## The controlled node, typed as [Node3D]. Backed by the machine-assigned parent.
var body: Node3D:
	get: return _parent as Node3D
#endregion
