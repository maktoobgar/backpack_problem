extends Control

export(NodePath) var Popup_WindowDialog_NotePath
export(NodePath) var Value_Weight_TextEdit_NotePath
export(NodePath) var ItemSize_TextEdit_NotePath
export(NodePath) var BackPack_TextEdit_NotePath
export(NodePath) var Soloution_GridContainer_NodePath
export(NodePath) var Value_Weight_Label_NodePath
export(NodePath) var Values_Button_NodePath
export(NodePath) var Weights_Button_NodePath
export(NodePath) var Start_Button_NodePath
export(NodePath) var Weight_Column_VBoxContainer_NodePath
export(NodePath) var Items_Column_HBoxContainer_NodePath
var Popup_WindowDialog: WindowDialog
var Value_Weight_TextEdit: TextEdit
var ItemSize_TextEdit: TextEdit
var BackPack_TextEdit: TextEdit
var Soloution_GridContainer: GridContainer
var Value_Weight_Label: Label
var Values_Button: Button
var Weights_Button: Button
var Start_Button: Button
var Weight_Column_VBoxContainer: VBoxContainer
var Items_Column_HBoxContainer: HBoxContainer

var itemSize: int
var backpackSize: int
# if mode == "value" => we get values. if mode == "weight" => we get weight
var mode: String = ""
var itemsValues: Array = []
var itemsWeights: Array = []
var grid: Array = []
var index: int = 0
const NUMBERS: String = "0123456789\n"
const LABEL = preload("res://Scene/Label.tscn")
const ITEM = preload("res://Scene/Item_PanelContainer.tscn")


func _ready():
	Popup_WindowDialog = get_node(Popup_WindowDialog_NotePath)
	Value_Weight_TextEdit = get_node(Value_Weight_TextEdit_NotePath)
	ItemSize_TextEdit = get_node(ItemSize_TextEdit_NotePath)
	BackPack_TextEdit = get_node(BackPack_TextEdit_NotePath)
	Soloution_GridContainer = get_node(Soloution_GridContainer_NodePath)
	Value_Weight_Label = get_node(Value_Weight_Label_NodePath)
	Values_Button = get_node(Values_Button_NodePath)
	Weights_Button = get_node(Weights_Button_NodePath)
	Start_Button = get_node(Start_Button_NodePath)
	Weight_Column_VBoxContainer = get_node(Weight_Column_VBoxContainer_NodePath)
	Items_Column_HBoxContainer = get_node(Items_Column_HBoxContainer_NodePath)

func _on_Start_Button_button_up():
	itemSize = int(ItemSize_TextEdit.text)
	backpackSize = int(BackPack_TextEdit.text)
	grid_initialization()
	print(len(grid))
	var temp: PanelContainer
	Soloution_GridContainer.columns = itemSize + 1
	for i in range(0, backpackSize + 1):
		for j in range(0, itemSize + 1):
			if i == 0 or j == 0:
				temp = ITEM.instance()
				temp.get_child(0).text = "0"
				Soloution_GridContainer.add_child(temp)
				grid[i].append(0)
				continue
			grid[i].append(max(nodevalue(i, j - 1), nodevalue(i - itemsWeights[j], j - 1) + itemsValues[j]))
			temp = ITEM.instance()
			temp.get_child(0).text = str(grid[i][j])
			Soloution_GridContainer.add_child(temp)

func nodevalue(var i: int, var j: int):
	if i == 0 or j == 0:
		return 0
	if i < 0 or j < 0:
		return -100000
	return max(nodevalue(i, j - 1), nodevalue(i - itemsWeights[j], j - 1) + itemsValues[j])

func grid_clear():
	grid = []
	for k in Items_Column_HBoxContainer.get_child_count():
		Items_Column_HBoxContainer.remove_child(Items_Column_HBoxContainer.get_child(0))
	for k in Weight_Column_VBoxContainer.get_child_count():
		Weight_Column_VBoxContainer.remove_child(Weight_Column_VBoxContainer.get_child(0))

func grid_initialization():
	grid_clear()
	Weight_Column_VBoxContainer.add_child(LABEL.instance())
	for k in backpackSize:
		grid.append([])
		var temp: Label = LABEL.instance()
		temp.text = str(k + 1)
		Weight_Column_VBoxContainer.add_child(temp)
	grid.append([])
	Items_Column_HBoxContainer.add_child(LABEL.instance())
	for k in itemSize:
		var temp: Label = LABEL.instance()
		temp.text = str(k + 1)
		Items_Column_HBoxContainer.add_child(temp)

func _on_Exit_Button_button_up():
	get_tree().quit(0)

func _on_Clear_Button_button_up():
	Start_Button.disabled = true
	Values_Button.disabled = false
	Weights_Button.disabled = false
	ItemSize_TextEdit.readonly = false
	BackPack_TextEdit.readonly = false
	Value_Weight_TextEdit.text = ""
	ItemSize_TextEdit.text = "0"
	BackPack_TextEdit.text = "0"
	grid = []
	itemSize = 0
	backpackSize = 0
	itemsValues = []
	itemsWeights = []
	index= 0
	for i in Soloution_GridContainer.get_child_count():
		Soloution_GridContainer.remove_child(Soloution_GridContainer.get_child(0))
	for i in Weight_Column_VBoxContainer.get_child_count():
		Weight_Column_VBoxContainer.remove_child(Weight_Column_VBoxContainer.get_child(0))
	for i in Items_Column_HBoxContainer.get_child_count():
		Items_Column_HBoxContainer.remove_child(Items_Column_HBoxContainer.get_child(0))

func _on_VW_TextEdit_text_changed():
	var text: String = Value_Weight_TextEdit.text
	var validation: Array = number_validation(text)
	Value_Weight_TextEdit.text = validation[0]
	if not validation[1]:
		return
	# If the last imported character is "\n"
	if "\n" in text:
		if mode == "value":
			if index == 0:
				index = index + 1
				itemsValues.append(0)
			itemsValues.append(int(Value_Weight_TextEdit.text))
			Value_Weight_Label.text = "Value {0}: ".format({"0": index + 1})
		elif mode == "weight":
			if index == 0:
				index = index + 1
				itemsWeights.append(0)
			itemsWeights.append(int(Value_Weight_TextEdit.text))
			Value_Weight_Label.text = "Weight {0}: ".format({"0": index + 1})
		Value_Weight_TextEdit.text = ""
		index = index + 1
		if index >= itemSize + 1:
			if itemsValues != [] and itemsWeights != []:
				Start_Button.disabled = false
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
		for k in range(0, len(text) - 1):
			temp = temp + text[k]
		return [temp, false]
	# Still there is number in text
	for k in range(0, len(text)):
		if not text[k] in NUMBERS:
			return ["", false]
	return [text, true]

func _on_Values_Button_button_up():
	activate_insertion_mode("value")

func _on_Weights_Button_button_up():
	activate_insertion_mode("weight")

func activate_insertion_mode(var buttonType):
	if int(ItemSize_TextEdit.text) > 0 and int(BackPack_TextEdit.text) > 0:
		backpackSize = int(BackPack_TextEdit.text)
		itemSize = int(ItemSize_TextEdit.text)
		ItemSize_TextEdit.text = str(itemSize)
		BackPack_TextEdit.text = str(backpackSize)
		Value_Weight_TextEdit.text = "0"
	else:
		Popup_WindowDialog.show_me(Global.MessageType.Error)
		return
	index = 0
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
	ItemSize_TextEdit.readonly = true
