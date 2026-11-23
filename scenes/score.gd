extends Panel

var score :int = 0

func add_score(points : int):
	score +=points
	$Score.text= "$" + str(score)
