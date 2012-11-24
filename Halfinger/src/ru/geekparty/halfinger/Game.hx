package ru.geekparty.halfinger;
import nme.display.Sprite;
import nme.events.Event;
import nme.Lib;
import nme.Assets;
import nme.text.TextField;
import nme.text.TextFormat;
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
	private var _girl : Girl;
	private var _scoreText : TextField;
	private var _score : Int = 0;
	private var _scoreCounting : Bool = false;

	public function new() 
	{
		super();
		
		_updatable = [];
		_tickDt = 1.0 / FPS;
	
		addChild( _girl = new Girl() );
		_girl.addEventListener( "girlTouched", onGirlTouched );
		_girl.addEventListener( "girlReleased", onGirlReleased );
		
		addEventListener( Event.ADDED_TO_STAGE, onStageInit );
		
		_scoreText = new TextField();
		_scoreText.defaultTextFormat = new TextFormat( "Arial", 16, 0xFFFFFF );
		_scoreText.text = "Очки: ";
		_scoreText.x = 10;
		_scoreText.y = 30;
		addChild( _scoreText );
	}
	
	private function onStageInit( e:Event ):Void
	{
		_girl.x = stage.stageWidth / 2;
		_girl.y = stage.stageHeight / 2;
	}
	
	private function onGirlTouched( e:Event ):Void { Lib.trace("Нажал бабу!"); _scoreCounting = true; }
	private function onGirlReleased( e:Event ):Void { Lib.trace("Отпусиил бабу!"); _scoreCounting = false; }
	
	private function getScore( dt : Float ):Int
	{
		return Math.floor(dt / 1000);
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
		
		if ( _score > 1000 )
		{
			Lib.trace("You won!");
			return;
		}
		_score += _scoreCounting ? getScore( _lastTickTime ) : 0;

		_scoreText.text = "Очки: " + _score;
		
		for (i in 0...frames)
		{
			for (entity in _updatable)
			{
				entity.update(_tickDt);
			}
		}
	}
	
}