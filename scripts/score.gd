extends Panel


func _process(_delta: float) -> void:
	$Score.text = "$" + str(Global.score)
