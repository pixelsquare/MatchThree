package matchthree.main.element;

import matchthree.main.element.grid.MThreeGrid;
import matchthree.main.element.tile.MThreeTile;
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
	public var gridBlocks(default, null): Array<MThreeBlock>;
	public var tileList(default, null): Array<MThreeTile>;
	
	private var tileDataTypes: Array<MThreeTileData>;
	
	public function new(dataManager: DataManager) {
		super();
		this.dataManager = dataManager;
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
					this.x._ + ((x - (GameData.GRID_ROWS / 2)) * grid.GetNaturalWidth() * GameData.GRID_OFFSET),
					this.y._ + ((y - (GameData.GRID_COLS / 2)) * grid.GetNaturalHeight() * GameData.GRID_OFFSET)
				);
				
				gridArray.push(grid);
			}
			gridBoard.push(gridArray);
		}
	}
	
	public function CreateTiles(): Void {
		tileList = new Array<MThreeTile>();
		
		for (ii in 0...gridBoard.length) {
			for (grid in gridBoard[ii]) {
				var rand: Int = Math.round(Math.random() * Type.allEnums(TileDataType).length);
				var randIndx: Int = rand % (Type.allEnums(TileDataType).length);
				
				CreateTile(tileDataTypes[randIndx], grid);
			}
		}
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
	
	public function CreateTile(tileData: MThreeTileData, grid: MThreeGrid): MThreeTile {
		var tile: MThreeTile = new MThreeTile(tileData);
		tile.SetParent(owner);
		tile.SetGridID(grid.idx, grid.idy, true);
		AddToEntity(tile);
		return tile;
	}
	
	override public function onStart() {
		super.onStart();
		
		PopulateTileData();
		CreateGrid();
		CreateTiles();


	
		
		//Utils.ConsoleLog(parent.toString());
		//Utils.ConsoleLog((owner.get(MThreeMain) == null) + "");
	}
	
	override public function onAdded() {
		super.onAdded();
	}
}