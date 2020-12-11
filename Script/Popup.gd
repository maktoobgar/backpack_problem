extends WindowDialog

export(NodePath) var Title_NodePath
export(NodePath) var Info_NodePath
export(NodePath) var Description_NodePath
var Title_Label: Label
var Info_Label: Label
var Description_TextEdit: TextEdit


func _ready():
	print(Title_NodePath)
	Title_Label = get_node(Title_NodePath)
	Info_Label = get_node(Info_NodePath)
	Description_TextEdit = get_node(Description_NodePath)

func show_me(type):
	print("here")
	if type == Global.MessageType.Error:
		Title_Label.text = "Error:"
		Info_Label.text = "Inserted numbers in textbox\'s are not valid."
		Description_TextEdit.text = "Allowed numbers must be:\n1) Integer.\n2) Bigger than 0.\n3) And ofcourse other characters than numbers are not allowed."
	popup_centered()


func _on_OK_Button_button_up():
	self.visible = false;
