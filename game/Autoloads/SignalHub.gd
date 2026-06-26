extends Node
## Global Component to manage signals
##
## Used to allow multiple nodes to react to a single event.
## Helps to decouple nodes. Instead of a node needing refrences to other nodes,
## it can just emit a signal and any node that is listening will react to it.


#------------------------------------------------------------------------------------------------
# Emit this when a body entered a Hitbox 
# Pass in the body that entered the Area2D
signal hitbox_entered(caller : Node2D, body : Node2D)
func emit_hitbox_entered(caller : Node2D, body : Node2D):
	hitbox_entered.emit(caller, body)
signal hitbox_exited(caller : Node2D, body : Node2D)

#------------------------------------------------------------------------------------------------
# Emit this when something enters an fov. 
# Connect things that you want to respond to entering the fov to this signal
# Check if the body passed with the signal is the same as self
signal fov_entered(body : Node2D)
signal fov_exited(body : Node2D)

#------------------------------------------------------------------------------------------------
# When the player collides with the keys hit box emit this signal
# connect any objects that need to change state when the key is collected
# for example the exit door needs to unlock when the key is collected
signal key_collected
signal movable_box_hit(box : CharacterBody2D)

#------------------------------------------------------------------------------------------------
# Handle the Pedistal activation
signal red_pedistal_activated
signal green_pedistal_activated
signal blue_pedistal_activated
func emit_pedistal_activated(type : Globals.ButtonType):
	match type:
		Globals.ButtonType.RED:
			red_pedistal_activated.emit()
		Globals.ButtonType.GREEN:
			green_pedistal_activated.emit()
		Globals.ButtonType.BLUE:
			blue_pedistal_activated.emit()
		Globals.ButtonType.DEFAULT:
			print("DEBUG: The pedistal type was not set.")

#------------------------------------------------------------------------------------------------
# Handle the Pressure plate activation
signal red_pressure_plate_activated
signal green_pressure_plate_activated
signal blue_pressure_plate_activated
func emit_pressure_plate_activated(type : Globals.ButtonType):
	match type:
		Globals.ButtonType.RED:
			red_pressure_plate_activated.emit()
		Globals.ButtonType.GREEN:
			green_pressure_plate_activated.emit()
		Globals.ButtonType.BLUE:
			blue_pressure_plate_activated.emit()
		Globals.ButtonType.DEFAULT:
			print("DEBUG: The pressure plate type was not set.")

#handle the Pressure plate deactivation
signal red_pressure_plate_deactivated
signal green_pressure_plate_deactivated
signal blue_pressure_plate_deactivated
func emit_pressure_plate_deactivated(type : Globals.ButtonType):
	match type:
		Globals.ButtonType.RED:
			red_pressure_plate_deactivated.emit()
		Globals.ButtonType.GREEN:
			green_pressure_plate_deactivated.emit()
		Globals.ButtonType.BLUE:
			blue_pressure_plate_deactivated.emit()
		Globals.ButtonType.DEFAULT:
			print("DEBUG: The pressure plate type was not set.")

signal camera_panning
func emit_camera_panning(cam: Camera2D):
	print(cam.position)
	camera_panning.emit()
#------------------------------------------------------------------------------------------------
