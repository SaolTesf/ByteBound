# ByteBound Tools, Systems, and Components


## Tools
### Debug
The Debug autoload can be used to log info to the console or a log file.

| functions                      | description                 |
|--------------------------------|-----------------------------|
| debug(caller, "string", stack) | outputs info to the console |
| log(caller, "string", stack)   | outputs info to a file      |

#### debug(caller : Object, message : String, show_stack : bool)
debug prints output to the console. it takes in 3 parameters:
- caller: the calling object, usually self
- message: A string to print to the console
- show_stack: true, if you want to print a stack trace as well.

The following info will be printed to the console:
- Source: name of calling file
- Class: name of the calling class
- Function: name of the calling function
- Line: The line number of the debug function
- message: The message passed in by the user.

```
Debug.debug(self, "Debug message", false) # dosent print the stack trace
Debug.debug(self, "Debug message", true) # prints a stack trace

Debug.debug(self, "Debug value: %s" % value, false) # format string
Debug.debug(self, "%s: %d %v" % [string, number, vector], false) # complex format string
```

#### log(caller : Object, message : String, show_stack : bool)
log is used to save debug info to a file. it takes in 3 parameters:
- caller: the calling object, usually self
- message: A string to print to the console
- show_stack: true, if you want to print a stack trace as well.

The following will be written to the file: 
- Time Stamp: The time the log was written
- Source: The calling source file
- Class: The calling class
- Function: The calling function
- Line: The line number
- Message: The user passed message string.

The following will be displayed in the console: 
- Source: the file name.
- Class: the class name.
- Function: the function name.
- Conformation: a message showing the file path the info was saved in or a failure message.

##### File
The file that the log will be stored in is based off of the calling objects script file and class name.
This scheme might need to change as if no class_name is specified most objects default to node. 
but this also serves as the Node class being a catch all file.

in Godot the files will be saved inside of the. 
```
user://Logs/Source/Class.log
```
where source is the file name and class is the class name.

on the system by default this is:
```
Windows: %APPDATA%\Godot\app_userdata\[project_name]
macOS: ~/Library/Application Support/Godot/app_userdata/[project_name]
Linux: ~/.local/share/godot/app_userdata/[project_name]
```


##### Examples
```
Debug.log(self, "Debug message", false) # dosent print the stack trace
Debug.log(self, "Debug message", true) # prints a stack trace

Debug.log(self, "Debug value: %s" % value, false) # format string
Debug.log(self, "%s: %d %v" % [string, number, vector], false) # complex format string
```

## Systems
### Scene Manager
The scene manager is a way to load different scenes from an array. 

| Function              | Description                       |
|-----------------------|-----------------------------------|
| play()                | used to start the game at level 1 |
| selectLevel(level)    | use to load the specified level   |
| reload()              | used to reload the current level  |
| previous()            | used to load the previous level   |
| next()                | used to load the next level       |
| open\_level\_select() | opens the level select menu       |
| open\_main\_menu()    | opens the main menu               |

#### Example


### Signal Hub
The signal hub is used to decouple objects. Instead of two object needing a reference to each other,
they now have access to the autoloads 'SignalHub' which allows one object to emit a signal upon an event happening.
the object that needs to react to this event just connects to the same signal that is emitted
#### Example
Object1 will emit a signal through the signal manager
Object2 will handle that signal and reload the level with the [scene manager](### Scene-Manager).
##### Object 1
```
class_name Object1 extends Area2D # Random class Area 2D chose for example with collision
## Object1 Will emit a signal that Object2 will connect to and execuate some code

func _ready() -> void:
	on_body_entered.connect(_on_body_entered) # Connect Object1 to handle when something enters it.
	
func _on_body_entered(body : Node2D) -> void:
	# checks the name of the bodys script
	if body.get_script().get_global_name() is Object2:
		SignalHub.object2_hit.emit() # emit the desired signal
	
```

##### Object 2
```
class_name Object2 extends Node2D
# Handles the object2_hit signal

func _ready() -> void:
	SignalHub.object2_hit.connect(_on_hit)
	
func _on_hit() -> void:
	SceneManager.reload()
	
```

## Actors
Actor's are split into two groups Player and NPC. Actors typically have an AI and its actions are broken into states.
States are controlled by the [State Machine](###State-Machine).
### Player
The player is the main character. 
#### States

### Enemy
#### States

## Components
### Move Stats

| functions                                         | description      | type |
|---------------------------------------------------|------------------|------|
| handle\_horizontal\_input(body, direction, delta) | Moves left/right | void |
| handle\_dash(body, direction, delta)              | Uses a  Dash     | void |
| void handle\_gravity(body, fast\_fall, delta)     | Applies Gravity  | void |
| void handle\_jump(body)                           | Uses a Jump      | void |

Move Stats give CharacterBody2D's access to a variety of move stats and function.
These functions allow the CharacterBody2D to move, jump, dash, and fall.
Move stats is a resource making it easy to load and unload for save states.
	
#### Fields
##### bool advanced movement
if true the movement equations use acceleration and deceleration to make the character movement less snappy

##### bool multi jump
if true allows the CharacterBody2D to preform a double jump up to the [max jumps]()

##### bool enable dash
if true allows the CharacterBody2D to preform a dash. A short range burst of speed where direction is locked in.

##### float ground speed
Speed of the CharacterBody2D moves on the ground

##### float air speed
speed of the CharacterBody2D moves in the air

##### float ground acceleration
acceleration of the CharacterBody2D on the ground.
only applied if [advanced movement]() is true.

##### float air acceleration
acceleration of the CharacterBody2D in the air.
only applied if [advanced movement]() is true.

##### float ground deceleration
deceleration of the CharacterBody2D on the ground.
only applied if [advanced movement]() is true.

##### float air deceleration
deceleration of the CharacterBody2D in the air.
only applied if [advanced movement]() is true.

##### float gravity
Speed at which the CharacterBody2D falls through the air by default

##### float fast fall gravity
Acts as an accelerated fall to bring the CharacterBody2D back to the ground quicker

##### float jump height
The max height a CharacterBody2D can jump

##### int max jumps
The max numbers of jumps the CharacterBody2D can use. Should be reset when the actor hits the ground.
only available when [multi jump]() is true.

##### float multi jump height multiplier
Scales the height of the second jump of the character. 
for smaller jumps set to a value between (0,1], for larger jumps set to a value > 1.
only available when [multi jump]() is true.

##### float coyote jump time
Allows the CharacterBody2D some wiggle room when they leave the ground to still allow a jump.
This is called a coyote jump and makes the jump feel less punishing.

##### float jump buffer time
Allows the CharacterBody2D some wiggle room if jump is pushed just before the player hits the ground.
Makes the jump less punishing as the player does not need to be frame perfect with input.

#### Methods
for all these methods make sure that move\_and\_slide() is called after these functions, 
otherwise no movement will be applied.
##### void handle\_horizontal\_input(body, direction, delta)
applies the left and right movement to the CharacterBody2D. If advanced movement is true,
acceleration and deceleration are used in the calculations.
Parameters:
- body : CharacterBody2D, the body to apply movement too.
- direction : float, the direction of the movement
- delta : float, Change in time. taken from \_physics\_process(delta)

##### void handle\_dash(body, direction, delta)
applies a dash to the CharacterBody2D. During the dash the CharacterBody2D is locked into a single direction.
Parameters:
- body : CharacterBody2D, the body to apply movement too.
- direction : float, the direction of the movement
- delta : float, Change in time. taken from \_physics\_process(delta)

##### void handle\_gravity(body, fast\_fall, delta)
Applies a downward force to the CharacterBody2D if they are not on the floor.
If fast\_fall is true then the force applied will be higher making the CharacterBody2D fall faster.
Parameters:
- body : CharacterBody2D, the body to apply movement too.
- fast\_fall : bool, if true use the [fast_fall]() variable for gravity
- delta : float, Change in time. taken from \_physics\_process(delta)

##### void handle\_jump(body)
Applies an upward force to the CharacterBody2D and decrements the [max jump]() counter.
Parameters:
- body : CharacterBody2D, the body to make jump
	
### Input

| functions   | description                      | type |
|-------------|----------------------------------|------|
| get\_jump   | checks for jump input            | bool |
| get\_move   | checks for left and right inputs | bool |
| get\_left   | checks for left inputs           | bool |
| get\_right  | checks for right inputs          | bool |
| get\_dash   | checks for dash inputs           | bool |
| get\_crouch | checks for crouch inputs         | bool |

Handles input from devices and translates them into bools that can be used through out the game to make move decisions.
checks for horizontal axis input every frame and sets a float to keep track of the horizontal input access.

#### Fields
##### float input_horizontal
#### Methods
##### bool get\_jump()
return true of the player has hit the jump button
##### bool get\_move()
returns true if the player has hit the left or right movement buttons.
uses get\_left and get\_right as checks
##### bool get\_left()
returns true if the player has hit the left button
##### bool get\_right()
returns true if the player has hit the right button
##### bool get\_fast\_fall()
returns true if the player has hit the down button
##### bool get\_dash()
returns true if the player has hit the shift button
##### bool get\_crouch()
returns true if the player hit the ctrl button
### State Machine
The state machine is used to manage custom written scripts that inherit from [State]().
To set up the state machine do the following.
- Instantiate a state machine node as a child of the node you want it to control.
- create a reference to the state machine in the parent and initialize the state machine
- Add states as children of the state machine.
#### Example
```
extends CharacterBody2D

var state_machine : StateMachine
 # The state machine requires these components
@export var move_stats : MoveStats # set in editor
var animations : AnimatedSprite2D
var input : InputComponent

func _ready() -> void:
	state_machine.find_child("StateMachine")
	animations.find_child("AnimatedBody2D")
	input.find_child("InputComponent")
	
	# raise an error if the components are not set
	assert(state_machine != null, "State Machine was not found as a child")
	assert(animations != null, "AnimatedSprite2D was not found as a child")
	assert(input != null, "InputComponent was not found as a child")
	
	# initalize the state machine with the required components
	if state_machine and move_stats and animations and input:
		state_machine.init(self, animations, input, move_stats)

func _process(delta: float) -> void:
	state_machine.process(delta) # run the state process
	
func _physics_process(delta : float) -> void:
	state_machine.process_physics(delta) # run the state physics
	
func _unhandled_input(event: InputEvent) -> void:
	state_controller.process_input(event) # run the states input handler
```

	
### FoV

| function                        | description     | type |
|---------------------------------|-----------------|------|
| init(segments, angle, distance) | sets up the fov | void |
| update()                        | Updates the FoV | void |

The Fov is is a component that you can instantiate on to another node to give it a Fov.
The Fov is a Area2D with a CollisionPolygon2D. The Polygon is created by ray casting multiple rays.
The end points of the rays are then taken and used  as the points in the polygon.
This allows the polygon to bend around objects as if it was a light field. If you want to allow the Node to have different length or size Fov's set up the following as export vars on the Node:
```
@export fov_segments : int = 40
@export fov_angle : float = 45
@export fov_distance : float = 50
```

#### Fields
##### num\_of\_segments
the number of rays to cast, as each rays end points will be used as a vertex in the polygons creation
##### sight\_angle
The angle of the sight cone. each ray is cast at an interval of the angle / number of segments
##### sight\_distance
The length that the ray should be cast.
#### Methods
##### init(segments : int, angle : float, distance : float)
call this function in the parent Node of the Fov's _ready() function.
##### update()
call this function in the _process() function of the parent node.
#### Example
```
extends Node2D

var fov : FoV # reference to the fov
@export fov_segments : int = 40
@export fov_angle : float = 45
@export fov_distance : float = 50

func _ready() -> void:
	fov = find_child("FoV")
	assert(fov != null, "FoV was not found as a child of %s" % self) # throw an error while in editor only
	if fov:
		fov.init(fov_segments, fov_angle, fov_distance)
		
func _process(delta : float) -> void:
	fov.update()

```

### HitBox
The Hitbox is an component that you can instantiate on to another node.
The Hitbox is made of a Area2D that can be used to determine when something enters its borders.
Similar to the FoV but this area is not visible in the game and is a field around the object.
Set the X and Y in the editor and it should be good. 
connect the Nodes that you want to react to the hitbox\_entered signal.
#### Example
##### Function that owns the hit box
```
class_name Object1 extends Node2D

var hitbox : Hitbox

func _ready() -> void:
	hitbox = find_child("HitBox")
	assert(hitbox != null, "Hitbox was not found as a child node")
	if hitbox:
		hitbox.init()
```

##### Function responding to hitbox entered
```
class_name Object2 extends Node

func _ready() -> void:
	SignalHub.hitbox_entered.connect(_on_hitbox_entered)
	
func _on_hit_box_entered(caller : Node2D, body : Node2D) -> void:
	if self == body: # check what object entered a hitbox
		if caller is Object1: # Check which hitbox was entered
			Debug(self, "Object2 entered Object1's Hitbox", false)
```


### Pushable
Allows an object to be pushed when certain types come into contact with it.

###

## Objects
### Lasers
Lasers are a hazard that will kill the player on death.
### Buttons
Buttons can be used to turn off lasers or open doors.
