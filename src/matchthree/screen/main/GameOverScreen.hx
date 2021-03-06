package matchthree.screen.main;

import flambe.animation.Ease;
import flambe.asset.AssetPack;
import flambe.display.Font;
import flambe.display.ImageSprite;
import flambe.display.Sprite;
import flambe.display.TextSprite;
import flambe.Entity;
import flambe.subsystem.StorageSystem;
import flambe.System;

import matchthree.core.SceneManager;
import matchthree.main.GameConstants;
import matchthree.name.AssetName;
import matchthree.name.FontName;
import matchthree.name.ScreenName;
import matchthree.screen.GameScreen;

/**
 * ...
 * @author Anthony Ganzon
 */
class GameOverScreen extends GameScreen
{
	private var menuEntity: Entity;
	private var menuSprite: Sprite;
	
	private var menuBackground: ImageSprite;
	
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
			-(menuBackground.getNaturalHeight() / 2)
		);
		menuSprite.y.animateTo(System.stage.height / 2, GameConstants.TWEEN_SPEED, Ease.backInOut);
		screenEntity.addChild(menuEntity.add(menuSprite));
		
		return screenEntity;
	}
	
	public function CreateMenu(): Void {
		menuEntity = new Entity();
		
		menuBackground = new ImageSprite(gameAsset.getTexture(AssetName.ASSET_GAMEOVER_POPUP));
		menuBackground.centerAnchor();
		menuEntity.addChild(new Entity().add(menuBackground));
		
		var menuFont: Font = new Font(gameAsset, FontName.FONT_ARIAL_23);
		var menuText: TextSprite = new TextSprite(menuFont, "Game Over");
		menuText.centerAnchor();
		menuText.setXY(
			menuBackground.x._,
			menuBackground.y._ - (menuBackground.getNaturalHeight() * 0.4)
		);
		menuEntity.addChild(new Entity().add(menuText));
		
		var totalScoreFont: Font = new Font(gameAsset, FontName.FONT_ARIAL_YELLOW_23);
		var totalScoreText: TextSprite = new TextSprite(totalScoreFont, "Total Score");
		totalScoreText.centerAnchor();
		totalScoreText.setXY(
			menuBackground.x._,
			menuBackground.y._ - (menuBackground.getNaturalHeight() * 0.175)
		);
		menuEntity.addChild(new Entity().add(totalScoreText));
		
		var scoreFont: Font = new Font(gameAsset, FontName.FONT_ARIAL_32);
		var scoreText: TextSprite = new TextSprite(scoreFont, "999999");
		scoreText.centerAnchor();
		scoreText.setXY(
			menuBackground.x._,
			menuBackground.y._ - (menuBackground.getNaturalHeight() * 0.07)
		);
		menuEntity.addChild(new Entity().add(scoreText));
		
		SceneManager.instance.gameMainScreen.matchThreeMain.gameScore.watch(function(newScore:Float, oldScore:Float) {
			scoreText.text = Std.int(newScore) + "";
			scoreText.centerAnchor();
		});
		
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
	
	override public function GetScreenName(): String {
		return ScreenName.SCREEN_GAME_OVER;
	}
}