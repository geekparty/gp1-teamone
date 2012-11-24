package ru.geekparty.game;

/**
 * ...
 * @author Null/
 */

 
typedef TAnimation = {
	var frames:Array<String>;
	var fps:Int;
	var loop:Bool;
}

typedef TAnimationState = {
	var currentAnimation:TAnimation;
	var timer:Float;
	var currentFrame:Int;
	var completeCb:Void->Void;
	
}

class Animation implements IUpdatable
{
	
	public var animations:Hash<TAnimation>;
	public var state:TAnimationState;
	public var valid:Bool;
	
	public var currentFrame(_getCurrentFrame, null):String;

	public function new() 
	{
		animations = new Hash<TAnimation>();
		valid = true;
	}
	
	public function addAnimation(name:String, frames:Array<String>, ?fps:Int = 12, ?loop:Bool = false):Void
	{
		animations.set(name, {"frames" : frames
							 , "fps" : cast fps
							 , "loop" : cast loop } );
	}
	
	public function playAnimation(name:String, ?onComplete:Void->Void):Void
	{
		state = {
			currentAnimation : animations.get(name)
			, timer : 0.0
			, currentFrame: -1
			, completeCb : onComplete 
		};
		update(0.0);
	}
	
	private function _getCurrentFrame():String
	{
		if (state == null) return null;
		if (state.currentFrame < 0) return null;
		
		return state.currentAnimation.frames[state.currentFrame];
	}
	
	public function update(dt:Float):Void
	{
		if (state == null) return;
		
		state.timer += dt;
	
		var frame:Int = Math.floor(state.timer * state.currentAnimation.fps);
		if (frame > state.currentFrame)
		{
			if (frame > (state.currentAnimation.frames.length - 1))
			{
				if (state.currentAnimation.loop)
				{
					state.currentFrame = 0;
					state.timer = 0.0;
				}
				else
				{
					if (state.completeCb != null)
					{
						state.completeCb();
					}
					state = null;
					return;
				}
			}
			else
			{
				state.currentFrame = frame;
			}
			valid = false;
		}
	}
	
}