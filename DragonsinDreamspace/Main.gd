extends Spatial

var outGUI = true
var raining = false
var inverting = false
var leafing = false
var directing = false
var datingSim = false
var speaker = 0
var first = true
var simTyping = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if datingSim:
		if first:
			$Actor/Head/Sprite3D.shaded = true
			first = false
		
		if simTyping:
			return
		
		if Input.is_action_pressed("ui_home"):
			$GUI.readyEntry(speaker)
			simTyping = true
		if Input.is_action_just_pressed("ui_focus_next"):
			$Actor/Head/Sprite3D.shaded = not $Actor/Head/Sprite3D.shaded
			$Player/Head/Sprite3D.shaded = not $Player/Head/Sprite3D.shaded
			if speaker == 0:
				speaker = 1
			else:
				speaker = 0
		if Input.is_action_just_pressed("ui_focus_prev"):
			datingSim = false
			$Director.locked = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			$Actor/Head/Sprite3D.shaded = false
			$Player/Head/Sprite3D.shaded = false
			first = true
		return
	
	if $GUI.messageDisplayed && Input.is_action_pressed("ui_accept"):
		$GUI.hideMessage()
	if outGUI && Input.is_action_pressed("ui_home"):
		outGUI = false
		$GUI.readyEntry(0)
		$Player.go_GUI()
	if outGUI && Input.is_action_just_pressed("ui_end"):
		outGUI = false
		$GUI.readyEffects()
		$Player.go_GUI()
	if Input.is_action_just_pressed("ui_focus_next"):
		if directing:
			directing = false
			$Player.locked = false
			$Director.locked = true
			$Player/Head/Camera.make_current()
		else:
			directing = true
			$Player.locked = true
			$Player.flattenView()
			$Director.locked = false
			$Director/Head/Camera.make_current()
	if Input.is_action_just_pressed("ui_focus_prev") && directing:
		datingSim = true
		$Director.locked = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_GUI_GUI_HIDDEN():
	if datingSim:
		simTyping = false
		return
	if not directing:
		$Player.end_GUI()
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	outGUI = true

func _on_GUI_EFFECT(x):
	if x == 1:
		if raining:
			raining = false
			$GUI.displayMessage("The World", "The rain slowly peters off, leaving clear skies.")
		else:
			raining = true
			inverting = false
			leafing = false
			$GUI.displayMessage("The World", "With a gentle patter, it begins to rain.")
	elif x == 2:
		if leafing:
			leafing = false
			$GUI.displayMessage("The World", "The breeze dies down and the leaves settle.")
		else:
			leafing = true
			inverting = false
			raining = false
			$GUI.displayMessage("The World", "The wind picks up and leaves begin to fall from the trees.")
	else:
		if inverting:
			inverting = false
			$GUI.displayMessage("The World", "Suddenly, everything returns to normal.")
		else:
			inverting = true
			raining = false
			leafing = false
			$GUI.displayMessage("The World", "There is a strange feeling of inversion, and everything suddenly looks... off.")
	$Rain.emitting = raining
	$Leaf.emitting = leafing
	$Invert.emitting = inverting
