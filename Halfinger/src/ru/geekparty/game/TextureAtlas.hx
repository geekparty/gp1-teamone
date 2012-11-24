package ru.geekparty.game;
import nme.display.BitmapData;
import nme.display.Graphics;
import nme.display.Tilesheet;
import nme.geom.Point;
import nme.geom.Rectangle;
import haxe.Json;

/**
 * ...
 * @author Null/
 */

typedef DrawJob = {
	var rect:String;
	var point:Point;
	var rotation:Float;
};



class TextureAtlas 
{
	public var tilesheet:Tilesheet;
	public var frames:Hash < Rectangle >;
	public var frameName2IndexMap:Hash<Int>;

	public function new(image:BitmapData, framesDescJson:String):Void 
	{
		var data:Dynamic = Json.parse(framesDescJson);
		frames = new Hash<Rectangle>();
		frameName2IndexMap = new Hash<Int>();
		tilesheet = new Tilesheet(image);
		
		var i:Int = 0;
		for (frameName in Reflect.fields(data.frames))
		{
			var frame:Dynamic = Reflect.field(data.frames, frameName).frame;
			var r:Rectangle   = new Rectangle( Std.parseFloat(frame.x)
											, Std.parseFloat(frame.y)
											, Std.parseFloat(frame.w)
											, Std.parseFloat(frame.h));
			frames.set( frameName, r );
			frameName2IndexMap.set( frameName, i++ ); 								
			tilesheet.addTileRect( r );
		}
	}
	
	public function DrawTiles(graphics:Graphics, jobs:Array<DrawJob>, ?smooth:Bool = false):Void
	{
		var tileData:Array<Float> = [];
		//[ x, y, tile ID, scale, rotation, red, green, blue, alpha, x, y ... ]
		
		
		var useRotation:Bool =  false; 
		
		for (job in jobs)
		{
			tileData.push( job.point.x );
			tileData.push( job.point.y );
			tileData.push( frameName2IndexMap.get(job.rect) );
			tileData.push( job.rotation );
		}
		
		var flags:Int = 0x0 | Tilesheet.TILE_ROTATION;
		
		tilesheet.drawTiles( graphics, tileData, smooth, flags );
	}
	
}