extends Node
## Global signal bus used to decouple nodes.
##
## Instead of holding direct references to each other, a node emits a signal here
## and any interested node connects to it. Keep this limited to genuinely
## cross-cutting events; component-local events belong on the component itself.

#region Collectables
## The player collected the key; objects gated on the key (e.g. the exit door)
## react to this.
signal key_collected
signal movable_box_hit(box: CharacterBody2D)
#endregion

#region Buttons -> Lasers
## A pedestal of [param channel] was permanently activated.
signal pedestal_activated(channel: Globals.Channel)
## A pressure plate of [param channel] became active (something is on it).
signal pressure_plate_activated(channel: Globals.Channel)
## A pressure plate of [param channel] became inactive (stepped off).
signal pressure_plate_deactivated(channel: Globals.Channel)
#endregion
