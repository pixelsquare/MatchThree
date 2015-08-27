package matchthree.main.element.tile;

import flambe.display.ImageSprite;
import flambe.display.Texture;
import matchthree.main.element.GameElement;
import matchthree.main.element.grid.IGrid;
import matchthree.pxlSq.Utils;
import matchthree.main.element.grid.MThreeGrid;

/**
 * ...
 * @author Anthony Ganzon
 */
class MThreeTile extends GameElement implements IGrid
{
	public var idx(default, null): Int;
	public var idy(default, null): Int;
	
	public var tileData(default, set): MThreeTileData;
	
	private var tileTexture: Texture;
	private var tileImage: ImageSprite;
	private var tileDataType: TileDataType;
	
	public function new(tileData: MThreeTileData) {
		this.tileData = tileData;
		super();
	}
	
	function set_tileData(newData: MThreeTileData): MThreeTileData {
		tileTexture = newData.tileTexture;
		tileDataType = newData.tileDataType;
		return tileData = newData;
	}
	
	public function GetTileDataType(): TileDataType {
		return tileDataType;
	}
	
	override public function Init(): Void {
		if (tileData != null) {
			tileImage = new ImageSprite(tileTexture);
			tileImage.centerAnchor();
		}
	}
	
	override public function GetNaturalWidth():Float {
		return tileImage.getNaturalWidth();
	}
	
	override public function GetNaturalHeight():Float {
		return tileImage.getNaturalHeight();
	}
	
	override public function Draw(): Void {
		AddToEntity(tileImage);
	}
	
	override public function onUpdate(dt:Float) {
		super.onUpdate(dt);
		if (tileImage != null) {
			tileImage.setAlpha(this.alpha._);
			tileImage.setXY(this.x._, this.y._);
			tileImage.setScaleXY(this.scaleX._, this.scaleY._);
		}
	}
	
	public function SetGridID(idx: Int, idy: Int, updatePosition: Bool = false): Void {
		this.idx = idx;
		this.idy = idy;
		
		if (updatePosition) {
			var grid: MThreeGrid = parent.get(MThreeMain).gridBoard[this.idx][this.idy];
			SetXY(grid.x._, grid.y._);
		}
	}
	
	public function GridIDToString(): String {
		return "Grid ID [" + this.idx + "," + this.idy + "]";
	}
}