package matchthree.screen.main;

import flambe.asset.AssetPack;
import flambe.display.Font;
import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.display.TextSprite;
import flambe.Entity;
import flambe.subsystem.StorageSystem;
import flambe.System;

import matchthree.core.SceneManager;
import matchthree.name.AssetName;
import matchthree.name.FontName;
import matchthree.name.ScreenName;
import matchthree.screen.GameButton;
import matchthree.screen.GameScreen;


/**
 * ...
 * @author Anthony Ganzon
 */
class PauseScreen extends GameScreen
{
	private var menuEntity: Entity;
	private var menuSprite: Sprite;
	
	public function new(assetPack: AssetPack, storage: StorageSystem) {		
		super(assetPack, storage);
	}
	
	override public function CreateScreen():Entity {
		screenEntity = super.CreateScreen();
		screenBackground.alpha._ = 0.5;
		HideTitleText();
		
		CreateMenu();
		
		menuSprite = new Sprite();
		menuSprite.setXY(
			System.stage.width / 2,
			System.stage.height / 2
		);
		screenEntity.addChild(menuEntity.add(menuSprite));
		
		return screenEntity;
	}
	
	public function CreateMenu(): Void {
		menuEntity = new Entity();
		
		var menuBackground: ImageSprite = new ImageSprite(gameAsset.getTexture(AssetName.ASSET_PAUSE_POPUP));
		menuBackground.centerAnchor();
		menuEntity.addChild(new Entity().add(menuBackground));
		
		var menuFont: Font = new Font(gameAsset, FontName.FONT_ARIAL_23);
		var menuText: TextSprite = new TextSprite(menuFont, "Paused");
		menuText.centerAnchor();
		menuText.setXY(
			menuBackground.x._,
			menuBackground.y._ - (menuBackground.getNaturalHeight() * 0.385)
		);
		menuEntity.addChild(new Entity().add(menuText));
		
		var resumeBtn: GameButton = new GameButton(
			new Font(gameAsset, FontName.FONT_ARIAL_23),
			"Resume",
			[
				gameAsset.getTexture(AssetName.ASSET_BUTTON_UP_SML),
				null,
				gameAsset.getTexture(AssetName.ASSET_BUTTON_DOWN_SML)
			],
			function() {
				SceneManager.UnwindToCurScene();
			}
		);
		resumeBtn.SetXY(
			menuBackground.x._,
			menuBackground.y._ - (menuBackground.getNaturalHeight() * 0.11)
		);
		menuEntity.addChild(new Entity().add(resumeBtn));
		
		var restartBtn: GameButton = new GameButton(
			new Font(gameAsset, FontName.FONT_ARIAL_23),
			"Restart",
			[
				gameAsset.getTexture(AssetName.ASSET_BUTTON_UP_SML),
				null,
				gameAsset.getTexture(AssetName.ASSET_BUTTON_DOWN_SML)
			],
			function() {
				SceneManager.ShowMainScreen();
			}
		);
		restartBtn.SetXY(
			menuBackground.x._,
			menuBackground.y._ + (menuBackground.getNaturalHeight() * 0.12)
		);
		menuEntity.addChild(new Entity().add(restartBtn));
		
		var quitBtn: GameButton = new GameButton(
			new Font(gameAsset, FontName.FONT_ARIAL_23),
			"Quit",
			[
				gameAsset.getTexture(AssetName.ASSET_BUTTON_UP_SML),
				null,
				gameAsset.getTexture(AssetName.ASSET_BUTTON_DOWN_SML)
			],
			function() {
				SceneManager.ShowTitleScreen(true);
			}
		);
		quitBtn.SetXY(
			menuBackground.x._,
			menuBackground.y._ + (menuBackground.getNaturalHeight() * 0.34)
		);
		menuEntity.addChild(new Entity().add(quitBtn));
	}
	
	override public function GetScreenName():String {
		return ScreenName.SCREEN_PAUSE;
	}	
}