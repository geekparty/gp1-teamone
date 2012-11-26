package ru.geekparty.halfinger;
import com.eclecticdesignstudio.motion.actuators.GenericActuator;
import com.eclecticdesignstudio.motion.actuators.MethodActuator;
import format.swf.MovieClip;
import haxe.Timer;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.Sprite;
import nme.events.Event;
import nme.geom.Point;
import nme.Lib;
import nme.Assets;
import nme.media.Sound;
import nme.media.SoundChannel;
import nme.system.System;
import nme.text.TextField;
import nme.text.TextFormat;
import ru.geekparty.game.AnimatedSprite;
import ru.geekparty.game.Animation;
import ru.geekparty.game.IUpdatable;
import ru.geekparty.game.TextureAtlas;
import com.eclecticdesignstudio.motion.Actuate;
import nme.display.Sprite;
import format.swf.MovieClip;
import com.eclecticdesignstudio.motion.easing.Quad;


import nme.events.MouseEvent;

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
	private var _score : Int;
	private var _scoreCounting : Bool;
	
	private var _scoreBar : ProgressContainer;
	private var _axe : MovieClip;
	private var _axeHitArea:MovieClip;
	private var _prevMousePos : Point;
	
	private var sound:Sound;
	private var currentChannel:SoundChannel;
	
	
	private var _axeRevert:Bool;
	private var _axeMoving:Bool;
	private var _soundPlaying:Bool;
	
	var timerAxe:Dynamic;
	private var splashScreen:Sprite;
	
	
	
	

	public function new() 
	{
		super();
		
		
		_axeMoving = false;
		
		_score = 0;
		_scoreCounting = false;
		
		_updatable = [];
		_tickDt = 1.0 / FPS;
		_scoreTime = 1.0;
		
		addEventListener( Event.ADDED_TO_STAGE, addSplash );
		_prevMousePos = new Point( mouseX, mouseY );
		
		sound = Assets.getSound ("assets/music/gp_emma.mp3");
		
		
		
		//Actuate.timer(2.0 + Math.random() * 3.0).onComplete(onAxeTimer);
		//Timer.delay( onAxeTimer, Std.int( 2000 + Math.random() * 3000 ) );
	}
	
	private function addSplash(e:Event = null ):Void
	{
		var splash:BitmapData = Assets.getBitmapData("assets/img/splash.jpg");		
		splashScreen = new Sprite();
		splashScreen.addChild(new Bitmap(splash));
		addChild(splashScreen);
		
		splashScreen.addEventListener( Event.ADDED_TO_STAGE, function(e:Event):Void
									  {
										Timer.delay(onSplashTimer, 3000);
									  } );
		
		
		
		addEventListener(MouseEvent.CLICK, splashClicked);		
	}
	
	private function onSplashTimer():Void
	{
		splashClicked();
	}
	
	private function splashClicked(?e:MouseEvent = null):Void
	{
		if (splashScreen == null) return;
		removeEventListener(MouseEvent.CLICK, splashClicked);
		removeChild(splashScreen);
		splashScreen = null;
		
		initGame();
		Start();
	}
	
	
	private function initGame( e:Event = null ):Void
	{
		if ( _girl != null && contains( _girl ) )
			return;
			


		addChild( _girl = new Girl() );
		_girl.addEventListener( "girlTouched", onGirlTouched );
		_girl.addEventListener( "girlReleased", onGirlReleased );
		
		_updatable.push(_girl);
		
		_axe = new AxeContainer();
		_axeHitArea = cast _axe.getChildByName("axeHitArea");
		//_axe.gotoAndStop( 0 );
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
		
		Actuate.stop(_axe);
		_axe.rotation = 90;
		
	/*
		removeChild( _girl );
		removeChild( _axe );
		removeChild( _scoreBar );
	*/
		
		var gameOverScreen = new GameOverScreen( win );
		gameOverScreen.alpha = 0.0;
		Actuate.tween(gameOverScreen, 1.0, { "alpha" : 1.0 } );
		addChild( gameOverScreen );
		gameOverScreen.addEventListener( "restartGame", function(e:Event):Void { initGame(); } );
	}
	
	private function onGirlTouched( e:Event ):Void 
	{ 
		Lib.trace("Нажал бабу!");
		currentChannel = sound.play(0, -1);
		_scoreCounting = true;
		Timer.delay(onAxeTimer, Math.floor(Math.random() * 3000));
	}
	private function onGirlReleased( e:Event ):Void {
		currentChannel.stop();
		Lib.trace("Отпусиил бабу!");
		_scoreCounting = false; 		
		//Actuate.reset();
	}
	
	private function getScore( dt : Float ):Int
	{
		return Math.floor(dt * _scoreTime);
	}
	
	private function onAxeTimer():Void
	{
		Lib.trace("AXE!");
		//if (timerAxe != null) Actuate.stop(timerAxe);
		
		//timerAxe = Actuate.timer(Math.random() * 3.0).onComplete(onAxeTimer);
		/*
		if (_scoreCounting) 
		{
				Timer.delay(onAxeTimer, Math.floor(Math.random() * 3000));
			}
			else 
			{
				Timer.delay(onAxeTimer, Math.floor(Math.random() * 3000));
				return;
			}
		}
		*/
		
		if ((!_axeMoving) && (_scoreCounting))
		{
			_axeMoving = true;
			_axeRevert = false;
			Actuate.tween( _axe, 1.2, {rotation : -40 } ).onComplete( revertAxe ).ease(Quad.easeIn);
		}
	}
	
	private function makeAxeDeadly():Void
	{		
		if ( _scoreCounting )
			endGame( false );
	}
	
	private function revertAxe():Void
	{
		//_scoreCounting = false;
		_axeRevert = true;
		Actuate.tween( _axe, 0.8, { rotation : 90 } ).onComplete(function():Void { _axeMoving = false; Timer.delay(onAxeTimer, Math.floor(Math.random() * 3000)); } );
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
			_score += Math.ceil( _girl.scoreMultipler * 70 * _scoreTime) ;
			
		if ((_scoreCounting) && (!_axeRevert))
		{
			var normRotation:Float =  1 - ((_axe.rotation + 40) / 130);
			normRotation *= normRotation;
			var p:Point = globalToLocal(new Point(mouseX, mouseY));
			var normY:Float =  p.y / stage.stageHeight;
			
			var eps:Float = 0.1;
			
			var delta:Float = (normY - normRotation);
			
			if ((normY < normRotation) && (Math.abs(delta)<eps))
			{
				makeAxeDeadly();
			}
			
			
			/*
			
			if (_axeHitArea.hitTestPoint(p.x,p.y))
			{
				makeAxeDeadly();
			}
			*/
		}
		
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