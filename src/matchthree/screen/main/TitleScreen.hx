package matchthree.screen.main;

import flambe.asset.AssetPack;
import flambe.display.Font;
import flambe.display.ImageSprite;
import flambe.Entity;
import flambe.script.AnimateTo;
import flambe.script.CallFunction;
import flambe.script.Delay;
import flambe.script.Parallel;
import flambe.script.Script;
import flambe.script.Sequence;
import flambe.subsystem.StorageSystem;
import flambe.System;
import flambe.animation.Ease;

import matchthree.core.SceneManager;
import matchthree.name.AssetName;
import matchthree.name.FontName;
import matchthree.name.ScreenName;
import matchthree.screen.GameButton;

/**
 * ...
 * @author Anthony Ganzon
 */
class TitleScreen extends GameScreen
{
	private var startGameBtn: GameButton;
	
	public function new(assetPack: AssetPack, storage: StorageSystem) {		
		super(assetPack, storage);
	}
	
	override public function CreateScreen(): Entity {
		screenEntity = super.CreateScreen();
		HideTitleText();
		
		var backgroundImage: ImageSprite = new ImageSprite(gameAsset.getTexture(AssetName.ASSET_TITLE_BACKGROUND));
		backgroundImage.setXY(System.stage.width / 2, System.stage.height / 2);
		backgroundImage.centerAnchor();
		screenEntity.addChild(new Entity().add(backgroundImage));
		
		var titleImage: ImageSprite = new ImageSprite(gameAsset.getTexture(AssetName.ASSET_TITLE));
		titleImage.setXY(System.stage.width * 0.5, System.stage.height * 0.35);
		titleImage.setScaleXY(0.0, 0.0);
		titleImage.centerAnchor();
		screenEntity.addChild(new Entity().add(titleImage));
		
		// Start Button --
		startGameBtn = new GameButton(
			new Font(gameAsset, FontName.FONT_UNCERTAIN_SANS_32), 
			"Start Game",
			[
				gameAsset.getTexture(AssetName.ASSET_BUTTON_UP_LRG),
				null,
				gameAsset.getTexture(AssetName.ASSET_BUTTON_DOWN_LRG)
			],
			function() {
				var clickedScript: Script = new Script();
				clickedScript.run(new Sequence([
					new Parallel([
						new AnimateTo(startGameBtn.scaleX, 0.0, 0.5, Ease.elasticOut),
						new AnimateTo(startGameBtn.scaleY, 0.0, 0.5, Ease.elasticOut)
					]),
					new CallFunction(function() {
						SceneManager.ShowMainScreen(true);
						screenEntity.remove(clickedScript);
						clickedScript.dispose();
					})
				]));
				screenEntity.add(clickedScript);
			}
		);
		startGameBtn.SetXY(System.stage.width / 2, System.stage.height * 0.6);
		startGameBtn.SetScaleXY(0.0, 0.0);
		screenEntity.add(startGameBtn);
		
		var titleScript: Script = new Script();
		titleScript.run(new Sequence([
			new Delay(0.6),
			new Parallel([
				new AnimateTo(titleImage.scaleX, 1.0, 0.5, Ease.elasticOut),
				new AnimateTo(titleImage.scaleY, 1.0, 0.5, Ease.elasticOut)
			]),
			new Parallel([
				new AnimateTo(startGameBtn.scaleX, 1.0, 0.5, Ease.elasticOut),
				new AnimateTo(startGameBtn.scaleY, 1.0, 0.5, Ease.elasticOut)
			]),
			new CallFunction(function() {
				screenEntity.remove(titleScript);
				titleScript.dispose();
			})
		]));
		screenEntity.add(titleScript);
		
		return screenEntity;
	}
	
	override public function GetScreenName():String 
	{
		return ScreenName.SCREEN_TITLE;
	}
}