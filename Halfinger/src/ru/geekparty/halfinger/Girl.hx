package ru.geekparty.halfinger;
import format.swf.MovieClip;
import nme.display.Sprite;

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
		
		
		
		addChild( _container );
	}
	
}