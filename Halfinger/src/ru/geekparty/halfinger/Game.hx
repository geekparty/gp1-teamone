package ru.geekparty.halfinger;
import nme.display.Sprite;
import nme.events.Event;
import nme.Lib;
import nme.Assets;
import ru.geekparty.game.AnimatedSprite;
import ru.geekparty.game.Animation;
import ru.geekparty.game.IUpdatable;
import ru.geekparty.game.TextureAtlas;

/**
 * ...
 * @author Null/
 */

class Game extends Sprite
{
	public static inline var FPS:Int = 60;
	public static inline var MAX_TICKS:Int = 3;
	
	public var frame:Int;
	public var _lastTickTime:Float;
	public var _tickDt:Float;
	
	public var _updatable:Array<IUpdatable>;

	public function new() 
	{
		super();
		
		_updatable = [];
		_tickDt = 1.0 / FPS;
	
		addChild( new Girl() );
	}
	
	private function spawnGirl(x:Float, y:Float):Void
	{
		var girl:AnimatedSprite = new AnimatedSprite([new TextureAtlas(Assets.getBitmapData("img/girl.png")
													  , Assets.getText("img/girl.json"))]);
		
		girl.addAnimation( "sample"
						  , 0
						  , ["little_girl_01.png", "little_girl_02.png"]
						  , 4, true );
						  
		girl.playAnimation( "sample" );
		girl.x = x;
		girl.y = y;
													
		_updatable.push(girl);
		
		addChild(girl);
	}
	
	public function Start():Void
	{
		frame = 0;
		_lastTickTime = 0.0;
		
		addEventListener(Event.ENTER_FRAME, onFrame);
	}
	
	public function Stop():Void
	{
		removeEventListener(Event.ENTER_FRAME, onFrame);
	}
	
	
	public function onFrame(e:Event):Void
	{
		
		//TODO: Определиться с надобностью этого кода
		return;
		var timer:Float =  Lib.getTimer();
		
		var frames:Int = 0;
		if (_lastTickTime > 0.0)
		{
			frames = Math.floor((timer - _lastTickTime) / _tickDt);
		}
		else
		{
			frames = 1;
		}
		
		_lastTickTime = timer;
		frame += frames;
		if (frames > MAX_TICKS) frames = MAX_TICKS;
		
		for (i in 0...frames)
		{
			for (entity in _updatable)
			{
				entity.update(_tickDt);
			}
		}
	}
	
}