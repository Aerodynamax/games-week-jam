extends Panel


func _process(delta: float) -> void:
	$Score.text = "$" + str(Global.score)
