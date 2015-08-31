package matchthree.main.element.grid;

import flambe.display.ImageSprite;
import flambe.display.Texture;

import matchthree.main.element.GameElement;
import matchthree.main.MThreeMain;

/**
 * ...
 * @author Anthony Ganzon
 */
class MThreeGrid extends GameElement implements IGrid
{
	public var idx(default, null): Int;
	public var idy(default, null): Int;
	
	private var backgroundTex: Texture;
	private var background: ImageSprite;
	
	public function new(bgTex: Texture) {
		this.backgroundTex = bgTex;
		super();
	}
	
	override public function Init():Void {
		background = new ImageSprite(backgroundTex);
		background.centerAnchor();
	}
	
	override public function Draw(): Void {
		AddToEntity(background);
	}
	
	public function ShowGrid(): Void {
		if (background == null || background.visible)
			return;
	
		background.visible = true;
	}
	
	public function HideGrid(): Void {
		if (background == null || !background.visible)
			return;
		
		background.visible = false;
	}
	
	override public function GetNaturalWidth():Float {
		return background.getNaturalWidth();
	}
	
	override public function GetNaturalHeight():Float {
		return background.getNaturalHeight();
	}
	
	override public function onUpdate(dt:Float) {
		super.onUpdate(dt);
		if (background != null) {
			background.setAlpha(this.alpha._);
			background.setXY(this.x._, this.y._);
			background.setScaleXY(this.scaleX._, this.scaleY._);
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