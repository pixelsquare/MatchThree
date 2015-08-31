package matchthree.main.utils;

import flambe.asset.AssetPack;
import flambe.display.Texture;
import flambe.math.Point;
import flambe.script.AnimateTo;
import flambe.script.CallFunction;
import flambe.script.Parallel;
import flambe.script.Script;
import flambe.script.Sequence;

import matchthree.main.element.block.MThreeBlock;
import matchthree.main.element.tile.MThreeTile;
import matchthree.main.element.tile.MThreeTileCube;
import matchthree.main.element.tile.TileDataType;
import matchthree.main.MThreeMain;
import matchthree.main.swapping.MThreeSwapDirection;
import matchthree.name.AssetName;

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
	
	public static function GetBlockedAndEmptyCount(): Int {
		var result: Int = 0;
		
		for (ii in 0...mThreeMain.gridBlocks.length) {
			for (block in mThreeMain.gridBlocks[ii]) {
				if (block.isBlocked || block.IsBlockEmpty()) {	
					result++;
				}
			}
		}
		
		return result;
	}
	
	public static function SwapTile(direction: MThreeSwapDirection, tile: MThreeTile, ?fn: Void->Void, animate: Bool = true): Void {
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
		
		if (animate) {
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
		else {
			curTile.x._ = otherBlock.grid.x._;
			curTile.y._ = otherBlock.grid.y._;
			
			otherTile.x._ = tmpCurPos.x;
			otherTile.y._ = tmpCurPos.y;
			
			otherTile.SetGridID(curBlock.grid.idx, curBlock.grid.idy);
			curTile.SetGridID(otherBlock.grid.idx, otherBlock.grid.idy);
			
			curBlock.SetBlockTile(otherTile);
			otherBlock.SetBlockTile(curTile);	
			
			if (fn != null) { fn(); }
		}
	}
	
	public static function GetTilesOfType(type: TileDataType): Array<MThreeTileCube> {
		var tiles: Array<MThreeTileCube> = new Array<MThreeTileCube>();
		for (tile in mThreeMain.tileList) {
			if (cast(tile, MThreeTileCube).GetTileDataType() != type)
				continue;
				
			tiles.push(cast(tile, MThreeTileCube));
		}
		
		return tiles;
	}
	
	public static function GetCrossedTiles(tile: MThreeTileCube, length: Int): Array<MThreeTileCube> {
		var result: Array<MThreeTileCube> = new Array<MThreeTileCube>();
		
		var idx: Int = tile.idx;
		var idy: Int = tile.idy;
		
		for (i in 1...(length + 1)) {
			var block: MThreeBlock = null;
			// Right
			if ((idx + i) < GameConstants.GRID_ROWS) {
				block = mThreeMain.gridBlocks[idx + i][idy];
				if(!block.isBlocked && !block.IsBlockEmpty()) {
					result.push(cast(block.tile, MThreeTileCube));
				}
			}
			
			// Left
			if ((idx - i) >= 0) {
				block = mThreeMain.gridBlocks[idx - i][idy];
				if(!block.isBlocked && !block.IsBlockEmpty()) {
					result.push(cast(block.tile, MThreeTileCube));
				}
			}
			
			// Bottom
			if ((idy + i) < GameConstants.GRID_COLS) {
				block = mThreeMain.gridBlocks[idx][idy + i];
				if(!block.isBlocked && !block.IsBlockEmpty()) {
					result.push(cast(block.tile, MThreeTileCube));
				}
			}
			
			// Top
			if ((idy - i) >= 0) {
				block = mThreeMain.gridBlocks[idx][idy - i];
				if(!block.isBlocked && !block.IsBlockEmpty()) {
					result.push(cast(block.tile, MThreeTileCube));
				}
			}
			
		}
		
		return result;		
	}
	
	public static function GetDiagonalTiles(tile: MThreeTileCube, length: Int): Array<MThreeTileCube> {
		var result: Array<MThreeTileCube> = new Array<MThreeTileCube>();
		
		var idx: Int = tile.idx;
		var idy: Int = tile.idy;
		
		for (i in 1...(length + 1)) {
			var block: MThreeBlock = null;
			
			// Upper right
			if ((idx + i) < GameConstants.GRID_ROWS && (idy - i) >= 0) {
				block = mThreeMain.gridBlocks[idx + i][idy - i];
				if (!block.isBlocked && !block.IsBlockEmpty()) {
					result.push(cast(block.tile, MThreeTileCube));
				}
			}
			
			// Bottom Right
			if ((idx + i) < GameConstants.GRID_ROWS && (idy + i) < GameConstants.GRID_COLS) {
				block = mThreeMain.gridBlocks[idx + i][idy + i];
				if (!block.isBlocked && !block.IsBlockEmpty()) {
					result.push(cast(block.tile, MThreeTileCube));
				}
			}
			
			// Upper left
			if ((idx - i) >= 0 && (idy - i) >= 0) {
				block = mThreeMain.gridBlocks[idx - i][idy - i];
				if (!block.isBlocked && !block.IsBlockEmpty()) {
					result.push(cast(block.tile, MThreeTileCube));
				}
			}
			
			// Bottom Left
			if ((idx - i) >= 0 && (idy + i) < GameConstants.GRID_COLS) {
				block = mThreeMain.gridBlocks[idx - i][idy + i];
				if (!block.isBlocked && !block.IsBlockEmpty()) {
					result.push(cast(block.tile, MThreeTileCube));
				}
			}
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
			if (prevBlock.isBlocked || prevBlock.IsBlockEmpty()) {
				idx--;
				continue;
			}
			
			if (cast(prevBlock.tile, MThreeTileCube).GetTileDataType() != tile.GetTileDataType())
				break;
				
			result.push(cast(prevBlock.tile, MThreeTileCube));
			idx--;
		}
		
		idx = tile.idx;
		var nextBlock: MThreeBlock = null;
		while (idx < (GameConstants.GRID_ROWS - 1)) {			
			nextBlock = mThreeMain.gridBlocks[idx + 1][idy];
			if (nextBlock.isBlocked || nextBlock.IsBlockEmpty()) {
				idx++;
				continue;
			}
			
			if (cast(nextBlock.tile, MThreeTileCube).GetTileDataType() != tile.GetTileDataType())
				break;
			

			result.push(cast(nextBlock.tile, MThreeTileCube));
			idx++;
		}
		
		return result;
	}
	
	public static function GetVertical(tile: MThreeTileCube): Array<MThreeTileCube> {
		var result: Array<MThreeTileCube> = new Array<MThreeTileCube>();
		
		var idx: Int = tile.idx;
		var idy: Int = tile.idy;
		
		var prevBlock: MThreeBlock = null;
		while (idy > 0) {
			prevBlock = mThreeMain.gridBlocks[idx][idy - 1];
			if (prevBlock.isBlocked || prevBlock.IsBlockEmpty()) {
				idy--;
				continue;
			}

			if (cast(prevBlock.tile, MThreeTileCube).GetTileDataType() != tile.GetTileDataType())
				break;
				
			result.push(cast(prevBlock.tile, MThreeTileCube));
			idy--;
		}
		
		idy = tile.idy;
		var nextBlock: MThreeBlock = null;
		while (idy < (GameConstants.GRID_COLS - 1)) {
			nextBlock = mThreeMain.gridBlocks[idx][idy + 1];
			if (nextBlock.isBlocked || nextBlock.IsBlockEmpty()) {
				idy++;
				continue;
			}
				
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
				}
				
				var vTiles: Array<MThreeTileCube> = GetVertical(tile);
				vTiles.push(tile);
				
				if (vTiles.length >= 3) {		
					for (v in vTiles) {
						if (Lambda.has(vertical, v))
							continue;
							
						vertical.push(v);
					}
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
	
	public static function HasPossbileMoves(): Bool {
		var possbileMatches: Int = 0;
		
		for (x in 0...mThreeMain.gridBlocks.length) {
			for (y in 0...mThreeMain.gridBlocks[x].length) {
				if (x < GameConstants.GRID_ROWS) {
					SwapTile(SWAP_RIGHT, mThreeMain.gridBlocks[x][y].tile, function() {
						possbileMatches += GetAllMatches().length;
						
						SwapTile(SWAP_LEFT, mThreeMain.gridBlocks[x + 1][y].tile, false);
					}, false);
				}
				
				if (y < GameConstants.GRID_COLS) {
					SwapTile(SWAP_DOWN, mThreeMain.gridBlocks[x][y].tile, function() {
						possbileMatches += GetAllMatches().length;
						
						SwapTile(SWAP_UP, mThreeMain.gridBlocks[x][y + 1].tile, false);
					}, false);
				}
			}
		}
		
		return possbileMatches > 0;
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
	
	public static function GetScore(tiles: Array<MThreeTileCube>): Float {
		var score: Float = 0.0;
		
		if (tiles.length < 4) {
			score = tiles.length * GameConstants.TILE_SCORE;
			mThreeMain.ShowPopup(tiles, GameConstants.TILE_SCORE + "");
		}
		else if (tiles.length > 4) {
			score = tiles.length * GameConstants.TILE_SCORE * 3;
			mThreeMain.ShowPopup(tiles, (GameConstants.TILE_SCORE * 3) + "");
		}
		else {
			score = tiles.length * GameConstants.TILE_SCORE * 2;
			mThreeMain.ShowPopup(tiles, (GameConstants.TILE_SCORE * 2) + "");
		}
		
		return score;
	}
}