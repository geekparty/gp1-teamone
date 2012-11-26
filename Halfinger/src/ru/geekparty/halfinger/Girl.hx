package ru.geekparty.halfinger;
import format.swf.MovieClip;
import nme.display.Sprite;
import nme.events.Event;
import nme.events.MouseEvent;
import com.eclecticdesignstudio.motion.Actuate;
import ru.geekparty.game.IUpdatable;

/**
 * ...
 * @author bL00RiSe
 */

class Girl extends Sprite, implements IUpdatable
{
	private var _container : GirlContainer;

	private var _face:MovieClip;
	private var _titLeft:MovieClip;
	private var _titRight:MovieClip;
	private var _body:MovieClip;
	private var _cunt:MovieClip;
	
	public var scoreMultipler : Float;
	
	var currentClip:MovieClip;

	public function new() 
	{
		super();
		
		scoreMultipler = 1;
		
		_container = new GirlContainer();
		
		_face = cast _container.getChildByName("face");
		_titLeft = cast _container.getChildByName("titLeft");
		_titRight = cast _container.getChildByName("titRight");
		_body = cast _container.getChildByName("body");
		_cunt = cast _container.getChildByName("cunt");
		_container.removeChild( _body );
		
		_face.gotoAndStop(1);
		_titLeft.gotoAndStop(1);
		_titRight.gotoAndStop(1);
		_body.gotoAndStop(1);
		_cunt.gotoAndStop(1);
		
		_face.addEventListener( MouseEvent.MOUSE_DOWN, onTouch );
		_titLeft.addEventListener( MouseEvent.MOUSE_DOWN, onTouch );
		_titRight.addEventListener( MouseEvent.MOUSE_DOWN, onTouch );
		//_body.addEventListener( MouseEvent.MOUSE_DOWN, onTouch );
		_cunt.addEventListener( MouseEvent.MOUSE_DOWN, onTouch );
		
		addEventListener( Event.ADDED_TO_STAGE, onStageInit );
		
		addChild( _container );
	}
	
	private function onStageInit( e: Event ):Void
	{
		stage.addEventListener( MouseEvent.MOUSE_UP, onRelease );
	}
	
	private function onTouch( e:MouseEvent ):Void 
	{
		trace("onTouch");
		//cast(e.currentTarget, MovieClip).gotoAndPlay(2);
		
		currentClip = cast(e.currentTarget, MovieClip);
		
		//currentClip.currentFrame = 2;
		//Actuate.tween(currentClip, 0.3, { "currentFrame" : frames } );
		
		switch( cast(e.currentTarget, MovieClip).name )
		{
			case "face"     : scoreMultipler = 0.8;
			case "titLeft"  : scoreMultipler = 0.6;
			case "titRight" : scoreMultipler = 0.6;
			//case "body"     : scoreMultipler = 1;
			case "cunt"     : scoreMultipler = 0.2;
		}
		dispatchEvent( new Event("girlTouched") );
	}
	private function onRelease( e:MouseEvent ):Void
	{
		trace("onRelease");
		currentClip = null;
		_face.gotoAndStop(1);
		_titLeft.gotoAndStop(1);
		_titRight.gotoAndStop(1);
		_body.gotoAndStop(1);
		_cunt.gotoAndStop(1);
		dispatchEvent( new Event("girlReleased") );
	}
	
	public function update(dt:Float):Void
	{
		if (currentClip == null) return;
		
		var frames:Int = currentClip.totalFrames;		
		
		if (currentClip.currentFrame < frames)
		{
			currentClip.nextFrame();
		}
		else
		{
			currentClip.gotoAndStop(2);
		}
		
	}
	
}