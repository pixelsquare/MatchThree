package matchthree.main.utils;

import flambe.display.Font;
import flambe.display.TextSprite;
import flambe.script.AnimateBy;
import flambe.script.AnimateTo;
import flambe.script.CallFunction;
import flambe.script.Parallel;
import flambe.script.Repeat;
import flambe.script.Script;
import flambe.script.Sequence;

import matchthree.main.element.GameElement;
import matchthree.main.element.grid.IGrid;
import matchthree.main.element.grid.MThreeGrid;
import matchthree.main.MThreeMain;

/**
 * ...
 * @author Anthony Ganzon
 */
class MThreePopup extends GameElement implements IGrid
{
	public var idx(default, null): Int;
	public var idy(default, null): Int;
	
	private var popupTextFont: Font;
	private var popupText: String;
	private var popupTextSprite: TextSprite;
	
	private var shakeFly: Bool;
	
	public function new(text: String, font: Font, shakeFly: Bool = false) {		
		this.popupText = text;
		this.popupTextFont = font;
		this.shakeFly = shakeFly;
		
		super();
	}
	
	override public function Init():Void {
		popupTextSprite = new TextSprite(popupTextFont, popupText);
		popupTextSprite.centerAnchor();
	}
	
	override public function Draw():Void {
		AddToEntity(popupTextSprite);
	}
	
	override public function onStart() {
		super.onStart();
		var popupScript: Script = new Script();
		
		if(shakeFly) {
			popupScript.run(new Sequence([
				new Repeat(new Sequence([
					new AnimateBy(this.x, 5, 0.1),
					new AnimateBy(this.x, -5, 0.1)
					]), 
				3),
				new Parallel([
					new AnimateBy(this.y, -30, 1),
					new AnimateTo(this.alpha, 0, 1)
				]),
				new CallFunction(function() {
					RemoveAndDispose(popupScript);
					dispose();
				})
			]));
		}
		else {
			popupScript.run(new Sequence([
				new Parallel([
					new AnimateBy(this.y, -30, 1),
					new AnimateTo(this.alpha, 0, 1)
				]),
				new CallFunction(function() {
					RemoveAndDispose(popupScript);
					dispose();
				})
			]));
		}
		
		AddToEntity(popupScript);
	}
	
	override public function onUpdate(dt:Float) {
		super.onUpdate(dt);
		if (popupTextSprite != null) {
			popupTextSprite.setAlpha(this.alpha._);
			popupTextSprite.setXY(this.x._, this.y._);
			popupTextSprite.setScaleXY(this.scaleX._, this.scaleY._);
		}
	}
	
	/* INTERFACE matchthree.main.element.grid.IGrid */
	
	public function SetGridID(idx:Int, idy:Int, updatePosition:Bool = false):Void {
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