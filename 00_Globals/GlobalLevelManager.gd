extends Node

var curret_titlemap_bounds : Array[Vector2]
signal TileMapBoundsChanged(bounds:Array[Vector2])

func ChangeTilemapBounds(bounds:Array[Vector2]) -> void:
	curret_titlemap_bounds = bounds
	TileMapBoundsChanged.emit(bounds)
