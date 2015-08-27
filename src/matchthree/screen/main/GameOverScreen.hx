package matchthree.screen.main;

import flambe.display.Font;
import flambe.display.TextSprite;
import flambe.Entity;
import flambe.System;
import flambe.scene.Scene;
import flambe.asset.AssetPack;
import flambe.subsystem.StorageSystem;

import matchthree.name.AssetName;
import matchthree.name.ScreenName;
import matchthree.screen.GameScreen;
/**
 * ...
 * @author Anthony Ganzon
 */
class GameOverScreen extends GameScreen
{

	public function new(assetPack: AssetPack, storage: StorageSystem) {		
		super(assetPack, storage);
	}
	
	override public function CreateScreen():Entity 
	{
		screenEntity = super.CreateScreen();
		screenScene = new Scene(false);
		screenBackground.color = 0x000000;
		screenBackground.alpha._ = 0.5;
		
		return screenEntity;
	}
	
	override public function GetScreenName():String 
	{
		return ScreenName.SCREEN_GAME_OVER;
	}
	
}