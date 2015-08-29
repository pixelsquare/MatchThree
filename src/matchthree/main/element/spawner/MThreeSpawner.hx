package matchthree.main.element.spawner;

import flambe.display.ImageSprite;
import flambe.display.Texture;
import flambe.script.AnimateTo;
import flambe.script.CallFunction;
import flambe.script.Parallel;
import flambe.script.Script;
import flambe.script.Sequence;
import matchthree.main.element.block.MThreeBlock;
import matchthree.main.element.GameElement;
import matchthree.main.element.grid.IGrid;
import matchthree.main.MThreeMain;
import matchthree.main.element.tile.MThreeTile;
import matchthree.pxlSq.Utils;

/**
 * ...
 * @author Anthony Ganzon
 */
class MThreeSpawner extends GameElement implements IGrid
{
	public var idx(default, null): Int;
	public var idy(default, null): Int;
	
	private var squareTexture: Texture;
	private var squareImage: ImageSprite;
	
	private var blockToCheck: MThreeBlock;
	
	public function new(imgTex: Texture) {
		this.squareTexture = imgTex;
		super();
	}
	
	public function SpawnTiles(): Void {
		var mThreeMain: MThreeMain = parent.get(MThreeMain);
		if (mThreeMain == null)
			return;
		
		if (blockToCheck == null)
			return;
			
		if (blockToCheck.isBlocked)
			return;
			
		if (blockToCheck.IsBlockEmpty()) {
			var tile: MThreeTile = mThreeMain.CreateRandomTileCube(this, false);
			tile.SetAlpha(0.0);
			tile.SetXY(this.x._, this.y._);
			var tileScript: Script = new Script();
			tileScript.run(new Sequence([
				new Parallel([
					new AnimateTo(tile.alpha, 1, GameConstants.TWEEN_SPEED),
					new AnimateTo(tile.y, blockToCheck.grid.y._, GameConstants.TWEEN_SPEED)
				]),
				new CallFunction(function() {
					RemoveAndDispose(tileScript);
				})
			]));
			AddToEntity(tileScript);
		}
	}
	
	public function ShowSpawner(visualize: Bool): Void {
		if (squareImage == null || squareImage.visible)
			return;
		
		squareImage.visible = true;
	}
	
	public function HideSpawner(): Void {
		if (squareImage == null || !squareImage.visible)
			return;
		
		squareImage.visible = false;
	}
	
	override public function Init():Void {
		squareImage = new ImageSprite(squareTexture);
		squareImage.centerAnchor();
	}
	
	override public function Draw():Void {		
		AddToEntity(squareImage);
	}
	
	override public function GetNaturalWidth():Float {
		return squareImage.getNaturalWidth();
	}
	
	override public function GetNaturalHeight():Float {
		return squareImage.getNaturalHeight();
	}
	
	override public function onAdded() {
		super.onAdded();
		
		var mThreeMain: MThreeMain = parent.get(MThreeMain);
		if (mThreeMain != null) {
			blockToCheck = mThreeMain.gridBlocks[idx][idy];
		}
	}
	
	override public function onUpdate(dt:Float) {
		super.onUpdate(dt);
		if (squareImage != null) {
			squareImage.setAlpha(this.alpha._);
			squareImage.setXY(this.x._, this.y._);
			squareImage.setScaleXY(this.scaleX._, this.scaleY._);
		}
		
		SpawnTiles();
	}
	
	/* INTERFACE matchthree.main.element.grid.IGrid */
	
	public function SetGridID(idx:Int, idy:Int, updatePosition:Bool = false): Void {
		this.idx = idx;
		this.idy = idy;
	}
	
	public function GridIDToString():String {
		return "Grid ID [" + this.idx + "," + this.idy + "]";
	}
	
}