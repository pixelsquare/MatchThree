package matchthree.screen.main;

import flambe.display.FillSprite;
import flambe.display.Font;
import flambe.display.ImageSprite;
import flambe.display.TextSprite;
import flambe.Entity;
import flambe.input.KeyboardEvent;
import flambe.script.CallFunction;
import flambe.script.Delay;
import flambe.script.Script;
import flambe.script.Sequence;
import flambe.System;
import flambe.input.Key;
import flambe.asset.AssetPack;
import flambe.subsystem.StorageSystem;
import matchthree.main.MThreeMain;
import matchthree.screen.GameButton;

import matchthree.name.AssetName;
import matchthree.name.ScreenName;
import matchthree.screen.GameScreen;
import matchthree.core.SceneManager;
import matchthree.pxlSq.Utils;
import matchthree.core.GameManager;
import matchthree.name.FontName;

/**
 * ...
 * @author Anthony Ganzon
 */
class MainScreen extends GameScreen
{
	private var matchThreeMain: MThreeMain;
	private var gamePauseBtn: GameButton;
	
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
		scoreBoard.setXY(
			boardImage.x._ - (boardImage.getNaturalWidth() / 2) + (scoreBoard.getNaturalWidth() * 0.5),
			boardImage.y._ - (boardImage.getNaturalHeight() / 2) - (scoreBoard.getNaturalHeight() * 0.75)
		);
		scoreBoard.centerAnchor();
		screenEntity.addChild(new Entity().add(scoreBoard));
		
		var scoreFont: Font = new Font(gameAsset, FontName.FONT_UNCERTAIN_SANS_32);
		var scoreText: TextSprite = new TextSprite(scoreFont, "Score: 0");
		scoreText.setXY(
			scoreBoard.x._ - (scoreBoard.getNaturalWidth() * 0.6) + (scoreText.getNaturalWidth() / 2),	
			scoreBoard.y._ - (scoreBoard.getNaturalHeight() * 0.6) + (scoreText.getNaturalHeight() / 2)
		);
		//scoreText.centerAnchor();
		screenEntity.addChild(new Entity().add(scoreText));
		
		var timeBoard: ImageSprite = new ImageSprite(gameAsset.getTexture(AssetName.ASSET_BOARD_SQUARE));
		timeBoard.setXY(
			boardImage.x._ - (boardImage.getNaturalWidth() / 2) + (scoreBoard.getNaturalWidth() * 0.5) + (timeBoard.getNaturalWidth() * 1.25),
			boardImage.y._ - (boardImage.getNaturalHeight() / 2) - (scoreBoard.getNaturalHeight() * 0.75)
		);
		timeBoard.centerAnchor();
		screenEntity.addChild(new Entity().add(timeBoard));
		
		var timeFont: Font = new Font(gameAsset, FontName.FONT_UNCERTAIN_SANS_32);
		var timeText: TextSprite = new TextSprite(timeFont, "Time:   " + Utils.ToMMSS(0.0));
		timeText.setXY(timeBoard.x._, timeBoard.y._);
		timeText.centerAnchor();
		screenEntity.addChild(new Entity().add(timeText));
		
		gamePauseBtn = new GameButton(
			null,
			"",
			[
				gameAsset.getTexture(AssetName.ASSET_BUTTON_UP_PAUSE),
				null,
				gameAsset.getTexture(AssetName.ASSET_BUTTON_DOWN_PAUSE)
			],
			function() {
				SceneManager.ShowPauseScreen();
			}
		);
		
		gamePauseBtn.SetXY(
			boardImage.x._ + (boardImage.getNaturalWidth() / 2) - (gamePauseBtn.GetNaturalWidth() / 2), 
			boardImage.y._ - (boardImage.getNaturalHeight() / 2) - (gamePauseBtn.GetNaturalHeight() * 0.75)
		);
		gamePauseBtn.SetParent(screenEntity);
		screenEntity.addChild(new Entity().add(gamePauseBtn));
		
		matchThreeMain = new MThreeMain(this);
		//matchThreeMain.SetXY(boardImage.x._ * 1.08, boardImage.y._ * 1.08);
		matchThreeMain.SetXY(boardImage.x._, boardImage.y._);	
		matchThreeMain.SetParent(screenEntity);
		screenEntity.addChild(new Entity().add(matchThreeMain));
		
		matchThreeMain.gameTime.watch(function(newTime: Float, oldTime: Float) {
			timeText.text = "Time:   " + Utils.ToMMSS(newTime);
		});
		
		matchThreeMain.gameScore.watch(function(newScore: Float, oldScore: Float) {
			scoreText.text = "Score: " + Std.int(newScore);
		});
		
		//Utils.ConsoleLog(screenEntity.toString());
		
		System.keyboard.down.connect(function(event: KeyboardEvent) {
			if (event.key == Key.P) {
				SceneManager.ShowPauseScreen();
			}
			
			if (event.key == Key.G) {
				SceneManager.ShowGameOverScreen();
			}
		});
		
		return screenEntity;
	}
	
	override public function GetScreenName():String 
	{
		return ScreenName.SCREEN_MAIN;
	}
	
}