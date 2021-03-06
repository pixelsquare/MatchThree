package matchthree.screen.main;

import flambe.asset.AssetPack;
import flambe.display.Font;
import flambe.display.ImageSprite;
import flambe.display.TextSprite;
import flambe.Entity;
import flambe.input.Key;
import flambe.input.KeyboardEvent;
import flambe.subsystem.StorageSystem;
import flambe.System;

import matchthree.core.SceneManager;
import matchthree.main.MThreeMain;
import matchthree.name.AssetName;
import matchthree.name.FontName;
import matchthree.name.ScreenName;
import matchthree.pxlSq.Utils;
import matchthree.screen.GameButton;
import matchthree.screen.GameScreen;

/**
 * ...
 * @author Anthony Ganzon
 */
class MainScreen extends GameScreen
{
	public var matchThreeMain(default, null): MThreeMain;
	
	private var gamePauseBtn: GameButton;
	private var scoreText: TextSprite;
	
	public function new(assetPack: AssetPack, storage: StorageSystem) {		
		super(assetPack, storage);
	}
	
	override public function CreateScreen(): Entity {
		screenEntity = super.CreateScreen();
		HideTitleText();
		
		var backgroundImage: ImageSprite = new ImageSprite(gameAsset.getTexture(AssetName.ASSET_MAIN_BACKGROUND));
		backgroundImage.setXY(System.stage.width / 2, System.stage.height / 2);
		backgroundImage.centerAnchor();
		screenEntity.addChild(new Entity().add(backgroundImage));
		
		var boardImage: ImageSprite = new ImageSprite(gameAsset.getTexture(AssetName.ASSET_BOARD));
		boardImage.setXY(System.stage.width * 0.5, System.stage.height * 0.55);
		boardImage.centerAnchor();
		screenEntity.addChild(new Entity().add(boardImage));
		
		var scoreBoard: ImageSprite = new ImageSprite(gameAsset.getTexture(AssetName.ASSET_BOARD_SQUARE));
		scoreBoard.centerAnchor();
		scoreBoard.setXY(
			boardImage.x._ - (boardImage.getNaturalWidth() / 2) + (scoreBoard.getNaturalWidth() * 0.5),
			boardImage.y._ - (boardImage.getNaturalHeight() / 2) - (scoreBoard.getNaturalHeight() * 0.75)
		);
		screenEntity.addChild(new Entity().add(scoreBoard));
		
		var scoreFont: Font = new Font(gameAsset, FontName.FONT_ARIAL_18);
		scoreText = new TextSprite(scoreFont, "Score: 0");
		scoreText.centerAnchor();
		scoreText.setXY(
			scoreBoard.x._,	
			scoreBoard.y._
		);
		screenEntity.addChild(new Entity().add(scoreText));
		
		var timeBoard: ImageSprite = new ImageSprite(gameAsset.getTexture(AssetName.ASSET_BOARD_SQUARE));
		timeBoard.centerAnchor();
		timeBoard.setXY(
			boardImage.x._ + (boardImage.getNaturalWidth() / 2) - (scoreBoard.getNaturalWidth()),
			boardImage.y._ - (boardImage.getNaturalHeight() / 2) - (scoreBoard.getNaturalHeight() * 0.75)
		);
		screenEntity.addChild(new Entity().add(timeBoard));
		
		var timeFont: Font = new Font(gameAsset, FontName.FONT_ARIAL_18);
		var timeText: TextSprite = new TextSprite(timeFont, "Time Left:    " + Utils.ToMMSS(0.0));
		timeText.centerAnchor();
		timeText.setXY(
			timeBoard.x._, 
			timeBoard.y._
		);
		screenEntity.addChild(new Entity().add(timeText));
		
		gamePauseBtn = new GameButton(
			null,
			"Pause",
			[
				gameAsset.getTexture(AssetName.ASSET_BUTTON_UP_PAUSE),
				null,
				gameAsset.getTexture(AssetName.ASSET_BUTTON_DOWN_PAUSE)
			],
			function() {
				SceneManager.ShowPauseScreen();
			},
			false
		);
		
		gamePauseBtn.SetXY(
			boardImage.x._ + (boardImage.getNaturalWidth() / 2) - (gamePauseBtn.GetNaturalWidth() / 2), 
			boardImage.y._ - (boardImage.getNaturalHeight() / 2) - (gamePauseBtn.GetNaturalHeight() * 0.75)
		);
		gamePauseBtn.SetParent(screenEntity);
		screenEntity.addChild(new Entity().add(gamePauseBtn));
		
		matchThreeMain = new MThreeMain(this);
		matchThreeMain.SetParent(screenEntity);
		matchThreeMain.SetXY(boardImage.x._, boardImage.y._);	
		screenEntity.addChild(new Entity().add(matchThreeMain));
		
		matchThreeMain.gameTime.watch(function(newTime: Float, oldTime: Float) {
			timeText.text = "Time Left:    " + Utils.ToMMSS(newTime);
			timeText.centerAnchor();
		});
		
		matchThreeMain.gameScore.watch(function(newScore: Float, oldScore: Float) {
			scoreText.text = "Score: " + Std.int(newScore);
			scoreText.centerAnchor();
		});
		
		#if html
		System.keyboard.down.connect(function(event: KeyboardEvent) {
			if (event.key == Key.P) {
				SceneManager.ShowPauseScreen();
			}
			
			if (event.key == Key.G) {
				SceneManager.ShowGameOverScreen();
			}
		});
		#end
		
		return screenEntity;
	}
	
	override public function GetScreenName(): String {
		return ScreenName.SCREEN_MAIN;
	}
}