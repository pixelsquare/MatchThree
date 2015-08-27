package matchthree.main.element.block;

import matchthree.main.element.GameElement;
import matchthree.main.element.grid.MThreeGrid;
import matchthree.main.element.tile.MThreeTile;

/**
 * ...
 * @author Anthony Ganzon
 */
class MThreeBlock
{
	public var tile(default, null): MThreeTile;
	public var grid(default, null): MThreeGrid;
	public var isBlocked(default, null): Bool;
	
	public function new(tile: MThreeTile, grid: MThreeGrid) {
		this.tile = tile;
		this.grid = grid;
		
		this.isBlocked = false;
	}
	
	public function SetBlocked(): Void {
		isBlocked = true;
	}
	
	public function UnBlock(): Void {
		isBlocked = false;
	}
	
	public function SetBlockTile(tile: MThreeTile): Void {
		this.tile = tile;
	}
	
	public function SetBlockGrid(grid: MThreeGrid): Void {
		this.grid = grid;
	}
	
	public function IsBlockEmpty(): Bool {
		if (isBlocked)
			return false;
			
		return tile == null;
	}
}