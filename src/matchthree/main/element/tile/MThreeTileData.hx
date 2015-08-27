package matchthree.main.element.tile;

import flambe.display.Texture;

/**
 * ...
 * @author Anthony Ganzon
 */
class MThreeTileData
{
	public var tileTexture(default, null): Texture;
	public var tileDataType(default, null): TileDataType;

	public function new(texture: Texture, dataType: TileDataType) {
		tileTexture = texture;
		tileDataType = dataType;
	}
}