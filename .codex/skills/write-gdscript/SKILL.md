---
name: write-gdscript
description: Always use when writing gdscript. Basic rules for writing all gdscript 
---

## General Rules

- keep lines shorter than 120 chars
- prefer early return to deeply nested code
- do not use functions marked `@deprecated`
- mention when using classes marked `@experimental`
- prefer nodes communicate through signals over holding direct refs
- prefer composition over inheritance
- autoloads or project singletons should not have a `class_name`
- avoid getters and setters that do nothing but get or set a variable, if you need to do that just make the variable public and use `@export` if it needs to be set in the editor
- avoid god classes, if a class is doing too much break it up into smaller components or systems
- Use refcounted where possible. use node when things need to live in the scene tree or need to use signals.

## Naming Convention

- short concise names for functions and variables
- files are `snake_case`
- directories are `kebab-case`
- scripts are `snake_case`
- function are `snake_case`
- private functions are prefixed with `_`
- constants are `CONST_CASE`
- resource files are `camelCase`
- nodes are `PascalCase`
- test files are prefixed with `test_<what file it test>.gd`
- test functions are prefixed with `test_<what it tries to break>`

## Project Layout

This is a generic layout based on past project of folders I found helpful

```
res://
	assets/
		sound/
		textures/
		sprites/
		materials/
		models/
	addons/
		<plugins go here>
	autoloads/
	components/
	custom-resources/
	entites/
	scenes/
		levels/
		testing/
	scripts/
	systems/
	tests/
		unit/
		integration/
		e2e/
	ui/
		menus/
		widgets/
	utils/
```

## File Layout

by following this layout all files will have an easy to scan and read structure for human developers

```
class_name
extends
## Short description
## 
## Long class description

signals

consts

exports

public vars
private vars

public onready
private onready

#region Engine Methods
engine-methods here... (_ready, _process, _input)
#endregion

#region Public API
public api methods here...
#endregion

#region Signal Handlers
signal handler methods here...
#end region

#region Private Helpers
private helpers here...
#endregion

```

## Types

- prefer `var my_num: int = 10` over `var my_num := 10` not explicitly giving a type leads to errors more often than not
- all functions should have a return type or return void
- avoid returning `Variant` unless needed in which case document what types it can return
- all parameters should be typed

## Documentation

Use Godot's built in [doc comments](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_documentation_comments.html)
to handle commenting the public facing functions, members, signals, and constants.

### BBCode Reference

Use BBCode tags inside `##` doc comments to format text and cross-link to other parts of the API.

**Linking**

| Tag | Links to | Example |
|-----|----------|---------|
| `[ClassName]` | Class | `[Sprite2D]` |
| `[method Class.name]` | Method | `[method Node3D.hide]` |
| `[member Class.name]` | Property | `[member Node2D.scale]` |
| `[signal Class.name]` | Signal | `[signal Node.renamed]` |
| `[constant Class.name]` | Constant | `[constant Color.RED]` |
| `[enum Class.name]` | Enum | `[enum Mesh.ArrayType]` |
| `[annotation Class.name]` | Annotation | `[annotation @GDScript.@rpc]` |
| `[constructor Class.name]` | Constructor | `[constructor Color.Color]` |
| `[operator Class.name]` | Operator | `[operator Color.operator *]` |
| `[theme_item Class.name]` | Theme item | `[theme_item Label.font]` |
| `[param name]` | Parameter (renders as inline code) | `[param size]` |

**Formatting**

| Tag | Effect | Example |
|-----|--------|---------|
| `[br]` | Line break | `Line 1[br]Line 2` |
| `[lb]` / `[rb]` | Literal `[` / `]` | `[lb]text[rb]` |
| `[b]...[/b]` | Bold | `[b]important[/b]` |
| `[i]...[/i]` | Italic | `[i]note[/i]` |
| `[u]...[/u]` | Underline | `[u]key term[/u]` |
| `[s]...[/s]` | Strikethrough | `[s]old value[/s]` |
| `[code]...[/code]` | Inline code | `[code]true[/code]` |
| `[kbd]...[/kbd]` | Keyboard shortcut | `[kbd]Ctrl + C[/kbd]` |
| `[center]...[/center]` | Centered text | `[center]heading[/center]` |
| `[color=name]...[/color]` | Colored text | `[color=red]warning[/color]` |
| `[url]...[/url]` | Hyperlink | `[url]https://example.com[/url]` |
| `[img width=N]path[/img]` | Embedded image | `[img width=32]res://icon.svg[/img]` |
| `[codeblock lang=gdscript]` | Fenced code block with highlighting | see below |

`[codeblock]` supports `lang=gdscript`, `lang=csharp`, or `lang=text` (no highlight). Indent the body with 4 spaces.

```gdscript
## Clamps [param value] between [param min_val] and [param max_val].[br]
## See also [method clampf] for floats.
##
## [codeblock lang=gdscript]
##     var result = clamp(15, 0, 10)
##     print(result)  # 10
## [/codeblock]
func clamp(value: int, min_val: int, max_val: int) -> int:
```

### Experimental, Deprecated, Tutorial

These tags go at the **class level** (after the long description) or on any **individual member**. They must appear at the start of a `##` line (leading whitespace is fine, but there must be no space between `@` and the keyword, and no space before the `:`).

**`@tutorial`** — link readers to external learning resources.

```gdscript
## @tutorial: https://example.com/basic
## @tutorial(Advanced guide): https://example.com/advanced
```

Use it when your class or system has non-obvious setup, a corresponding how-to article, or belongs to a larger plugin/addon with its own docs.

**`@experimental`** — signals that an API is **unstable and may change** within the current major version without a deprecation period.

```gdscript
## @experimental: API shape is being finalized; expect breaking changes.
```

Use it on new systems you're still iterating on — saves callers from being surprised by breakage. Remove the tag once the API stabilizes.

**`@deprecated`** — signals that an API **should no longer be used** and may be removed in a future version.

```gdscript
## @deprecated: Use [method new_method] instead.
```

Use it instead of deleting an API immediately so existing callers still compile while they migrate. Always include the replacement in the message. Remove the API (and the tag) in the next major version or after a suitable migration window.


### Example
```
extends Node2D
## A brief description of the class's role and functionality.
##
## The description of the script, what it can do,
## and any further detail.
##
## @tutorial:             https://example.com/tutorial_1
## @tutorial(Tutorial 2): https://example.com/tutorial_2
## @experimental

## The description of a signal.
signal my_signal

## This is a description of the below enum.
enum Direction {
	## Direction up.
	UP = 0,
	## Direction down.
	DOWN = 1,
	## Direction left.
	LEFT = 2,
	## Direction right.
	RIGHT = 3,
}

## The description of a constant.
const GRAVITY = 9.8

## The description of the variable v1.
var v1

## This is a multiline description of the variable v2.[br]
## The type information below will be extracted for the documentation.
var v2: int

## If the member has any annotation, the annotation should
## immediately precede it.
@export
var v3 := some_func()


## As the following function is documented, even though its name starts with
## an underscore, it will appear in the help window.
func _fn(p1: int, p2: String) -> int:
	return 0


# The below function isn't documented and its name starts with an underscore
# so it will treated as private and will not be shown in the help window.
func _internal() -> void:
	pass


## Documenting an inner class.
##
## The same rules apply here. The documentation must
## immediately precede the class definition.
##
## @tutorial: https://example.com/tutorial
## @experimental
class Inner:

	## Inner class variable v4.
	var v4


	## Inner class function fn.
	func fn(): pass
```


## Error Checking

- always check return values.
- assert all `@export` vars are set in `_ready`
- fatal errors should use `push_error`
- non fatal errors should use `push_warn`

```
@export var my_node: Node3D

func _ready() -> void:
	assert(my_node,  "My Node was not properly set in the editor")
```

if there begin to be a lot of `@export` vars move all the asserts into a `func _assert_exports() -> void;` helper.


## Abstract Classes as Interfaces

as of Godot4.5 we can use `@abstract` to create abstract classes and functions. This can be used to make soft interfaces.  
When making an interface:

- the class name should be prefixed with an `I` i.e. `ICharacter`
- interfaces should hold no implementation, or variables (constants are allowed).
- all functions found in an interface should be `@abstract`
- all interfaces must have a base class that shares base logic and implementations.

```
class_name BaseCharacter
extends ICharacter
```

base classes are where things like shared logic and variables will live.


## Composition vs Inheritance

The default is composition. Inheritance is a narrower tool used specifically for the interface/contract layer and small, stable behavioral variations on a known base.

### When to use Inheritance

- defining an interface (`ICharacter`) — a pure contract of `@abstract` methods with no implementation
- creating a base class that implements that interface and wires up shared components (`BaseCharacter`)
- a concrete type that is genuinely a narrow specialization of its parent with few meaningful differences (`EnemyCharacter`, `PlayerCharacter` — they share all the same component slots, just populated differently)
- the "is-a" relationship is stable and unlikely to grow sideways into unrelated behavior

**Do not use inheritance to share behavior between unrelated types.** If both `Enemy` and `Trap` need health, give them both a `HealthComponent` — do not make `Trap` extend `Enemy`.

### When to use Composition

- an entity needs capabilities that vary between instances or can be swapped at runtime
- the same behavior is needed across unrelated types (health on enemies, players, destructible props)
- behavior should be independently testable and reusable without dragging in a large parent class
- you are building a character, enemy, weapon, pickup, or any game entity — these almost always grow sideways, and composition keeps that manageable

### The Character Pattern

This is the preferred pattern for character-like entities:

```
ICharacter            @abstract interface — method signatures only, no vars, no logic
  └── BaseCharacter   implements ICharacter; holds @export refs to shared components
        ├── PlayerCharacter   adds player-specific component slots (InputComponent)
        └── EnemyCharacter    adds enemy-specific component slots (AIComponent)
```

**`ICharacter`** — the contract. Every character type must fulfill this regardless of implementation:

```gdscript
# scripts/i-character.gd
class_name ICharacter
extends CharacterBody2D
## Contract all character types must fulfill.

@abstract func get_health() -> HealthComponent
@abstract func get_stamina() -> StaminaComponent
@abstract func get_move() -> MoveComponent
@abstract func get_attack() -> AttackComponent
```

**`BaseCharacter`** — fulfills the contract; holds the shared component slots. The components themselves are child nodes set in the editor:

```gdscript
# scripts/base-character.gd
class_name BaseCharacter
extends ICharacter
## Shared component wiring for all character types.

@export var health: HealthComponent
@export var stamina: StaminaComponent
@export var move: MoveComponent
@export var attack: AttackComponent

func _ready() -> void:
    assert(health, "HealthComponent not set")
    assert(stamina, "StaminaComponent not set")
    assert(move, "MoveComponent not set")
    assert(attack, "AttackComponent not set")

func get_health() -> HealthComponent: return health
func get_stamina() -> StaminaComponent: return stamina
func get_move() -> MoveComponent: return move
func get_attack() -> AttackComponent: return attack
```

**`PlayerCharacter`** — adds player-specific components on top:

```gdscript
# scripts/player-character.gd
class_name PlayerCharacter
extends BaseCharacter
## Player-controlled character; adds input handling.

@export var input: InputComponent

func _ready() -> void:
    super()
    assert(input, "InputComponent not set")
```

**`EnemyCharacter`** — adds AI components on top:

```gdscript
# scripts/enemy-character.gd
class_name EnemyCharacter
extends BaseCharacter
## AI-driven character; adds behaviour tree driver.

@export var ai: AIComponent

func _ready() -> void:
    super()
    assert(ai, "AIComponent not set")
```

### Components

Each component is a self-contained scene (`*.tscn`) with its own script. Components:

- own their own state
- expose their behavior through signals and a public API
- do not hold references to their parent — communicate upward via signals
- can be added to any entity that needs that capability

```gdscript
# components/health-component.gd
class_name HealthComponent
extends Node
## Tracks hit points and emits events on change.

signal damaged(amount: int)
signal healed(amount: int)
signal died

@export var max: int = 100
var current: int

func _ready() -> void:
    current = max

func take_damage(amount: int) -> void:
    current = max(0, current - amount)
    damaged.emit(amount)
    if current == 0:
        died.emit()

func heal(amount: int) -> void:
    current = min(max, current + amount)
    healed.emit(amount)
```

The entity scene tree looks like:

```
PlayerCharacter (CharacterBody2D)
  ├── HealthComponent
  ├── StaminaComponent
  ├── MoveComponent
  ├── AttackComponent
  └── InputComponent
```


## Testing

All testing in Godot 4 uses [GUT](https://github.com/bitwes/Gut). Docs: https://gut.readthedocs.io/en/latest/index.html

Test files extend `GutTest`, live under `res://tests/`, and are named `test_<subject>.gd`.
	
### Running Tests Headless

Run from project root — no editor required, safe for CI:

```bash
# All tests
godot --headless -s addons/gut/gut_cmdln.gd -gdir=res://tests/ -gexit -glog=1

# One folder
godot --headless -s addons/gut/gut_cmdln.gd -gdir=res://tests/unit/ -gexit -glog=1

# One file
godot --headless -s addons/gut/gut_cmdln.gd -gtest=res://tests/unit/test_health.gd -gexit -glog=1
```

Exit code is non-zero on any failure — integrates cleanly with CI pipelines.

### Coverage Target

Aim for a **minimum of 75% coverage** of logic-bearing scripts — components,
systems, state machines, resources, and anything with branches, calculation, or
state transitions.

Exclude code that only makes sense at runtime in a scene: pure scene-wiring,
rendering and physics, and `@export` glue. Chasing coverage on those leads to
brittle tests that break when the scene changes, not to caught bugs.

Coverage is a floor, not a goal. Prefer a handful of `test_` functions that
genuinely try to break a behavior over many that just exercise lines — a script
can be fully covered and still wrong.

### Setup and Teardown

Every test file uses `before_each`. Never rely on test execution order.

Use GUT's autofree helpers to avoid orphaned nodes — **never call `add_child` directly in tests**:

| Helper | Use for |
|--------|---------|
| `add_child_autofree(node)` | nodes that need to be in the scene tree |
| `autofree(obj)` | objects that do not go in the scene tree |

GUT frees everything registered this way automatically after each test. You only need `after_each` for resetting non-object state (flags, counters, external resources).

```gdscript
extends GutTest

var _subject: MyClass

func before_each() -> void:
    _subject = add_child_autofree(MyClass.new())  # needs scene tree
    # or
    _subject = autofree(MyClass.new())             # pure object, no scene tree

func after_each() -> void:
    pass  # only needed if resetting non-object state
```

**Rules:**
- `before_each` — create fresh instances via `autofree`/`add_child_autofree`; reset all state; assume nothing from a prior test
- `after_each` — only needed for non-object state (flags, static variables, external resources); never manually free what autofree already tracks
- never call plain `add_child()` in a test — always use `add_child_autofree()`
- never call `queue_free()` or `.free()` manually on autofreed objects — double-free causes crashes
- `before_all` / `after_all` — only for expensive one-time setup (loading a large resource); never shared mutable state
- never create instances at class scope; always create in `before_each`

### Unit Tests (`tests/unit/`)

**Write a unit test when:**
- testing a single class or function in isolation
- the code has no required scene tree (`$Node` lookups, parent-dependent `_ready` side effects)
- the logic involves calculation, transformation, state machine transitions, or data parsing
- regression-protecting a specific bug fix

**Do not write unit tests for:**
- code whose only behavior is rendering or physics simulation
- exported-variable wiring that only matters at runtime in a scene
- behavior that requires a real node tree to function

```gdscript
# tests/unit/test_health.gd
extends GutTest

var _health: Health

func before_each() -> void:
    _health = autofree(Health.new())  # Health is a pure object, no scene tree needed

func test_takes_damage_reduces_current() -> void:
    _health.take_damage(10)
    assert_eq(_health.current, _health.max - 10)

func test_cannot_go_below_zero() -> void:
    _health.take_damage(9999)
    assert_eq(_health.current, 0)

func test_full_heal_restores_max() -> void:
    _health.take_damage(50)
    _health.heal_full()
    assert_eq(_health.current, _health.max)
```

- each `test_` function tests exactly one behavior
- use GUT doubles to isolate dependencies: `var dep: MyDep = autofree(double(MyDep).new())`
- stub return values: `stub(dep, "get_value").to_return(42)`
- assert interactions: `assert_called(dep, "some_method")`

### Integration Tests (`tests/integration/`)

**Write an integration test when:**
- two or more systems must cooperate (component emits signal → another component handles it)
- resource loading, autoloads, or singletons are part of the flow
- testing a complete node sub-tree (a component scene, not a full level)
- the behavior only makes sense when systems are wired together

**Do not write integration tests for:**
- full levels or complete gameplay loops — use e2e
- pure logic with no node dependencies — use unit

```gdscript
# tests/integration/test_damage_system.gd
extends GutTest

var _entity: Node

func before_each() -> void:
    _entity = add_child_autofree(preload("res://entities/enemy/enemy.tscn").instantiate())

func test_hurt_box_signal_reduces_health() -> void:
    var health: Health = _entity.get_node("Health")
    var hurt_box: HurtBox = _entity.get_node("HurtBox")
    var before: int = health.current
    hurt_box.hit.emit(10)
    assert_eq(health.current, before - 10)
```

- instantiate the smallest scene that contains the systems under test
- `add_child_autofree` on the root frees the entire subtree automatically — never free children individually
- test the wiring between systems, not the logic inside them (that belongs in unit)

### End-to-End Tests (`tests/e2e/`)

**Write an e2e test when:**
- verifying a full gameplay scenario from input to visible outcome (player attacks → enemy dies → score updates)
- a complete level or menu scene must be loaded and exercised
- regression-protecting a critical player-facing path
- testing a full UI flow (open menu → change setting → confirm it persists)

**Do not write e2e tests for:**
- anything testable at unit or integration level — e2e tests are slow and fragile
- visual or audio correctness — that requires manual or specialized tooling
- covering many edge cases — keep the e2e suite small; edge cases belong in unit

```gdscript
# tests/e2e/test_combat_flow.gd
extends GutTest

var _scene: Node

func before_each() -> void:
    _scene = add_child_autofree(preload("res://scenes/testing/test-arena.tscn").instantiate())
    await get_tree().process_frame  # let all _ready calls settle

func test_player_attack_kills_enemy() -> void:
    var player: CharacterBody2D = _scene.get_node("Player")
    var enemy: CharacterBody2D = _scene.get_node("Enemy")
    player.attack()
    await get_tree().create_timer(0.1).timeout
    assert_true(enemy.is_dead())
```

- use dedicated test scenes under `res://scenes/testing/` rather than production levels — keeps tests stable when levels change
- always `await get_tree().process_frame` after `add_child` before asserting
- use `await get_tree().create_timer(N).timeout` for time-dependent behavior; keep N as small as possible
- if an e2e test takes more than a few seconds it is doing too much — split it or drop it to integration level

### GUT Assertion Quick Reference

| Assertion | Use for |
|-----------|---------|
| `assert_eq(a, b)` | equality |
| `assert_ne(a, b)` | inequality |
| `assert_true(x)` | boolean true |
| `assert_false(x)` | boolean false |
| `assert_null(x)` | null check |
| `assert_not_null(x)` | non-null check |
| `assert_gt(a, b)` | a > b |
| `assert_lt(a, b)` | a < b |
| `assert_has(container, item)` | container contains item |
| `assert_signal_emitted(obj, "signal_name")` | signal was emitted |
| `assert_called(double, "method")` | method was called on a double |

## Accommodating Emacs

- all functions must end with a `return` call even if it returns nothing
- all control flows must end with `break`, `pass`, `continue`, or `return`, helps Emacs understand how to indent properly 

```
# Sum all non negative numbers
func my_add(nums: Array[int]) -> int:
	var s: int = 0
	for i in nums:
		if i < 0:
			print("i is negative")
			continue
		s = s + i
		pass
	return s

```

## Creating UI

- For any UI component, widget, or menu that is more than a single node, Make a tscn file and a script file.
- Do not build the UI through code do it through a `.tscn` file
- Try to create reusable themes
- If a UI component like a button can hold and handle its own logic let it
- break up large deeply nested UI scenes into smaller reusable components if possible.


## Parameter List

when a parameter list gets too long (larger than 5 parameters) create a context class or resource that gets passed in instead. This makes it easier to read and understand what the parameters are for and also makes it easier to add more parameters in the future without breaking existing code.

```
class_name MoveContext
extends RefCounted
## Context for move operations.
var speed: float
var direction: Vector2
var delta: float

func _init(speed: float, direction: Vector2, delta: float) -> void:
    self.speed = speed
    self.direction = direction
    self.delta = delta

```
