# StateMachine

A generic, **self-driving**, node-based finite state machine for Godot 4.6, with typed 2D and
3D variants. States are child nodes; the machine discovers them, drives itself off the engine
callbacks, and transitions whenever a state hands back the next one. Ships as an actual
`EditorPlugin` so the machine/state types appear in the **Add Node** dialog.

> **Standalone & not currently wired into the game.** Unlike the other addons, nothing in this
> project consumes the FSM yet — the player's movement is resolved by `MovementComponent`'s own
> priority system, not by this machine. It's a reusable library kept on hand for entities (AI,
> menus, animation states) that want a classic FSM. See the [footgun about the plugin path](#footguns--strange-behaviors)
> before enabling it on Linux.

---

## What problem it solves

Hand-rolled FSMs usually become an `enum` plus a `match` in `_physics_process`, where adding a
state means touching every dispatch site and the owner has to remember to forward `_process`,
`_physics_process`, and `_input` into it. This addon makes the machine self-contained:

- **States are nodes.** Each state is a child node of the machine, so it lives in the scene
  tree, is configured in the inspector, and is added/removed without editing a dispatch table.
- **The machine drives itself.** It implements `_process` / `_physics_process` /
  `_unhandled_input` and forwards each to the current state. The owner forwards **nothing**.
- **Transitions are return values.** A state's `process_*` returns the next state (or `null` to
  stay). No state reaches into the machine to flip an enum; it just says "go here next".
- **Typed where it matters.** `FSMState2D`/`FSMState3D` (and the matching machines) expose the
  controlled node as a typed `body`, so state code gets autocomplete and static typing.

---

## The type ladder

Two parallel families — machines and states — each an abstract interface, a concrete base, and
two dimensional variants:

| Type | Extends | Role |
|---|---|---|
| `IFSMachine` | `Node` (`@abstract`) | All the plumbing: current/last state, controlled node, enable flags, self-driving callbacks, `init`/`change_state`. Leaves the dispatch policy abstract. |
| `FSMachine` | `IFSMachine` | The default dispatch: forward each callback to the current state, transition on a non-null return. For plain `Node` owners. |
| `FSMachine2D` / `FSMachine3D` | `FSMachine` | Same, but expose `body` as a typed `Node2D` / `Node3D`. |
| `IFSMState` | `Node` (`@abstract`) | The state contract: `enter`, `exit`, and the three `process_*` methods that return the next state. |
| `FSMState` | `IFSMState` | Concrete base with no-op defaults — override only what you use. |
| `FSMState2D` / `FSMState3D` | `FSMState` | Same, but expose the controlled node as a typed `body`. |

All have `class_name`s, so they're usable from code whether or not the editor plugin is enabled
(the plugin only adds them to the node-creation dialog).

---

## How it works

### States are children, discovered by name

A machine's states are its `FSMState` child nodes. `get_states()` scans the children and keys
them by each state's `state_name` export into a `Dictionary[String, FSMState]` (exposed as
`state_list`). So a machine *is* its subtree:

```
Enemy (CharacterBody3D)
└── FSMachine3D            starting_state = → Idle,  target = (defaults to Enemy)
    ├── Idle    (FSMState3D,  state_name = "Idle")
    ├── Chase   (FSMState3D,  state_name = "Chase")
    └── Attack  (FSMState3D,  state_name = "Attack")
```

### The controlled node — `target` / `body`

The machine controls one node. It's `target` if set, else the machine's parent (resolved in
`_ready`). On `init` the machine hands that node to every state (`state._parent`), which the
typed variants surface as `body` (`Node2D`/`Node3D`). So state code manipulates the entity via
`body` and never needs a back-reference wired by hand.

### Self-driving + transition-by-return

The machine runs itself:

```
 IFSMachine._physics_process(delta)        (also _process, _unhandled_input)
   └─ if enabled: FSMachine.process_physics(delta)
        └─ next := current_state.process_physics(delta)   ← state returns the next state…
           if next: change_state(next)                    ← …or null to stay
```

`change_state` runs `current.exit()` → records `last_state` → swaps in the new state →
`new.enter()`. The owner never calls any of this; it just builds the subtree and sets
`starting_state`.

### Lifecycle

| Call | What happens |
|---|---|
| `_ready` → `init(target or parent)` | Wires `machine`/`_parent` into every child state, then enters `starting_state` (errors if it's null). Runs once (`_initialized` guards re-entry). |
| `init(parent)` (manual) | Call directly only to **re-target** the machine at a different node. |
| `change_state(s)` | The public transition. No-ops while the machine is disabled. |
| `enter()` / `exit()` | Your per-state setup/teardown, run on every transition into/out of the state. |

### Enable flags

`enabled` gates everything; `physics_enabled` / `process_enabled` / `input_enabled` gate each
callback individually. Disabling (`enabled = false` or `enable(false)`) turns the three
sub-flags off, blocks `change_state`, and calls `exit()` on the current state — a full halt.

---

## The editor plugin

`plugin.gd` registers the six types via `add_custom_type` so they show up in **Add Node**:

```
IFSMachine → FSMachine → FSMachine2D / FSMachine3D
IFSMState  → FSMState  → FSMState2D  / FSMState3D
```

Enable it under **Project → Project Settings → Plugins**. (It's currently disabled in this
project; the `class_name`s already make the types code-usable without it.)

---

## How to use

### 1. Build the subtree

Add an `FSMachine3D` under your entity, then one `FSMState3D` child per state. Give each state
a unique `state_name`, and set the machine's `starting_state` to one of them. Leave `target`
empty to control the machine's parent.

### 2. Write a state

```gdscript
extends FSMState3D
class_name EnemyChaseState
## Controls the enemy via `body` (a typed Node3D). Returns the next state, or null to stay.

@export var attack_range := 2.0

func enter() -> void:
    body.play_animation("run")

func process_physics(_delta: float) -> FSMState:
    var player := body.find_target()
    if body.global_position.distance_to(player) <= attack_range:
        return machine.state_list["Attack"]   # transition by returning the next state
    body.move_toward_point(player)
    return null                                # stay in Chase
```

States reach siblings through `machine.state_list[...]` (keyed by `state_name`), or you can
`@export var next_state: FSMState` and assign it in the inspector for explicit wiring.

### 3. Drive nothing

Once `starting_state` is set the machine runs on its own from `_ready`. Toggle it at runtime
with `machine.enabled = false`, or pause just one channel with `machine.physics_enabled = false`.

---

## Footguns & strange behaviors

| Behavior | Where | Why / how to handle |
|---|---|---|
| **Plugin preloads a wrong-case path** | `plugin.gd` | The 2D/3D types are preloaded from `res://addons/state_machine/scripts/...` (lowercase) but the folder is `addons/StateMachine`. On a **case-sensitive filesystem (Linux)** enabling the plugin fails to load those. Fix the paths to `StateMachine` (or use `uid://` like the other two) before enabling. |
| **Re-enabling doesn't restore sub-flags** | `IFSMachine.enable` | `enable(false)` sets `physics/process/input_enabled = false`, but `enable(true)` only flips `_enabled` — it does **not** turn them back on, nor re-`enter()` the current state. After a disable/enable cycle the machine is effectively inert. Re-set the sub-flags (and re-enter) yourself, or only ever gate via the individual `*_enabled` flags. |
| `exit()` without a matching `enter()` on disable | `IFSMachine.enable` | Disabling calls `current_state.exit()`; re-enabling never calls `enter()`. Don't assume enter/exit are balanced across a disable cycle. |
| Null `starting_state` leaves `current_state` null | `IFSMachine.init` / `FSMachine.process_*` | `init` pushes an error and returns without setting a current state; the next frame `current_state.process_physics(...)` then dereferences null and crashes. Always assign `starting_state`. |
| `state_list` re-scans children every access | `IFSMachine.state_list` getter | The getter calls `get_states()` (a full child scan) each read. Cache it if you read it in a hot loop. |
| Two states can share a `state_name` | `IFSMachine.get_states` | Keying by `state_name` means a duplicate silently overwrites the earlier one in the dictionary. Keep names unique. |
| Debug exports are inert | `IFSMState` / `IFSMachine` (`LOGLVL`, `DEBUGLVL`) | These exist for a logging system that isn't implemented here; they don't do anything on their own. |
| Different style from the other addons | whole addon | This is a self-contained library FSM (its own `EditorPlugin`, `I*`-prefixed interfaces, `target`/`body` accessors) — it predates the project's "components + local signals, no plugin" convention. Treat it as a third-party-style dependency, not a model for new components here. |
