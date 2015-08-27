package matchthree.main.element;

import flambe.input.PointerEvent;
import flambe.math.Point;
import flambe.util.Signal1;
import matchthree.main.element.grid.MThreeGrid;
import matchthree.main.element.tile.MThreeTile;
import matchthree.main.element.tile.MThreeTileCube;
import matchthree.main.element.tile.MThreeTileData;
import matchthree.core.DataManager;
import flambe.System;
import matchthree.pxlSq.Utils;
import matchthree.main.element.tile.TileDataType;
import matchthree.name.AssetName;
import matchthree.main.utils.MThreeUtils;
import matchthree.main.element.block.MThreeBlock;

/**
 * ...
 * @author Anthony Ganzon
 */
class MThreeMain extends GameElement
{
	public var dataManager(default, null): DataManager;
	public var gridBoard(default, null): Array<Array<MThreeGrid>>;
	public var gridBlocks(default, null): Array<Array<MThreeBlock>>;
	public var tileList(default, null): Array<MThreeTile>;
	
	public var onTilePointerIn: Signal1<MThreeTile>;
	
	private var tileDataTypes: Array<MThreeTileData>;
	
	public function new(dataManager: DataManager) {
		super();
		this.dataManager = dataManager;
		onTilePointerIn = new Signal1<MThreeTile>();
	}
	
	public function CreateGrid(): Void {
		gridBoard = new Array<Array<MThreeGrid>>();
		
		for (x in 0...GameData.GRID_ROWS) {
			var gridArray: Array<MThreeGrid> = new Array<MThreeGrid>();
			for (y in 0...GameData.GRID_COLS) {
				var grid: MThreeGrid = new MThreeGrid(dataManager.gameAsset.getTexture(AssetName.ASSET_CUBE));
				//grid.HideGrid();
				grid.SetGridID(x, y);
				grid.SetParent(owner);
				AddToEntity(grid);
				
				grid.SetXY(
					(this.x._ + (grid.GetNaturalWidth() / 2) * GameData.GRID_OFFSET) + ((x - (GameData.GRID_ROWS / 2)) * grid.GetNaturalWidth()) * GameData.GRID_OFFSET,
					(this.y._ + (grid.GetNaturalHeight() / 2) * GameData.GRID_OFFSET) + ((y - (GameData.GRID_COLS / 2)) * grid.GetNaturalHeight()) * GameData.GRID_OFFSET
				);
				
				gridArray.push(grid);
			}
			gridBoard.push(gridArray);
		}
	}
	
	public function CreateTiles(): Void {
		tileList = new Array<MThreeTile>();
		gridBlocks = new Array<Array<MThreeBlock>>();
		
		for (ii in 0...gridBoard.length) {
			var blockArray: Array<MThreeBlock> = new Array<MThreeBlock>();
			for (grid in gridBoard[ii]) {
				var rand: Int = Math.round(Math.random() * Type.allEnums(TileDataType).length);
				var randIndx: Int = rand % (Type.allEnums(TileDataType).length);
				
				var tile: MThreeTile = CreateTileCube(tileDataTypes[randIndx], grid);
				var block: MThreeBlock = new MThreeBlock(tile, grid);
				blockArray.push(block);
				tileList.push(tile);
				
			}
			gridBlocks.push(blockArray);
		}
		
		//gridBlocks[1][1].SetBlocked();
	}
	
	public function PopulateTileData(): Void {
		tileDataTypes = new Array<MThreeTileData>();
		for (type in Type.allEnums(TileDataType)) {
			var data: MThreeTileData = new MThreeTileData(
				MThreeUtils.GetTileTexture(type, dataManager.gameAsset),
				type
			);
			tileDataTypes.push(data);
		}
	}
	
	public function CreateTileCube(tileData: MThreeTileData, grid: MThreeGrid): MThreeTileCube {
		var tile: MThreeTileCube = new MThreeTileCube(tileData);
		tile.SetParent(owner);
		tile.SetGridID(grid.idx, grid.idy, true);
		AddToEntity(tile);
		return tile;
	}
	
	public function GameControls(): Void {
		var pointerDown: Bool = false;
		var startPoint: Point = new Point();
		var endPoint: Point = new Point();
		var curTile: MThreeTile = null;
		
		onTilePointerIn.connect(function(tile: MThreeTile) {
			Utils.ConsoleLog(tile.GridIDToString());
			curTile = tile;
		});	
	
		System.pointer.down.connect(function(event: PointerEvent) {
			startPoint = new Point(
				event.viewX - (System.stage.width / 2), 
				(System.stage.height / 2) - event.viewY
			);
			endPoint = new Point();
			pointerDown = true;
		});
		
		System.pointer.up.connect(function(event: PointerEvent) {
			if (!pointerDown)
				return;
			
			endPoint = new Point(
				event.viewX - (System.stage.width / 2), 
				(System.stage.height / 2) - event.viewY
			);
			
			var direction: Point = new Point(
				endPoint.x - startPoint.x,
				endPoint.y - startPoint.y
			);
			
			if (curTile != null) {
				if (Math.abs(direction.x) > Math.abs(direction.y)) {
					if (direction.x > 0) {
						
					}
					else {
						
					}
				}
				else {
					if (direction.y > 0) {
						
					}
					else {
						
					}
				}
			}
			
			curTile = null;
			pointerDown = false;
			startPoint = new Point();
			endPoint = new Point();
		});
	}
	
	override public function onStart() {
		super.onStart();

		PopulateTileData();
		CreateGrid();
		CreateTiles();
		//GameControls();
		
		gridBlocks[3][3].SetBlocked();
		
		var curTile: MThreeTile = null;
		onTilePointerIn.connect(function(tile: MThreeTile) {
			//Utils.ConsoleLog((tile == null) + "");
			curTile = tile;
		});	
		
		System.pointer.down.connect(function(event: PointerEvent) {
			//if (curTile == null)
				//return;
			
			curTile.dispose();
		});

		//System.pointer.up.connect(function(event: PointerEvent) {
			//for (tile in tileList) {
				//Utils.ConsoleLog(tile.fillCount + "");
			//}
		//});

		//Utils.ConsoleLog("QWE");
		//gridBlocks[1][7].DestroyTile();
		//gridBlocks[1][7].tile.dispose();
		//tileList[50].dispose();
	
		//for (ii in 0...gridBlocks.length) {
			//for (block in gridBlocks[ii]) {				
				//if (block.IsBlockEmpty()) {
					//Utils.ConsoleLog(block.grid.GridIDToString());
				//}
			//}
		//}
		
		//Utils.ConsoleLog(parent.toString());
		//Utils.ConsoleLog((owner.get(MThreeMain) == null) + "");
	}
	
	override public function onAdded() {
		super.onAdded();
	}
}