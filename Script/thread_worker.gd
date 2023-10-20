extends Node

signal OutputReady(result: ArgumentData)

var semaphore: Semaphore
var mutex: Mutex
var thread: Thread
var exit_thread:bool

var InputQueue: Array[ArgumentData]
var OutputQueue: Array[ArgumentData]

func _ready():
	mutex = Mutex.new()
	semaphore = Semaphore.new()
	thread = Thread.new()
	exit_thread = false
	thread.start(thread_function)

func PostRequest(argument: ArgumentData):
	mutex.lock()
	InputQueue.push_back(argument)
	mutex.unlock()
	semaphore.post()

func thread_function():
	while true:
		semaphore.wait()
		mutex.lock()
		var should_exit = exit_thread # Protect with Mutex.
		mutex.unlock()
		if should_exit:
			break
		WorkOnStuff()

func WorkOnStuff():
	mutex.lock()
	if InputQueue.size() == 0: return
	var a = InputQueue.pop_front()
	mutex.unlock()
	
	#simulate a task that takes a while
	await(get_tree().create_timer(1).timeout)
	a.MyText = "The number was " + str(a.MyInt)
	
	mutex.lock()
	OutputQueue.push_back(a)
	mutex.unlock()

func _process(delta):
	while OutputQueue.size() > 0:
		OutputReady.emit(OutputQueue.pop_front())

func _exit_tree():
	mutex.lock()
	exit_thread = true
	mutex.unlock()
	semaphore.post()
	thread.wait_to_finish()
