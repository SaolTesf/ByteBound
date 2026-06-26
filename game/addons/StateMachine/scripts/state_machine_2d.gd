extends FSMachine
class_name FSMachine2D
## A [FSMachine] whose controlled node is a [Node2D].
##
## Identical to [FSMachine] but exposes [member body] as a typed [Node2D].
## Pair with [FSMState2D] children.

#region Public Members
## The controlled node, typed as [Node2D].
var body: Node2D:
	get: return _parent as Node2D
#endregion
