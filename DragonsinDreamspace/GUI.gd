extends MarginContainer

onready var effect1 = $VBoxContainer/UpperBox/Effect1
onready var effect2 = $VBoxContainer/UpperBox/Effect2
onready var effect3 = $VBoxContainer/UpperBox/Effect3
onready var entry = $VBoxContainer/MiddleBox/LineEdit
onready var submitButton = $VBoxContainer/MiddleBox/Button/Button
onready var messageBox = $VBoxContainer/LowerBox/Textbox
onready var messageBoxBackground = $VBoxContainer/LowerBox

signal GUI_HIDDEN
signal EFFECT(x)

var currentSpeaker = 0

var messageDisplayed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	hideEntry()
	hideMessage()
	hideEffects()

func displayMessage(name, message):
	#TODO: Add code to queue up messages
	messageDisplayed = true
	messageBox.bbcode_text = "[b][color=aqua]"+name+"[/color][/b]\n"+message+"	[wave amp=50 freq=2]>>>[/wave]"
	messageBox.visible = true
	messageBoxBackground.visible = true

func hideMessage():
	messageDisplayed = false
	messageBox.visible = false
	messageBoxBackground.visible = false

func readyEntry(speaker):
	entry.editable = true
	entry.text = ""
	entry.visible = true
	submitButton.visible = true
	submitButton.disabled = false
	currentSpeaker = speaker

func hideEntry():
	entry.editable = false
	entry.visible = false
	submitButton.visible = false
	submitButton.disabled = true
	emit_signal("GUI_HIDDEN")

func readyEffects():
	effect1.visible = true
	effect1.disabled = false
	effect2.visible = true
	effect2.disabled = false
	effect3.visible = true
	effect3.disabled = false

func hideEffects():
	effect1.visible = false
	effect1.disabled = true
	effect2.visible = false
	effect2.disabled = true
	effect3.visible = false
	effect3.disabled = true
	emit_signal("GUI_HIDDEN")

func _on_Message_submitted():
	if currentSpeaker == 0:
		displayMessage("Torgan Simtral III", entry.text)
	else:
		displayMessage("Sir Longinus", entry.text)
	hideEntry()

func _on_Effect1_pressed():
	emit_signal("EFFECT", 1)
	hideEffects()

func _on_Effect2_pressed():
	emit_signal("EFFECT", 2)
	hideEffects()


func _on_Effect3_pressed():
	emit_signal("EFFECT", 3)
	hideEffects()
