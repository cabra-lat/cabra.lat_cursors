# CabraLat's cursors

Just a simple addon to control custom animated cursors.

Add the `Cursor3D` node then create your animation sheet (or instantiate the scene `cursor_3d.tscne`).

You can now use it in your scripts as follows:

```gdscript
@onready var Cursor = $Cursor3D

@export_group("Action Names")
@export var pull_action:     String = "pull"
@export var throw_action:    String = "throw"
@export var drop_action:     String = "drop"
@export var interact_action: String = "interact"
@export var inspect_action:  String = "inspect"

func _input(event: InputEvent) -> void:
	Cursor.timer.start()
	if Input.is_action_just_pressed(interact_action):
		Cursor.change_cursor("pointing_hand")
			  .click()

	if Input.is_action_just_pressed(throw_action):
		Cursor.change_cursor("open_hand").out_then_in()

	if Input.is_action_just_pressed(drop_action):
		Cursor.change_cursor("open_hand").reset_scale()
		
	if Input.is_action_just_pressed(pull_action):
		Cursor.change_cursor("closed_hand").in_then_out()

	if Input.is_action_just_released(pull_action):
		Cursor.change_cursor("open_hand").reset_scale()
```

Be sure to go do Project > Project Settings > Input Map then add the relevant actions.


# assets

The assets and ressources included here are just examples from the Cursor Pack (1.1) from [Kenney](www.kenney.nl)
which is licensed as [Creative Commons Zero, CC0](http://creativecommons.org/publicdomain/zero/1.0/)

So it's free to use in personal, educational and commercial projects.

You can download the full pack there, more information

- Donate:   http://support.kenney.nl
- Patreon:  http://patreon.com/kenney/
- Follow on [Twitter](http://twitter.com/KenneyNL) for updates:
	
