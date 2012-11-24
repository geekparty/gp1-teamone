package ru.geekparty.game;
import nme.display.Sprite;
import nme.geom.Point;

/**
 * ...
 * @author Null/
 */

typedef AtlasAnimationPair = {
	var atlas:TextureAtlas;
	var animation:Animation;
}

class AnimatedSprite extends Sprite, implements IUpdatable
{
	
	public var atlases:Array<AtlasAnimationPair>;
	private var currentAtlasIndex:Int;
	
	public function new(?atlases:Array<TextureAtlas>) 
	{
		super();
		
		currentAtlasIndex = -1;
		this.atlases = [];
		for (ta in atlases)
		{
			this.atlases.push( { atlas : ta, animation : new Animation() } );
		}
	}
	
	public function addAnimation(name:String, atlasIndex:Int, frames:Array<String>, ?fps:Int = 12, ?loop:Bool = false):Void
	{
		atlases[atlasIndex].animation.addAnimation( name, frames, fps, loop );
	}
	
	public function playAnimation(name:String, ?onComplete:Void->Void):Void
	{
		currentAtlasIndex = -1;
		
		var i:Int = 0;
		for (ta in atlases)
		{
			if (ta.animation.animations.exists(name))
			{
				ta.animation.playAnimation(name, onComplete);
				currentAtlasIndex = i;
			}
			else
			{
				//stop all
				ta.animation.state = null;
			}
			i++;
		}
	}
	
	
	public function update(dt:Float):Void
	{
		if (currentAtlasIndex >= 0)
		{
			atlases[currentAtlasIndex].animation.update(dt);
			if (atlases[currentAtlasIndex].animation.state == null)
			{
				currentAtlasIndex = -1;
			}
		}
		
		draw();
	}
	
	
	public function draw():Void
	{
		if (currentAtlasIndex >= 0)
		{
			var atlasAnimPair:AtlasAnimationPair = atlases[currentAtlasIndex];
			var animation:Animation = atlasAnimPair.animation;
			var currentFrame:String = animation.currentFrame;
			
			if ((currentFrame != null) && (!animation.valid))
			{
				animation.valid = true;
				graphics.clear();
				
				var atlas:TextureAtlas = atlasAnimPair.atlas;
				atlas.DrawTiles( graphics
						, [ {
							rect : currentFrame
							, point : new Point(0, 0)
							, rotation : 0.0
						} ] );
			}
		}
	}
	
	
}