package matchthree.main.element;

import flambe.animation.AnimatedFloat;
import flambe.Component;
import flambe.Disposer;
import flambe.Entity;
import flambe.scene.Scene;

/**
 * ...
 * @author Anthony Ganzon
 */
class GameElement extends Component
{
	public var alpha(default, null): AnimatedFloat;
	
	public var x(default, null): AnimatedFloat;
	public var y(default, null): AnimatedFloat;
	
	public var scaleX(default, null): AnimatedFloat;
	public var scaleY(default, null): AnimatedFloat;
	
	public var width(default, null): Float;
	public var height(default, null): Float;
	
	public var parent(default, null): Entity;
	
	private var elementEntity: Entity;
	private var elementScene: Scene;
	private var elementDisposer: Disposer;
	
	public function new() {
		this.alpha = new AnimatedFloat(1.0);
		this.x = new AnimatedFloat(0.0);
		this.y = new AnimatedFloat(0.0);
		this.scaleX = new AnimatedFloat(1.0);
		this.scaleY = new AnimatedFloat(1.0);
		this.width = 10;
		this.height = 10;
		
		elementEntity = new Entity()
			.add(elementScene = new Scene(false))
			.add(elementDisposer = new Disposer());
			
		Init();
	}
	
	public function Init(): Void { }
	
	public function Draw(): Void { }
	
	public function SetAlpha(alpha: Float): GameElement {
		this.alpha._ = alpha;
		return this;
	}
	
	public function SetXY(x: Float, y: Float): GameElement {
		this.x._ = x;
		this.y._ = y;
		return this;
	}
	
	public function SetScaleXY(scaleX: Float, scaleY: Float): GameElement {
		this.scaleX._ = scaleX;
		this.scaleY._ = scaleY;
		return this;
	}
	
	public function SetSize(width: Float, height: Float): GameElement {
		this.width = width;
		this.height = height;
		return this;
	}
	
	public function SetParent(parent: Entity): GameElement {
		this.parent = parent;
		return this;
	}
	
	public function GetNaturalWidth(): Float {
		return width;
	}
	
	public function GetNaturalHeight(): Float {
		return height;
	}
	
	public function AlphaToString(): String {
		return "Alpha [" + this.alpha + "]";
	}
	
	public function PositionToString(): String {
		return "Position [" + this.x._ + "," + this.y._ + "]";
	}
	
	public function ScaleToString(): String {
		return "Scale [" + this.scaleX._ + "," + this.scaleY._ + "]";
	}
	
	public function SizeToString(): String {
		return "Size [" + this.width + "," + this.height + "]";
	}
	
	public function AddToEntity(component: Component, append: Bool = true): Void {
		if (component == null)
			return;
			
		elementEntity.addChild(new Entity().add(component), append);
	}
	
	public  function RemoveToEntity(component: Component): Void {
		if (component == null)
			return;
		
		elementEntity.removeChild(new Entity().add(component));
	}
	
	public  function RemoveAndDispose(component: Component): Void {
		RemoveToEntity(component);
		component.dispose();
	}
	
	override public function onAdded() {
		super.onAdded();
		owner.addChild(elementEntity);
		if (owner.get(Disposer) != null) {
			elementDisposer = owner.get(Disposer);
		}
	}
	
	override public function onStart() {
		super.onStart();
		
		Draw();
	}
	
	override public function onUpdate(dt:Float) {
		alpha.update(dt);
		x.update(dt);
		y.update(dt);
		scaleX.update(dt);
		scaleY.update(dt);
	}
	
	override public function dispose() {
		super.dispose();
		elementEntity.dispose();
	}
}