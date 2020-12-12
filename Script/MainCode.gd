extends Control

export(NodePath) var Popup_WindowDialog_NotePath
export(NodePath) var Value_Weight_TextEdit_NotePath
export(NodePath) var Items_TextEdit_NotePath
export(NodePath) var BackPack_TextEdit_NotePath
export(NodePath) var Soloution_GridContainer_NodePath
export(NodePath) var Value_Weight_Label_NodePath
export(NodePath) var Values_Button_NodePath
export(NodePath) var Weights_Button_NodePath
var Popup_WindowDialog: WindowDialog
var Value_Weight_TextEdit: TextEdit
var Items_TextEdit: TextEdit
var BackPack_TextEdit: TextEdit
var Soloution_GridContainer: GridContainer
var Value_Weight_Label: Label
var Values_Button: Button
var Weights_Button: Button

var backpackSize: int = 0
var itemSize: int = 0
# if mode == "value" => we get values. if mode == "weight" => we get weight
var mode: String = ""
var itemsValues: Array
var itemsWeights: Array
var i: int = 0
var j: int = 0
const NUMBERS: String = "0123456789\n"


func _ready():
	Popup_WindowDialog = get_node(Popup_WindowDialog_NotePath)
	Value_Weight_TextEdit = get_node(Value_Weight_TextEdit_NotePath)
	Items_TextEdit = get_node(Items_TextEdit_NotePath)
	BackPack_TextEdit = get_node(BackPack_TextEdit_NotePath)
	Soloution_GridContainer = get_node(Soloution_GridContainer_NodePath)
	Value_Weight_Label = get_node(Value_Weight_Label_NodePath)
	Values_Button = get_node(Values_Button_NodePath)
	Weights_Button = get_node(Weights_Button_NodePath)

func _on_Start_Button_button_up():
	var vw: String = Value_Weight_TextEdit.text
	var items: String = Items_TextEdit.text
	var backpacksize: String = BackPack_TextEdit.text

func _on_Exit_Button_button_up():
	get_tree().quit(0)

func _on_Clear_Button_button_up():
	Value_Weight_TextEdit.text = "0"
	Items_TextEdit.text = "0"
	BackPack_TextEdit.text = "0"
	while Soloution_GridContainer.get_child_count() > 0:
		Soloution_GridContainer.remove_child(Soloution_GridContainer.get_child(0))

func _on_VW_TextEdit_text_changed():
	var text: String = Value_Weight_TextEdit.text
	var validation: Array = number_validation(text)
	Value_Weight_TextEdit.text = validation[0]
	if not validation[1]:
		return
	# If the last imported character is "\n"
	if "\n" in text:
		if mode == "value":
			itemsValues.append(int(Value_Weight_TextEdit.text))
			Value_Weight_Label.text = "Value {0}: ".format({"0": i + 2})
		elif mode == "weight":
			itemsWeights.append(int(Value_Weight_TextEdit.text))
			Value_Weight_Label.text = "Weight {0}: ".format({"0": i + 2})
		Value_Weight_TextEdit.text = ""
		i = i + 1
		if i >= itemSize:
			Value_Weight_Label.text = "Value (int) : "
			Value_Weight_TextEdit.text = "0"
			Value_Weight_TextEdit.readonly = true
			mode = ""
			print("itemsValues = {v}".format({"v": itemsValues}))
			print("itemsWeights = {w}".format({"w": itemsWeights}))
			return

func number_validation(var text):
	# text equals to empty or "\n"
	if not text or text == "\n":
		text = ""
		return [text, false]
	# Last imported character is not number
	if not (text[len(text) - 1] in NUMBERS):
		var temp = ""
		for i in range(0, len(text) - 1):
			temp = temp + text[i]
		return [temp, false]
	# Still there is number in text
	for i in range(0, len(text)):
		if not text[i] in NUMBERS:
			return ["", false]
	return [text, true]

func _on_Values_Button_button_up():
	activate_insertion_mode("value")

func _on_Weights_Button_button_up():
	activate_insertion_mode("weight")

func activate_insertion_mode(var buttonType):
	if int(Items_TextEdit.text) > 0 and int(BackPack_TextEdit.text) > 0:
		backpackSize = int(BackPack_TextEdit.text)
		itemSize = int(Items_TextEdit.text)
		Items_TextEdit.text = str(itemSize)
		BackPack_TextEdit.text = str(backpackSize)
		Value_Weight_TextEdit.text = "0"
	else:
		Popup_WindowDialog.show_me(Global.MessageType.Error)
		return
	i = 0
	if buttonType == "value":
		mode = "value"
		itemsValues = []
		Value_Weight_Label.text = "Value 1: "
		Values_Button.disabled = true
	elif buttonType == "weight":
		mode = "weight"
		itemsWeights = []
		Value_Weight_Label.text = "Weight 1: "
		Weights_Button.disabled = true
	Value_Weight_TextEdit.readonly = false
	BackPack_TextEdit.readonly = true
	Items_TextEdit.readonly = true
