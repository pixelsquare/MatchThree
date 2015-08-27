package matchthree.main.element;

import matchthree.main.element.grid.MThreeGrid;
import matchthree.main.element.tile.MThreeTile;
import matchthree.main.element.tile.MThreeTileData;
import matchthree.core.DataManager;
import flambe.System;
import matchthree.pxlSq.Utils;
import matchthree.main.element.tile.TileDataType;
import matchthree.name.AssetName;

/**
 * ...
 * @author Anthony Ganzon
 */
class MThreeMain extends GameElement
{
	public var dataManager(default, null): DataManager;
	public var gridBoard(default, null): Array<Array<MThreeGrid>>;
	public var tileList(default, null): Array<MThreeTile>;
	
	public function new(dataManager: DataManager) {
		super();
		this.dataManager = dataManager;
	}
	
	public function CreateGrid(): Void {
		gridBoard = new Array<Array<MThreeGrid>>();
		
		for (x in 0...GameData.GRID_ROWS) {
			var gridArray: Array<MThreeGrid> = new Array<MThreeGrid>();
			for (y in 0...GameData.GRID_COLS) {
				var grid: MThreeGrid = new MThreeGrid();
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
	}
	
	override public function onStart() {
		super.onStart();
		
		CreateGrid();
		
		//var tile: MThreeTile = new MThreeTile();
		//tile.tileData = new MThreeTileData(dataManager.gameAsset.getTexture(AssetName.ASSET_GEM_1), TileDataType.TILE_TRIANGLE);
		//tile.SetParent(owner);
		//tile.SetGridID(0, 0, true);
		//AddToEntity(tile);

	
		
		//Utils.ConsoleLog(parent.toString());
		//Utils.ConsoleLog((owner.get(MThreeMain) == null) + "");
	}
	
	override public function onAdded() {
		super.onAdded();
	}
}