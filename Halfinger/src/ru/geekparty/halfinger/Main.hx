package ru.geekparty.halfinger;

import nme.display.FPS;
import nme.display.Sprite;
import nme.events.Event;
import nme.Lib;

import nme.media.Sound;

/**
 * ...
 * @author Null/
 */

class Main extends Sprite 
{
	
	var game:Game;
	
	private static inline var viewPortW:Int = 480;
	private static inline var viewPortH:Int = 800;
	
	public function new() 
	{
		super();
		#if iphone
		Lib.current.stage.addEventListener(Event.RESIZE, init);
		#else
		addEventListener(Event.ADDED_TO_STAGE, init);
		#end
	}

	private function init(e) 
	{
		// entry point
		
		var game:Game = new Game();
		game.Start();
		addChild(game);
		
		
		var scale:Float =  stage.stageWidth / viewPortW;
		game.scaleX = game.scaleY = scale;
		
		addChild( new FPS(10,10,0xffffff));
	}
	
	static public function main() 
	{
		var stage = Lib.current.stage;
		stage.scaleMode = nme.display.StageScaleMode.NO_SCALE;
		stage.align = nme.display.StageAlign.TOP_LEFT;
		
		Lib.current.addChild(new Main());
	}
	
}
