extends Button



func _on_pressed():
	var a: ArgumentData = ArgumentData.new()
	a.MyInt = randi() % 10
	a.MyText = "What is the number?"
	ThreadWorker.PostRequest(a)

