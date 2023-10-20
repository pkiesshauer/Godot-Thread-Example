extends TextEdit

func _ready():
	ThreadWorker.OutputReady.connect(DisplayOutput)

func DisplayOutput(result: ArgumentData):
	text = text + result.MyText + ".\n"
