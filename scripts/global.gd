extends Node

#region player

var player: Player:
	get():
		return _get_player()


func _get_player() -> Player:
	for node in get_tree().get_nodes_in_group("Player"):
		if node is Player:
			return node
	return null

#endregion

#region TimeTable
var timetable: TimeTable:
	get():
		return _get_timetable()

func _get_timetable() -> TimeTable:
	for node in get_tree().get_nodes_in_group("timetable"):
		if node is TimeTable:
			return node
	return null
#endregion

#region endscreen

var score : int = 0


var Endscreen: EndScreen:
	get():
		return _get_EndScreen()

func _get_EndScreen() -> EndScreen:
	for node in get_tree().get_nodes_in_group("EndScreen"):
		if node is EndScreen:
			return node
	return null
#endregion
