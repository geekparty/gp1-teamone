package ru.geekparty.halfinger;
import format.swf.MovieClip;
import nme.display.Sprite;
import nme.events.Event;
import nme.events.MouseEvent;

/**
 * ...
 * @author bL00RiSe
 */

class Girl extends Sprite
{
	private var _container : GirlContainer;

	private var _face:MovieClip;
	private var _titLeft:MovieClip;
	private var _titRight:MovieClip;
	private var _body:MovieClip;
	private var _cunt:MovieClip;

	public function new() 
	{
		super();
		_container = new GirlContainer();
		
		_face = cast _container.getChildByName("face");
		_titLeft = cast _container.getChildByName("titLeft");
		_titRight = cast _container.getChildByName("titRight");
		_body = cast _container.getChildByName("body");
		_cunt = cast _container.getChildByName("cunt");
		
		_face.addEventListener( MouseEvent.MOUSE_DOWN, onTouch );
		_face.addEventListener( MouseEvent.MOUSE_UP, onRelease );
		_titLeft.addEventListener( MouseEvent.MOUSE_DOWN, onTouch );
		_titLeft.addEventListener( MouseEvent.MOUSE_UP, onRelease );
		_titRight.addEventListener( MouseEvent.MOUSE_DOWN, onTouch );
		_titRight.addEventListener( MouseEvent.MOUSE_UP, onRelease );
		_body.addEventListener( MouseEvent.MOUSE_DOWN, onTouch );
		_body.addEventListener( MouseEvent.MOUSE_UP, onRelease );
		_cunt.addEventListener( MouseEvent.MOUSE_DOWN, onTouch );
		_cunt.addEventListener( MouseEvent.MOUSE_UP, onRelease );
		
		addChild( _container );
	}
	
	private function onTouch( e:MouseEvent ):Void { dispatchEvent( new Event("girlTouched") ); }
	private function onRelease( e:MouseEvent ):Void { dispatchEvent( new Event("girlReleased") ); }
	
}