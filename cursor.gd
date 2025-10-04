@icon("icon.png")
class_name Cursor3D extends AnimatedSprite2D

@export_group("Visibility")
@export var idle_timeout: float = 1.0
@export var hide_if_idle: bool = true

@export_group("Click Animation")
@export var default_duration: float = 0.2  ## Default duration for animations
@export var scale_in: float = 0.8  ## Inwards Scale factor
@export var scale_out: float = 1.2  ## Outwards Scale factor

@onready var original_scale: Vector2 = scale  # Store the original scale
@onready var timer: Timer = Timer.new()
@onready var tween: Tween

func _ready() -> void:
	# Add a timer for visibility timeout
	add_child(timer)
	timer.one_shot = true
	timer.timeout.connect(func(): if hide_if_idle: hide())
	visible = false  # Start hidden
	
	# Configure visibility timeout logic
	visibility_changed.connect(func():
		if visible:
			timer.start(idle_timeout)
		else:
			timer.stop()
	)

func change_cursor(cursor_name: String) -> Cursor3D:
	"""
	Changes the cursor texture based on `cursor_name`.
	Returns `self` to allow method chaining.
	"""
	show()  # Ensure the cursor is visible
	if sprite_frames.has_animation(cursor_name):
		play(cursor_name)
	else:
		push_warning("Cursor %s does not exist" % cursor_name)
	return self

func click() -> Cursor3D:
	"""
	Plays a "click" animation (scale in and back out quickly).
	"""
	await animate_scale(scale_in, default_duration / 2, false)
	return self

func in_then_out() -> Cursor3D:
	"""
	Plays a "grow and shrink" animation (big to smaller).
	"""
	await animate_scale(scale_in, default_duration / 2, false)
	await animate_scale(scale_out, default_duration / 2)
	return self

func out_then_in() -> Cursor3D:
	"""
	Plays a "shrink then grow and stay" animation.
	"""
	await animate_scale(scale_out, default_duration / 2, false)
	await animate_scale(scale_in, default_duration / 2)
	return self

func reset_scale() -> Cursor3D:
	"""
	Resets the cursor to its original scale.
	"""
	await animate_scale()
	return self

func animate_scale(target_scale: float = 1.0, duration: float = default_duration, reset_after: bool = false) -> Cursor3D:
	"""
	Plays a scaling animation with optional reset.
	"""
	if tween: tween.stop()
	tween = create_tween()
	tween.tween_property(self, "scale", original_scale * target_scale, duration) \
		 .set_trans(Tween.TRANS_QUAD) \
		 .set_ease(Tween.EASE_IN_OUT)
	if reset_after:
		tween.tween_property(self, "scale", original_scale, duration) \
			 .set_trans(Tween.TRANS_QUAD) \
			 .set_ease(Tween.EASE_IN_OUT) \
			 .set_delay(duration)
	tween.play()
	await tween.finished
	return self
