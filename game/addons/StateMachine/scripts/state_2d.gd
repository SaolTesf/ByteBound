extends FSMState
class_name FSMState2D
## A [FSMState] that controls a [Node2D] owner.
##
## Identical to [FSMState] but exposes [member body] as a typed [Node2D] for
## autocomplete and static typing. Use with [FSMachine2D].

#region Public Members
## The controlled node, typed as [Node2D]. Backed by the machine-assigned parent.
var body: Node2D:
	get: return _parent as Node2D
#endregion
