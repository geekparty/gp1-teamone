package ru.geekparty.halfinger;
import com.eclecticdesignstudio.motion.actuators.MethodActuator;
import format.SWF;
import format.swf.MovieClip;
import haxe.Timer;
import nme.display.Sprite;
import nme.events.Event;
import nme.geom.Point;
import nme.Lib;
import nme.Assets;
import nme.system.System;
import nme.text.TextField;
import nme.text.TextFormat;
import ru.geekparty.game.AnimatedSprite;
import ru.geekparty.game.Animation;
import ru.geekparty.game.IUpdatable;
import ru.geekparty.game.TextureAtlas;
import com.eclecticdesignstudio.motion.Actuate;

/**
 * ...
 * @author Null/
 */

class Game extends Sprite
{
	public static inline var FPS:Int = 30;
	public static inline var MAX_TICKS:Int = 3;
	
	public var frame:Int;
	public var _lastTickTime:Float;
	public var _tickDt:Float;
	
	private var _scoreTime : Float;
	
	public var _updatable:Array<IUpdatable>;
	private var _girl : Girl;
	private var _scoreText : TextField;
	private var _score : Int = 0;
	private var _scoreCounting : Bool = false;
	
	private var _scoreBar : ProgressContainer;
	private var _axe : AxeContainer;
	private var _prevMousePos : Point;

	public function new() 
	{
		super();
		
		_updatable = [];
		_tickDt = 1.0 / FPS;
		_scoreTime = 1.0;
		
		addEventListener( Event.ADDED_TO_STAGE, initGame );
		_prevMousePos = new Point( mouseX, mouseY );
		
		var sound = Assets.getSound ("assets/music/gp_emma.mp3");
		sound.play (0.0, 9999);
		
		Actuate.timer(2.0 + Math.random() * 3.0).onComplete(onAxeTimer);
		//Timer.delay( onAxeTimer, Std.int( 2000 + Math.random() * 3000 ) );
	}
	
	private function initGame( e:Event = null ):Void
	{
		if ( _girl != null && contains( _girl ) )
			return;
		
		addChild( _girl = new Girl() );
		_girl.addEventListener( "girlTouched", onGirlTouched );
		_girl.addEventListener( "girlReleased", onGirlReleased );
		
		_axe = new AxeContainer();
		_axe.gotoAndStop( 0 );
		_axe.rotation = 90;
		addChild( _axe );
		
		_scoreBar = new ProgressContainer();
		_scoreBar.gotoAndStop(0);
		addChild( _scoreBar );
		
		_axe.x = 600;
		_axe.y = 400;
		
		_scoreBar.x = 20;
		_scoreBar.y = 20;
		
		_girl.x = 240;
		_girl.y = 400;
	}
	
	private function endGame( win :Bool ):Void
	{
		_score = 0;
		_scoreTime = 1;
		removeChild( _girl );
		removeChild( _axe );
		removeChild( _scoreBar );
		
		var gameOverScreen = new GameOverScreen( win );
		addChild( gameOverScreen );
		gameOverScreen.addEventListener( "restartGame", function(e:Event):Void { initGame(); } );
	}
	
	private function onGirlTouched( e:Event ):Void 
	{ 
		Lib.trace("Нажал бабу!");
		_scoreCounting = true;
	}
	private function onGirlReleased( e:Event ):Void { Lib.trace("Отпусиил бабу!"); _scoreCounting = false; }
	
	private function getScore( dt : Float ):Int
	{
		return Math.floor(dt * _scoreTime);
	}
	
	private function onAxeTimer():Void
	{
		Lib.trace("AXE!");
		Actuate.timer(2.0 + Math.random() * 3.0).onComplete(onAxeTimer);
		//Timer.delay( onAxeTimer, Std.int( 2000 + Math.random() * 3000 ) );
		_axe.play();
		Actuate.timer( 1.0 - _girl.scoreMultipler ).onComplete(makeAxeDeadly);
		//haxe.Timer.delay( makeAxeDeadly, 300 );
		Actuate.tween( _axe, 1.2, { rotation : -40 } ).onComplete( revertAxe );
		//haxe.Timer.delay( revertAxe, 500 );
	}
	
	private function makeAxeDeadly():Void
	{
		if ( _scoreCounting )
			endGame( false );
	}
	
	private function revertAxe():Void
	{
		Actuate.tween( _axe, 0.4, { rotation : 90 } );
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
		//-=-=-=-=-=-=Ticking-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
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
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		
		//Score counting
		_scoreTime += 0.001;
		if ( _score > 0 && !_scoreCounting )
			_score -= Math.ceil( 0.3 * _scoreTime * 70 );
		if ( _score < 10000 && _scoreCounting && ( Math.abs(mouseX - _prevMousePos.x) > 0 || Math.abs(mouseY - _prevMousePos.y) > 0 ) )
			_score += Math.ceil( _girl.scoreMultipler * 70 *_scoreTime) ;
		
		if ( _score >= 10000 )
			endGame( true );
		
		if ( _scoreBar != null )
			_scoreBar.gotoAndStop( _score / 100.0 );
		
		for (i in 0...frames)
		{
			for (entity in _updatable)
			{
				entity.update(_tickDt);
			}
		}
		
		_prevMousePos.x = mouseX;
		_prevMousePos.y = mouseY;
	}
	
}