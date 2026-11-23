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
