package matchthree.main.element.tile;
import flambe.input.PointerEvent;
import matchthree.main.element.MThreeMain;

/**
 * ...
 * @author Anthony Ganzon
 */
class MThreeTileTouch extends MThreeTile
{

	public function new() {
		super();
	}
	
	override public function onStart() {
		super.onStart();
		
		var mThreeMain: MThreeMain = parent.get(MThreeMain);
		tileImage.pointerIn.connect(function(event: PointerEvent) {
			mThreeMain.onTilePointerIn.emit(this);
		});
		
		//tileImage.pointerOut.connect(function(event: PointerEvent) {
			//mThreeMain.onTilePointerIn.emit(null);
		//});
	}
	
}