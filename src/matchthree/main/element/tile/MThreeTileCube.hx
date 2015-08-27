package matchthree.main.element.tile;

import flambe.display.ImageSprite;

/**
 * ...
 * @author Anthony Ganzon
 */
class MThreeTileCube extends MThreeTileTouch
{
	public var tileData(default, set): MThreeTileData;
	
	private var tileDataType: TileDataType;	
	
	public function new(tileData:MThreeTileData) {
		this.tileData = tileData;
		super();
	}
	
	override public function Init(): Void {
		if (tileData != null) {
			tileImage = new ImageSprite(tileTexture);
			tileImage.centerAnchor();
		}
	}
	
	function set_tileData(newData: MThreeTileData): MThreeTileData {
		tileTexture = newData.tileTexture;
		tileDataType = newData.tileDataType;
		return tileData = newData;
	}
	
	public function GetTileDataType(): TileDataType {
		return tileDataType;
	}
}