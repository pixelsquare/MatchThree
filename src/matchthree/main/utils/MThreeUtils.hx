package matchthree.main.utils;
import flambe.asset.AssetPack;
import flambe.display.Texture;
import flambe.math.Point;
import flambe.script.AnimateTo;
import flambe.script.CallFunction;
import flambe.script.Parallel;
import flambe.script.Script;
import flambe.script.Sequence;
import matchthree.main.MThreeMain;
import matchthree.main.element.tile.TileDataType;
import matchthree.main.element.tile.TileType;
import matchthree.main.swapping.MThreeSwapDirection;
import matchthree.name.AssetName;
import matchthree.main.element.block.MThreeBlock;
import matchthree.main.element.tile.MThreeTile;
import matchthree.pxlSq.Utils;
import matchthree.main.element.tile.MThreeTileCube;

/**
 * ...
 * @author Anthony Ganzon
 */
class MThreeUtils
{
	private static var mThreeMain: MThreeMain;
	
	public static function SetMThreeMain(main: MThreeMain): Void {
		mThreeMain = main;
	}
	
	public static function GetTileTexture(type: TileDataType, gameAsset: AssetPack): Texture {
		if (type == TileDataType.TILE_TRIANGLE) {
			return gameAsset.getTexture(AssetName.ASSET_GEM_1);
		}
		else if (type == TileDataType.TILE_HEXAGON) {
			return gameAsset.getTexture(AssetName.ASSET_GEM_2);
		}
		else if (type == TileDataType.TILE_SQAURE) {
			return gameAsset.getTexture(AssetName.ASSET_GEM_3);
		}
		else if (type == TileDataType.TILE_HEPTAGON) {
			return gameAsset.getTexture(AssetName.ASSET_GEM_4);
		}
		else if (type == TileDataType.TILE_DIAMOND) {
			return gameAsset.getTexture(AssetName.ASSET_GEM_5);
		}
		else if (type == TileDataType.TILE_CIRCLE) {
			return gameAsset.getTexture(AssetName.ASSET_GEM_6);
		}
		
		return null;
	}
	
	public static function SetTilesKinematic(isKinematic: Bool): Void {
		for (tile in mThreeMain.tileList) {
			tile.SetIsKinematic(isKinematic);
		}
	}
	
	public static function SwapTile(direction: MThreeSwapDirection, tile: MThreeTile, ?fn: Void->Void): Void {
		if (tile == null)
			return;
		
		var idx: Int = tile.idx;
		var idy: Int = tile.idy;
		
		var curBlock: MThreeBlock = mThreeMain.gridBlocks[idx][idy];
		var otherBlock: MThreeBlock = null;
		
		if (direction == MThreeSwapDirection.SWAP_RIGHT) {
			if ((idx + 1) >= GameConstants.GRID_ROWS)
				return;
			
			otherBlock = mThreeMain.gridBlocks[idx + 1][idy];
		}
		else if (direction == MThreeSwapDirection.SWAP_LEFT) {
			if ((idx - 1) < 0)
				return;
			
			otherBlock = mThreeMain.gridBlocks[idx - 1][idy];
		}
		else if (direction == MThreeSwapDirection.SWAP_UP) {
			if ((idy - 1) < 0)
				return;
			
			otherBlock = mThreeMain.gridBlocks[idx][idy - 1];
		}
		else if (direction == MThreeSwapDirection.SWAP_DOWN) {
			if ((idy + 1) >= GameConstants.GRID_COLS)
				return;
			
			otherBlock = mThreeMain.gridBlocks[idx][idy + 1];
		}
		
		if (curBlock == null || otherBlock == null)
			return;
			
		if (curBlock.isBlocked || curBlock.IsBlockEmpty())
			return;
			
		if (otherBlock.isBlocked || otherBlock.IsBlockEmpty())
			return;
			
		var curTile: MThreeTile = curBlock.tile;
		var otherTile: MThreeTile = otherBlock.tile;
		
		if (curTile == null || otherTile == null)
			return;
			
		if (curTile.isAnimating || otherTile.isAnimating)
			return;
			
		var tmpCurPos: Point = new Point(curBlock.grid.x._, curBlock.grid.y._);
		var tmpCurIdx: Int = curBlock.grid.idx;
		var tmpCurIdy: Int = curBlock.grid.idy;
		
		curTile.isAnimating = true;
		otherTile.isAnimating = true;
		
		var swapScript = new Script();
		swapScript.run(new Sequence([
			new Parallel([
				new AnimateTo(curTile.x, otherBlock.grid.x._, GameConstants.TWEEN_SPEED),
				new AnimateTo(curTile.y, otherBlock.grid.y._, GameConstants.TWEEN_SPEED),
				new AnimateTo(otherTile.x, tmpCurPos.x, GameConstants.TWEEN_SPEED),
				new AnimateTo(otherTile.y, tmpCurPos.y, GameConstants.TWEEN_SPEED)
			]),
			new CallFunction(function() {
				otherTile.SetGridID(curBlock.grid.idx, curBlock.grid.idy);
				curTile.SetGridID(otherBlock.grid.idx, otherBlock.grid.idy);
				
				curBlock.SetBlockTile(otherTile);
				otherBlock.SetBlockTile(curTile);
				
				mThreeMain.RemoveAndDispose(swapScript);
				
				curTile.isAnimating = false;
				otherTile.isAnimating = false;
				
				if (fn != null) { fn(); }
			})
		]));
		mThreeMain.AddToEntity(swapScript);
	}
	
	public static function GetTilesOfType(type: TileDataType): Array<MThreeTileCube> {
		var tiles: Array<MThreeTileCube> = new Array<MThreeTileCube>();
		for (tile in mThreeMain.tileCubeList) {
			if (tile.GetTileDataType() != type)
				continue;
				
			tiles.push(tile);
		}
		
		return tiles;
	}

	public static function GetShortCrossedTiles(tile: MThreeTileCube): Array<MThreeTileCube> {
		var result: Array<MThreeTileCube> = new Array<MThreeTileCube>();
		
		var idx: Int = tile.idx;
		var idy: Int = tile.idy;
		
		//Utils.ConsoleLog(((idx + 1) < GameConstants.GRID_ROWS) + " Right");
		if ((idx + 1) < GameConstants.GRID_ROWS) {
			result.push(cast(mThreeMain.gridBlocks[idx + 1][idy].tile, MThreeTileCube));
		}
		
		//Utils.ConsoleLog(((idx - 1) >= 0) + " Left");
		if ((idx - 1) >= 0) {
			result.push(cast(mThreeMain.gridBlocks[idx - 1][idy].tile, MThreeTileCube));
		}
		
		//Utils.ConsoleLog(((idy + 1) < GameConstants.GRID_COLS) + " Bottom");
		if ((idy + 1) < GameConstants.GRID_COLS) {
			result.push(cast(mThreeMain.gridBlocks[idx][idy + 1].tile, MThreeTileCube));
		}
		
		//Utils.ConsoleLog(((idy - 1) >= 0) + " Up");
		if ((idy - 1) >= 0) {
			result.push(cast(mThreeMain.gridBlocks[idx][idy - 1].tile, MThreeTileCube));
		}
		
		return result;
	}
	
	public static function GetLongCrossedTiles(tile: MThreeTileCube): Array<MThreeTileCube> {
		var result: Array<MThreeTileCube> = new Array<MThreeTileCube>();
		
		var idx: Int = tile.idx;
		var idy: Int = tile.idy;
		
		//Utils.ConsoleLog(((idx + 1) < GameConstants.GRID_ROWS) + " Right");
		if ((idx + 2) < GameConstants.GRID_ROWS) {
			result.push(cast(mThreeMain.gridBlocks[idx + 2][idy].tile, MThreeTileCube));
		}
		
		//Utils.ConsoleLog(((idx - 1) >= 0) + " Left");
		if ((idx - 2) >= 0) {
			result.push(cast(mThreeMain.gridBlocks[idx - 2][idy].tile, MThreeTileCube));
		}
		
		//Utils.ConsoleLog(((idy + 1) < GameConstants.GRID_COLS) + " Bottom");
		if ((idy + 2) < GameConstants.GRID_COLS) {
			result.push(cast(mThreeMain.gridBlocks[idx][idy + 2].tile, MThreeTileCube));
		}
		
		//Utils.ConsoleLog(((idy - 1) >= 0) + " Up");
		if ((idy - 2) >= 0) {
			result.push(cast(mThreeMain.gridBlocks[idx][idy - 2].tile, MThreeTileCube));
		}
		
		return result;
	}
	
	public static function GetHorizontal(tile: MThreeTileCube): Array<MThreeTileCube> {
		var result: Array<MThreeTileCube> = new Array<MThreeTileCube>();
		
		var idx: Int = tile.idx;
		var idy: Int = tile.idy;
		
		var prevBlock: MThreeBlock = null;
		while (idx > 0) {			
			prevBlock = mThreeMain.gridBlocks[idx - 1][idy];
			if (cast(prevBlock.tile, MThreeTileCube).GetTileDataType() != tile.GetTileDataType())
				break;
				
			result.push(cast(prevBlock.tile, MThreeTileCube));
			idx--;
		}
		
		idx = tile.idx;
		var nextBlock: MThreeBlock = null;
		while (idx < (GameConstants.GRID_ROWS - 1)) {			
			//Utils.ConsoleLog((idx + 1) + "");
			nextBlock = mThreeMain.gridBlocks[idx + 1][idy];
			if (cast(nextBlock.tile, MThreeTileCube).GetTileDataType() != tile.GetTileDataType())
				break;
			
			//if (!Lambda.has(result, cast(nextBlock.tile, MThreeTileCube))) {
				result.push(cast(nextBlock.tile, MThreeTileCube));
				idx++;
			//}
		}
		
		//Utils.ConsoleLog(tile.GridIDToString() + " " + result.length);
		return result;
	}
	
	public static function GetVertical(tile: MThreeTileCube): Array<MThreeTileCube> {
		var result: Array<MThreeTileCube> = new Array<MThreeTileCube>();
		
		var idx: Int = tile.idx;
		var idy: Int = tile.idy;
		
		var prevBlock: MThreeBlock = null;
		while (idy > 0) {
			prevBlock = mThreeMain.gridBlocks[idx][idy - 1];
			if (cast(prevBlock.tile, MThreeTileCube).GetTileDataType() != tile.GetTileDataType())
				break;
				
			result.push(cast(prevBlock.tile, MThreeTileCube));
			idy--;
		}
		
		idy = tile.idy;
		var nextBlock: MThreeBlock = null;
		while (idy < (GameConstants.GRID_COLS - 1)) {
			nextBlock = mThreeMain.gridBlocks[idx][idy + 1];
			if (cast(nextBlock.tile, MThreeTileCube).GetTileDataType() != tile.GetTileDataType())
				break;
				
			result.push(cast(nextBlock.tile, MThreeTileCube));
			idy++;
		}
		
		return result;
	}
	
	public static function GetAllMatches(): Array<Array<MThreeTileCube>> {
		var result: Array<Array<MThreeTileCube>> = new Array<Array<MThreeTileCube>>();
		
		for (dataType in Type.allEnums(TileDataType)) {
			var tiles: Array<MThreeTileCube> = GetTilesOfType(dataType);
			
			var vertical: Array<MThreeTileCube> = new Array<MThreeTileCube>();
			var horizontal: Array<MThreeTileCube> = new Array<MThreeTileCube>();

			//Utils.ConsoleLog(dataType + "");
			for (tile in tiles) {
				var hTiles: Array<MThreeTileCube> = GetHorizontal(tile);
				hTiles.push(tile);
				
				if (hTiles.length >= 3) {	
					for (h in hTiles) {
						if (Lambda.has(horizontal, h))
							continue;
						
						horizontal.push(h);
					}
					//horizontal = horizontal.concat(hTiles);
				}
				
				var vTiles: Array<MThreeTileCube> = GetVertical(tile);
				vTiles.push(tile);
				
				if (vTiles.length >= 3) {		
					for (v in vTiles) {
						if (Lambda.has(vertical, v))
							continue;
							
						vertical.push(v);
					}
					//vertical = vertical.concat(vTiles);
				}
			}
			
			// Combining vertical and horizontal if an intersection has occured
			var intersectingTiles: Array<MThreeTileCube> = GetIntersection(vertical, horizontal);
			if (intersectingTiles.length > 0) {
				result.push(intersectingTiles);
			}
			else {		
				if(horizontal.length >= 3) {
					result.push(horizontal);
				}
				
				if(vertical.length >= 3) {
					result.push(vertical);
				}
			}
		}
		
		return result;
	}	
	
	public static function GetIntersection(vert: Array<MThreeTileCube>, horiz: Array<MThreeTileCube>): Array<MThreeTileCube> {
		var result: Array<MThreeTileCube> = new Array<MThreeTileCube>();
		
		for (vTile in vert) {
			for (hTile in horiz) {
				if (vTile == hTile) {
					result = vert;
					result = result.concat(horiz);
				}
			}
		}
		
		return result;
	}
	
	public static function CheckPossibleMoves(): Bool {
		
		for (dataType in Type.allEnums(TileDataType)) {
			var tiles: Array<MThreeTileCube> = GetTilesOfType(dataType);
			
			for (tile in tiles) {
				var crossedTiles: Array<MThreeTileCube> = GetShortCrossedTiles(tile);
				crossedTiles = crossedTiles.concat(GetLongCrossedTiles(tile));
				var typeCount: Map<TileDataType, Int> = new Map<TileDataType, Int>();
				
				//Utils.ConsoleLog(tile.GridIDToString());
				var count: Int = 0;
				for (t in crossedTiles) {
					count = typeCount.get(t.GetTileDataType());
					count++;
					typeCount.set(t.GetTileDataType(), count);
				}
				
				for (key in typeCount.keys()) {
					if (typeCount.get(key) >= 3) {
						return true;
					}
					//Utils.ConsoleLog(key + " " + typeCount.get(key));
				}
				
				//Utils.ConsoleLog("---");
			}
		}
		
		return false;
	}
	
	public static function HasMovingBlocks(): Bool {
		var count: Int = 0;
		for (tile in mThreeMain.tileList) {
			if (tile != null && !tile.isAnimating)
				continue;
			
			count++;
		}
		
		return count > 0;
	}
}