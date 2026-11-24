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
		return _get_timetable_ui()

func _get_timetable_ui() -> TimeTable:
	for node in get_tree().get_nodes_in_group("timetable"):
		if node is TimeTable:
			return node
	return null
#endregion
#region screen bounds
var screen_bounds: CollisionShape2D:
	get():
		return _get_screen_bounds()

func _get_screen_bounds() -> CollisionShape2D:
	for node in get_tree().get_nodes_in_group("ScreenBounds"):
		if node is Area2D:
			for child in node.get_children(true):
				if child is CollisionShape2D:
					return child
	return null
#endregion

#region endscreen

var score : float = 0


var Endscreen: EndScreen:
	get():
		return _get_EndScreen()

func _get_EndScreen() -> EndScreen:
	for node in get_tree().get_nodes_in_group("EndScreen"):
		if node is EndScreen:
			return node
	return null
#endregion
