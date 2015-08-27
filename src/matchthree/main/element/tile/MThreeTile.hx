package matchthree.main.element.tile;

import flambe.display.ImageSprite;
import flambe.display.Texture;
import flambe.Entity;
import flambe.script.AnimateTo;
import flambe.script.CallFunction;
import flambe.script.Parallel;
import flambe.script.Script;
import flambe.script.Sequence;
import matchthree.main.element.block.MThreeBlock;
import matchthree.main.element.GameElement;
import matchthree.main.element.grid.IGrid;
import matchthree.main.element.MThreeMain;
import matchthree.pxlSq.Utils;
import matchthree.main.element.grid.MThreeGrid;
import matchthree.main.utils.MThreeUtils;

/**
 * ...
 * @author Anthony Ganzon
 */
class MThreeTile extends GameElement implements IGrid
{
	public var idx(default, null): Int;
	public var idy(default, null): Int;
	public var isAnimating: Bool;
	
	private var tileTexture: Texture;
	private var tileImage: ImageSprite;
	
	public var fillCount: Int = 1;

	public function new() {
		super();
	}
	
	public function SetFillCount(value: Int): Void {
		this.fillCount = value;
	}
	
	public function GetTileType(): TileType {
		return null;
	}
	
	override public function Init(): Void {
		tileImage = new ImageSprite(tileTexture);
		tileImage.centerAnchor();
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
	
	public function UpdateDropPosition(): Void {
		if ((idy + 1) >= GameData.GRID_COLS || isAnimating)
			return;
			
		var mThreeMain: MThreeMain = parent.get(MThreeMain);
		if (mThreeMain == null)
			return;
			
		var nextBlock: MThreeBlock = mThreeMain.gridBlocks[idx][idy + 1];
		if (nextBlock == null || nextBlock.isBlocked)
			return;
			
		if (nextBlock.IsBlockEmpty()) {
			mThreeMain.gridBlocks[idx][idy].SetBlockTile(null);
			nextBlock.SetBlockTile(this);
			isAnimating = true;
			
			var tileScript: Script = new Script();
			tileScript.run(new Sequence([
				new AnimateTo(this.y, nextBlock.grid.y._, GameData.TILE_TWEEN_SPEED),
				new CallFunction(function() {
					SetGridID(nextBlock.grid.idx, nextBlock.grid.idy);
					elementEntity.removeChild(new Entity().add(tileScript));
					tileScript.dispose();
					isAnimating = false;
				})
			]));
			elementEntity.addChild(new Entity().add(tileScript));
		}
	}
	
	public function UpdateFillRight(): Void {
		if ((idx + 1) >= GameData.GRID_ROWS || (idy + 1) > GameData.GRID_COLS)
			return;
			
		if (isAnimating || fillCount == 1)
			return;
			
		var mThreeMain: MThreeMain = parent.get(MThreeMain);
		if (mThreeMain == null)
			return;
			
		var rightBlock: MThreeBlock = mThreeMain.gridBlocks[idx + 1][idy];
		var bottomBlock: MThreeBlock = mThreeMain.gridBlocks[idx][GameData.GRID_COLS - 1];
		
		if (rightBlock == null || bottomBlock == null)
			return;
			
		if (rightBlock.isBlocked || rightBlock.IsBlockEmpty()) {
			var bottomRight: MThreeBlock = mThreeMain.gridBlocks[idx + 1][idy + 1];
			if (bottomRight == null)
				return;
			
			var curBlock: MThreeBlock = mThreeMain.gridBlocks[idx][idy];
			if (bottomRight.IsBlockEmpty() && !bottomRight.isBlocked) {
				curBlock.SetBlockTile(null);
				bottomRight.SetBlockTile(this);
				isAnimating = true;
				
				var tileScript: Script = new Script();
				tileScript.run(new Sequence([
					new Parallel([
						new AnimateTo(this.x, bottomRight.grid.x._, GameData.TILE_TWEEN_SPEED),
						new AnimateTo(this.y, bottomRight.grid.y._, GameData.TILE_TWEEN_SPEED)
					]),
					new CallFunction(function() {
						SetGridID(bottomRight.grid.idx, bottomRight.grid.idy);
						elementEntity.removeChild(new Entity().add(tileScript));
						tileScript.dispose();
						MThreeUtils.SetTilesFillCount(mThreeMain.tileList, 1);
						isAnimating = false;
					})
				]));
				elementEntity.addChild(new Entity().add(tileScript));
			}
		}
	}
	
	public function UpdateFillLeft(): Void {
		if ((idx - 1) < 0 || (idy - 1) < 0)
			return;
			
		if (isAnimating || fillCount == 0)
			return;

		var mThreeMain: MThreeMain = parent.get(MThreeMain);
		if (mThreeMain == null)
			return;

		var leftBlock: MThreeBlock = mThreeMain.gridBlocks[idx - 1][idy];
		var bottomBlock: MThreeBlock = mThreeMain.gridBlocks[idx][GameData.GRID_COLS - 1];
		
		if (leftBlock == null || bottomBlock == null)
			return;
			
		if (leftBlock.isBlocked || leftBlock.IsBlockEmpty()) {
			var bottomLeft: MThreeBlock = mThreeMain.gridBlocks[idx - 1][idy + 1];
			if (bottomLeft == null)
				return;
				
			var curBlock: MThreeBlock = mThreeMain.gridBlocks[idx][idy];
			if (bottomLeft.IsBlockEmpty() && !bottomLeft.isBlocked) {
				curBlock.SetBlockTile(null);
				bottomLeft.SetBlockTile(this);
				isAnimating = true;
				
				var tileScript: Script = new Script();
				tileScript.run(new Sequence([
					new Parallel([
						new AnimateTo(this.x, bottomLeft.grid.x._, GameData.TILE_TWEEN_SPEED),
						new AnimateTo(this.y, bottomLeft.grid.y._, GameData.TILE_TWEEN_SPEED)
					]),
					new CallFunction(function() {
						SetGridID(bottomLeft.grid.idx, bottomLeft.grid.idy);
						elementEntity.removeChild(new Entity().add(tileScript));
						tileScript.dispose();
						MThreeUtils.SetTilesFillCount(mThreeMain.tileList, 0);
						isAnimating = false;
					})
				]));
				elementEntity.addChild(new Entity().add(tileScript));
			}
		}
	}
	
	override public function onUpdate(dt:Float) {
		super.onUpdate(dt);
		if (tileImage != null) {
			tileImage.setAlpha(this.alpha._);
			tileImage.setXY(this.x._, this.y._);
			tileImage.setScaleXY(this.scaleX._, this.scaleY._);
			
			UpdateDropPosition();
			UpdateFillRight();
			UpdateFillLeft();
		}
	}
	
	override public function dispose() {
		super.dispose();
		//Utils.ConsoleLog("Disposing " + GridIDToString());
		
		var mThreeMain: MThreeMain = parent.get(MThreeMain);
		if (mThreeMain != null) {
			mThreeMain.gridBlocks[idx][idy].SetBlockTile(null);
			mThreeMain.tileList.remove(this);
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