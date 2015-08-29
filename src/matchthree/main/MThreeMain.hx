package matchthree.main;

import flambe.input.KeyboardEvent;
import flambe.input.PointerEvent;
import flambe.math.Point;
import flambe.script.CallFunction;
import flambe.script.Delay;
import flambe.script.Repeat;
import flambe.script.Script;
import flambe.script.Sequence;
import flambe.util.Signal1;
import matchthree.main.element.grid.IGrid;
import matchthree.main.element.grid.MThreeGrid;
import matchthree.main.element.spawner.MThreeSpawner;
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
import matchthree.main.swapping.MThreeSwapDirection;
import matchthree.main.element.GameElement;
import flambe.input.Key;
import flambe.animation.AnimatedFloat;
import matchthree.core.SceneManager;

/**
 * ...
 * @author Anthony Ganzon
 */
class MThreeMain extends GameElement
{
	public var dataManager(default, null): DataManager;
	public var gridBoard(default, null): Array<Array<MThreeGrid>>;
	public var gridBlocks(default, null): Array<Array<MThreeBlock>>;
	public var gridSpawners(default, null): Array<Array<MThreeSpawner>>;
	public var tileList(default, null): Array<MThreeTile>;
	
	public var gameScore(default, null): AnimatedFloat;
	public var gameTime(default, null): AnimatedFloat;
	
	public var onTilePointerIn: Signal1<MThreeTile>;
	public var onTilePointerOut: Signal1<MThreeTile>;
	
	private var tileDataTypes: Array<MThreeTileData>;
	
	private var hasStarted: Bool;
	
	public function new(dataManager: DataManager) {
		super();
		
		this.dataManager = dataManager;
		onTilePointerIn = new Signal1<MThreeTile>();
		onTilePointerOut = new Signal1<MThreeTile>();
		
		gameScore = new AnimatedFloat(0.0);
		gameTime = new AnimatedFloat(GameConstants.GAME_TIME_MAX);
		
		MThreeUtils.SetMThreeMain(this);
	}
	
	public function CreateGrid(): Void {
		gridBoard = new Array<Array<MThreeGrid>>();
		
		for (x in 0...GameConstants.GRID_ROWS) {
			var gridArray: Array<MThreeGrid> = new Array<MThreeGrid>();
			for (y in 0...GameConstants.GRID_COLS) {
				var grid: MThreeGrid = new MThreeGrid(dataManager.gameAsset.getTexture(AssetName.ASSET_CUBE));
				grid.HideGrid();
				grid.SetGridID(x, y);
				grid.SetParent(owner);
				AddToEntity(grid);
				
				grid.SetXY(
					(this.x._ + (grid.GetNaturalWidth() / 2) * GameConstants.GRID_OFFSET) + ((x - (GameConstants.GRID_ROWS / 2)) * grid.GetNaturalWidth()) * GameConstants.GRID_OFFSET,
					(this.y._ + (grid.GetNaturalHeight() / 2) * GameConstants.GRID_OFFSET) + ((y - (GameConstants.GRID_COLS / 2)) * grid.GetNaturalHeight()) * GameConstants.GRID_OFFSET
				);
				
				gridArray.push(grid);
			}
			gridBoard.push(gridArray);
		}
	}
	
	public function CreateBlocks(): Void {
		gridBlocks = new Array<Array<MThreeBlock>>();
		
		for (ii in 0...gridBoard.length) {
			var blockArray: Array<MThreeBlock> = new Array<MThreeBlock>();
			for (grid in gridBoard[ii]) {
				blockArray.push(new MThreeBlock(null, grid));
			}
			gridBlocks.push(blockArray);
		}
	}
	
	public function CreateTiles(): Void {
		tileList = new Array<MThreeTile>();
		
		for (ii in 0...gridBoard.length) {
			for (grid in gridBoard[ii]) {
				CreateRandomTileCube(grid);
			}
		}
	}
	
	public function CreateSpawners(): Void {
		gridSpawners = new Array<Array<MThreeSpawner>>();
		
		for (x in 0...GameConstants.GRID_ROWS) {
			var spawner: MThreeSpawner = new MThreeSpawner(dataManager.gameAsset.getTexture(AssetName.ASSET_CUBE));
			spawner.SetParent(owner);
			spawner.SetGridID(x, 0);
			spawner.HideSpawner();
			spawner.SetXY(gridBoard[x][0].x._, gridBoard[x][0].y._ - (spawner.GetNaturalWidth() * 1.5));
			AddToEntity(spawner);
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
	
	public function CreateTileCube(tileData: MThreeTileData, grid: IGrid, updatePos: Bool = true): MThreeTileCube {
		var tile: MThreeTileCube = new MThreeTileCube(tileData);
		tile.SetParent(owner);
		tile.SetGridID(grid.idx, grid.idy, updatePos);
		AddToEntity(tile);
		
		// append tile to grid blocks
		var block: MThreeBlock = gridBlocks[grid.idx][grid.idy];
		if (!block.isBlocked && block.IsBlockEmpty()) {
			block.SetBlockTile(tile);
			tileList.push(tile);
		}
		
		return tile;
	}
	
	public function CreateRandomTileCube(grid: IGrid, updatePos: Bool = true): MThreeTileCube {
		if (tileDataTypes == null) {
			var dataType: MThreeTileData = new MThreeTileData(MThreeUtils.GetTileTexture(TileDataType.TILE_TRIANGLE, dataManager.gameAsset), TileDataType.TILE_TRIANGLE);
			return CreateTileCube(dataType, grid);
		}
		
		var rand: Int = Math.round(Math.random() * Type.allEnums(TileDataType).length);
		var randIndx: Int = rand % (Type.allEnums(TileDataType).length);	
		
		return CreateTileCube(tileDataTypes[randIndx], grid, updatePos);
	}
	
	public function GameControls(): Void {
		var pointerDown: Bool = false;
		var startPoint: Point = new Point();
		var endPoint: Point = new Point();
		
		var curTile: MThreeTile = null;
		var tileOut: MThreeTile = null;
		var tileClicked: MThreeTile = null;
		
		onTilePointerIn.connect(function(tile: MThreeTile) {
			curTile = tile;
			
			if (curTile != null) { tileOut = null; }
		});	
		
		onTilePointerOut.connect(function(tile: MThreeTile) {
			tileOut = tile;
		});
	
		System.pointer.down.connect(function(event: PointerEvent) {		
			if (curTile == tileOut)
				return;
			
			startPoint = new Point(
				event.viewX - (System.stage.width / 2), 
				(System.stage.height / 2) - event.viewY
			);
			endPoint = new Point();
			pointerDown = true;
			tileClicked = curTile;
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
			
			if (direction.magnitude() < GameConstants.SWAP_THRESHOLD)
				return;
			
			if (tileClicked != null) {
				if (Math.abs(direction.x) > Math.abs(direction.y)) {
					if (direction.x > 0) {
						MThreeUtils.SwapTile(MThreeSwapDirection.SWAP_RIGHT, tileClicked, function() {
							SetBoardDirty();
							MThreeUtils.SwapTile(MThreeSwapDirection.SWAP_LEFT, tileClicked);
							tileClicked = null;
						});
					}
					else {
						MThreeUtils.SwapTile(MThreeSwapDirection.SWAP_LEFT, tileClicked, function() {
							SetBoardDirty();
							MThreeUtils.SwapTile(MThreeSwapDirection.SWAP_RIGHT, tileClicked);
							tileClicked = null;
						});
					}
				}
				else {
					if (direction.y > 0) {
						MThreeUtils.SwapTile(MThreeSwapDirection.SWAP_UP, tileClicked, function() {
							SetBoardDirty();
							MThreeUtils.SwapTile(MThreeSwapDirection.SWAP_DOWN, tileClicked);
							tileClicked = null;
						});
					}
					else {
						MThreeUtils.SwapTile(MThreeSwapDirection.SWAP_DOWN, tileClicked, function() {
							SetBoardDirty();
							MThreeUtils.SwapTile(MThreeSwapDirection.SWAP_UP, tileClicked);
							tileClicked = null;
						});
					}
				}
				
				StartGame();
			}
			
			curTile = null;
			pointerDown = false;
			startPoint = new Point();
			endPoint = new Point();
		});
	}
	
	public function StartGame(): Void {
		if (hasStarted)
			return;
		
		hasStarted = true;
	}
	
	public function SetBoardDirty(): Void {		
		if (!MThreeUtils.HasPossibleMoves()) {
			BoardReset();
		}

		var matches: Array<Array<MThreeTileCube>> = MThreeUtils.GetAllMatches();
		if (matches.length <= 0)
			return;
		
		for (tiles in matches) {
			gameScore._ += MThreeUtils.GetScore(tiles);
			
			for (tile in tiles) {
				tile.dispose();
			}
		}
		
		RepeatCleaning();
	}
		
	public function InitBoard(): Void {
		var matches: Array<Array<MThreeTileCube>> = MThreeUtils.GetAllMatches();
		if (matches.length <= 0) 
			return;

		for (match in matches) {
			for(tile in match) {
				var rand: Int = Math.round(Math.random() * Type.allEnums(TileDataType).length);
				var randIndx: Int = rand % (Type.allEnums(TileDataType).length);
				
				tile.tileData = tileDataTypes[randIndx];
			}
		}
		
		// Repeat the process
		InitBoard();
	}
	
	public function BoardReset(): Void {
		for (i in 0...gridBlocks.length) {
			for (block in gridBlocks[i]) {
				if (block != null && block.tile != null) {
					block.DestroyTile();
				}
			}
		}

		RepeatCleaning();
	}
	
	public function RepeatCleaning(): Void {
		var stageClear: Script = new Script();
		stageClear.run(new Repeat(new Sequence([
			new Delay(0.5),
			new CallFunction(function() {
				if (!MThreeUtils.HasMovingBlocks() && tileList.length == (GameConstants.GRID_ROWS * GameConstants.GRID_COLS)) {
					SetBoardDirty();
					RemoveAndDispose(stageClear);
				}
			})
		])));
		AddToEntity(stageClear);
	}
	
	override public function onStart() {
		super.onStart();
		
		PopulateTileData();
		CreateGrid();
		CreateBlocks();
		CreateTiles();
		CreateSpawners();
		GameControls();
		
		// Making sure that when we initialize the board
		// it doesn't contain any matches
		InitBoard();
		
		System.keyboard.down.connect(function(event: KeyboardEvent) {
			if (event.key == Key.Space) {
				BoardReset();
			}
		});
	}
	
	override public function onUpdate(dt:Float) {
		super.onUpdate(dt);
		
		if (hasStarted) {
			gameTime._ -= dt;
			
			if (gameTime._ <= 0) {
				hasStarted = false;
				SceneManager.ShowGameOverScreen();
			}
		}
	}
}