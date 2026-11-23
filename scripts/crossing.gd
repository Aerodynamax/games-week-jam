class_name Crossing extends Area2D

@export var side_a: Path2D
@export var side_b: Path2D

func _get_opposite_side(path: Path2D) -> Path2D:
	if path == side_a:
		return side_b
	else:
		return side_a

#func _on_body_entered(body: Node2D) -> void:
	#print("collided!")
	#var npc = body.get_parent() as NPC
	#if npc != null:
		#npc.try_cross_road(_get_opposite_side(npc.get_parent()))
#
#
#func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	#print("collided!")
	#var npc = body.get_parent() as NPC
	#if npc != null:
		#npc.try_cross_road(_get_opposite_side(npc.get_parent()))


func _on_area_entered(area: Area2D) -> void:
	#var npc = area.get_parent() as NPC
	#if npc != null:
		#if (npc.is_crossing == false):
			#npc.try_cross_road(_get_opposite_side(npc.get_parent()))
