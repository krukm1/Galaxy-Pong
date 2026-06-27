# Galaxy-Pong — CLAUDE.md

## Project Overview

Galaxy-Pong is a circular Pong/Breakout hybrid built in **Godot 4.7** (Forward Plus renderer, GL Compatibility fallback). The player controls a paddle that orbits a central point and must break all blocks to complete each level. There are 10 levels, power-ups, asteroids, a boss scene, and background music/sfx systems.

**Engine version:** Godot 4.7  
**Renderer:** GL Compatibility (set in `project.godot`)  
**Main scene:** `res://Scenes/Game_Level_1.tscn` (entry via autoload chain)

---

## Project Structure

```
Galaxy-Pong/
├── Assets/          # Sprites, fonts, audio files
├── Scenes/
│   ├── AutoLoads/   # background_star_fields.tscn, Music_Controller.tscn
│   ├── Game_Level_1.tscn … Game_Level_10.tscn
│   └── *.tscn       # Paddle, ball, blocks, power-ups, menus, etc.
├── Scripts/         # One .gd file per scene/node, same base name
├── project.godot
└── CLAUDE.md
```

Scenes and their scripts share the same base name (e.g., `paddle.tscn` ↔ `paddle.gd`). Keep this convention when adding new scenes.

---

## Autoloads (Singletons)

Three global singletons are registered in `project.godot`:

| Name | Source | Purpose |
|---|---|---|
| `GameState` | `Scripts/GameState.gd` | Ball count, game-over flag, level unlock map |
| `Music_Controller` | `Scenes/AutoLoads/Music_Controller.tscn` | All music and SFX playback |
| `Background_Star_Fields` | `Scenes/AutoLoads/background_star_fields.tscn` | Persistent starfield background |

**Rule:** Only add a new autoload if the system truly needs global access and manages its own isolated state. Prefer passing references or using signals for everything else (see Godot best practices on autoloads).

---

## Physics & Groups

**Physics layers** (defined in `project.godot`):
- Layer 1: `Player`
- Layer 2: `Asteroid`
- Layer 3: `Ball`

**Global groups** used for targeting nodes at runtime:
- `FadeOnGameStart` — nodes that fade in when a level begins
- `FadeOnGameOver` — nodes that fade out on game over
- `Wall` — kill-zone walls that destroy the ball
- `Block` — destructible blocks (1-hit)
- `Block_Indestructible` — blocks that bounce the ball but never break
- `Paddle` — the player paddle

When creating new node types that need to participate in these systems, add them to the relevant group in `_ready()`.

---

## GDScript Style Guide

Follow the [official GDScript style guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html).

### Naming
- **Files/variables/functions:** `snake_case`
- **Classes/nodes/scenes:** `PascalCase`
- **Constants:** `CONSTANT_CASE`
- **Signals:** past tense, `snake_case` (e.g., `ball_lost`, `block_destroyed`)
- **Private members:** prefix with `_` (e.g., `_fade_out_nodes()`)

### Code Order Within a Script
1. `class_name` / `extends`
2. Signals
3. Enums
4. Constants
5. `@export` variables
6. Public variables
7. Private variables (`_`)
8. `@onready` variables
9. `_init()`, `_ready()`
10. Other `_virtual_methods()`
11. Public methods
12. Private methods (`_`)

### Type Hints
- Always use static typing. Use `:=` when the type is inferred from the right-hand side; use explicit types otherwise.
- Good: `var speed := 300.0` / `var name: String = get_name()`
- Avoid untyped declarations like `var x = something()` when the type is ambiguous.

### Formatting
- Tabs for indentation (not spaces).
- Max line length: 100 characters.
- Use `and`, `or`, `not` instead of `&&`, `||`, `!`.
- Double quotes for strings.
- Trailing commas in multi-line arrays/dicts.

---

## Scene Design Rules

- **Loose coupling:** Scenes must not reach up to their parent or sideways to siblings directly. Use signals or dependency injection (pass references via `@export` or method calls).
- **`@onready` for node refs:** Always use `@onready` to get child node references — never call `get_node()` outside of `_ready()` unless dynamically spawned.
- **Preload vs load:** Use `preload()` for scenes/resources known at compile time. Use `load()` only for dynamic paths constructed at runtime.
- **`queue_free()` over `free()`:** Always use `queue_free()` to remove nodes — `free()` during a physics frame causes crashes.
- **`add_child()` target:** When spawning a scene at runtime, add it to `get_tree().current_scene` or the appropriate parent — not to `self` unless `self` is the correct owner.

---

## Signals & Communication

- Prefer signals for child-to-parent communication (e.g., `ball_lost` in `ball.gd`).
- Connect signals in code using `node.connect("signal_name", Callable(self, "_on_signal_name"))` or the `signal.connect()` shorthand introduced in Godot 4.
- Do not call methods on parent nodes directly from a child script — emit a signal instead.

---

## Input

Custom input actions (defined in `project.godot`):
- `ui_left` / `ui_right` / `ui_up` / `ui_down` — paddle movement (WASD + D-pad + arrow keys)
- `launch_ball` — Spacebar
- `ui_shift` — Shift key (speed boost)
- `ui_cancel` — Pause/Escape
- `complete_level_test` — P key (debug shortcut)

Use `Input.get_axis()` for analog movement. Use `event.is_action_pressed()` inside `_input()` or `_unhandled_input()` for discrete actions. Use `_unhandled_input()` for game-level input so UI can consume events first.

---

## Level System

- Levels are numbered `Game_Level_1` through `Game_Level_10`.
- Each level scene contains a `GameController.tscn` instance which handles ball spawning, tile replacement, music, and game-over logic.
- Tile-to-block conversion happens in `GameController._ready()` via `replace_tiles_with_blocks()`. TileMapLayer tiles are replaced with instanced block scenes at runtime.
- Level progression: `GameController.level_complete(current_level)` increments the level number and calls `get_tree().change_scene_to_file()`.
- Level unlock state lives in `GameState.level_unlocks` (a dictionary).

---

## Block System

| Scene | Script | Behavior |
|---|---|---|
| `block.tscn` | `block.gd` | 1-hit, destroyed on contact |
| `block_2hit.tscn` | `block_2hit.gd` | 2-hit; calls `register_hit()` |
| `block_indestructible.tscn` | `block_indestructible.gd` | Never destroyed; calls `register_hit()` for visual feedback |

When adding a new block type: implement `register_hit()` if it needs multi-hit logic, and `_on_destroyed()` if it needs a pre-free callback. The ball checks for these methods via `has_method()` before calling them.

---

## Power-Up System

Existing power-ups: `add_ball_powerup`, `pass_through_ball_powerup`.

Power-ups are spawned at a block's `global_position` when the ball hits 3 blocks in a combo window (see `ball.gd` combo logic). To add a new power-up:
1. Create a scene in `Scenes/` and a script in `Scripts/`.
2. Spawn it from the ball or block with `get_tree().current_scene.add_child(instance)`.
3. Handle pickup via an `Area2D` body-entered signal.

---

## Game State & Save System

`GameState.gd` (autoload) currently holds runtime state only — **there is no persistent save file yet** (adding one is a critical priority per README). When implementing saves:
- Use `FileAccess` with `"user://"` paths, not `"res://"`.
- Persist `GameState.level_unlocks` and any other cross-session data.
- Call `GameState.full_reset()` on new game, `GameState.soft_reset()` between levels.

---

## Audio

All audio goes through `Music_Controller` (autoload). Call named methods like `Music_Controller.play_block_break()` — do not instantiate `AudioStreamPlayer` nodes ad hoc in other scripts. When adding new sounds, add a corresponding method to `Music_Controller.gd`.

---

## Performance Notes

- `common/max_physics_steps_per_frame` is set to `60` in `project.godot`.
- Gravity is disabled globally (`2d/default_gravity=0.0`).
- The ball uses `RigidBody2D` with `move_and_collide()` for manual velocity control — do not switch to `apply_impulse()` or let the physics engine drive it automatically.
- The paddle uses `CharacterBody2D` with `move_and_collide()`.

---

## Open Tasks (from README)

**Critical**
- Design all remaining levels
- Add a save file (persist `GameState.level_unlocks`)
- Add double-ball power-up
- Add freezing asteroids

**High**
- Add volume control (tie into `Music_Controller`)
- Add rolling credits scene
- Fix bug: locked ball on paddle can be destroyed

**Medium**
- Duplicate ball object
- Slow-motion on holding CTRL (5 seconds)

**Low**
- Block-break visual effects
- Level-complete celebration
- Last-block aim assist
- Secret level after credits
