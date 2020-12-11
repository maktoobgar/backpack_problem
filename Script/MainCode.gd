extends Control

export(NodePath) var Popup_NotePath
export(NodePath) var Value_Weight_NotePath
export(NodePath) var Items_NotePath
export(NodePath) var BackPack_NotePath
var Popup_WindowDialog: WindowDialog
var Value_Weight_TextEdit: TextEdit
var Items_TextEdit: TextEdit
var BackPack_TextEdit: TextEdit


func _ready():
	Value_Weight_TextEdit = get_node(Value_Weight_NotePath)
	Items_TextEdit = get_node(Items_NotePath)
	BackPack_TextEdit = get_node(BackPack_NotePath)
	Popup_WindowDialog = get_node(Popup_NotePath)

func _on_Start_Button_button_up():
	if int(Value_Weight_TextEdit.text) > 0 and int(Items_TextEdit.text) > 0 and int(BackPack_TextEdit.text) > 0:
		Value_Weight_TextEdit.text = str(int(Value_Weight_TextEdit.text))
		Items_TextEdit.text = str(int(Items_TextEdit.text))
		BackPack_TextEdit.text = str(int(BackPack_TextEdit.text))
		pass
	else:
		Popup_WindowDialog.show_me(Global.MessageType.Error)


func _on_Exit_Button_button_up():
	get_tree().quit(0)


func _on_Clear_Button_button_up():
	Value_Weight_TextEdit.text = "0"
	Items_TextEdit.text = "0"
	BackPack_TextEdit.text = "0"
	
