extends FSMachine
class_name FSMachine3D
## A [FSMachine] whose controlled node is a [Node3D].
##
## Identical to [FSMachine] but exposes [member body] as a typed [Node3D].
## Pair with [FSMState3D] children.

#region Public Members
## The controlled node, typed as [Node3D].
var body: Node3D:
	get: return _parent as Node3D
#endregion
