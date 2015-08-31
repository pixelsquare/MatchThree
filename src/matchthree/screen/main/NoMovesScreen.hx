package matchthree.screen.main;

import flambe.animation.Ease;
import flambe.asset.AssetPack;
import flambe.display.FillSprite;
import flambe.display.Font;
import flambe.display.TextSprite;
import flambe.Entity;
import flambe.script.AnimateBy;
import flambe.script.AnimateTo;
import flambe.script.CallFunction;
import flambe.script.Parallel;
import flambe.script.Script;
import flambe.script.Sequence;
import flambe.subsystem.StorageSystem;
import flambe.System;

import matchthree.core.SceneManager;
import matchthree.name.FontName;
import matchthree.name.ScreenName;
import matchthree.screen.GameScreen;

/**
 * ...
 * @author Anthony Ganzon
 */
class NoMovesScreen extends GameScreen
{

	public function new(assetPack:AssetPack, storage:StorageSystem) {
		super(assetPack, storage);
	}
	
	override public function CreateScreen(): Entity {
		screenEntity = super.CreateScreen();
		HideBackground();
		HideTitleText();
		
		var background: FillSprite = new FillSprite(0x202020, System.stage.width, System.stage.height * 0.2);
		background.centerAnchor();
		background.setXY(
			-(background.getNaturalWidth() / 2),
			System.stage.height / 2
		);
		background.setAlpha(0.5);
		screenEntity.addChild(new Entity().add(background));
		
		var noMovesFont: Font = new Font(gameAsset, FontName.FONT_BETTY_32);
		var noMovesText: TextSprite = new TextSprite(noMovesFont, "NO POSSIBLE MOVES!");
		noMovesText.centerAnchor();
		noMovesText.setXY(
			System.stage.width + noMovesText.getNaturalWidth(),
			background.y._
		);
		screenEntity.addChild(new Entity().add(noMovesText));
		
		var script: Script = new Script();
		script.run(new Sequence([
			new Parallel([
				new AnimateTo(background.x, System.stage.width * 0.45, 0.5, Ease.expoInOut),
				new AnimateTo(noMovesText.x, System.stage.width * 0.55, 0.5, Ease.expoInOut)
			]),
			new Parallel([
				new AnimateBy(background.x, 40, 1),
				new AnimateBy(noMovesText.x, -40, 1)
			]),
			new Parallel([
				new AnimateTo(background.x, System.stage.width + background.getNaturalWidth(), 0.5, Ease.expoInOut),
				new AnimateTo(noMovesText.x, -(noMovesText.getNaturalWidth() / 2), 0.5, Ease.expoInOut),
				new AnimateTo(background.alpha, 0, 0.5),
				new AnimateTo(noMovesText.alpha, 0, 0.5)
			]),
			new CallFunction(function() {
				screenEntity.removeChild(new Entity().add(script));
				script.dispose();
				SceneManager.UnwindToCurScene();
			})
		]));
		screenEntity.addChild(new Entity().add(script));
		
		return screenEntity;
	}
	
	override public function GetScreenName(): String {
		return ScreenName.SCREEN_NO_MOVES;
	}
}