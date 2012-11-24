package ru.geekparty.halfinger;
import nme.display.Sprite;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.text.TextField;
import nme.text.TextFormat;

/**
 * ...
 * @author bL00RiSe
 */

class GameOverScreen extends Sprite
{

	public function new( win : Bool ) 
	{
		super();
		
		/*var infoTF = new TextField();
		infoTF.defaultTextFormat = new TextFormat( "Arial", 16, 0xFFFFFF );
		infoTF.text = win ? "МОЛОДЦА" : "ЛОХ";
		infoTF.x = 100;
		infoTF.y = 10;
		addChild( infoTF );*/
		
		if ( win )
			addChild( new EndGood() );
		else
			addChild( new EndBad() );
		addEventListener( Event.ADDED_TO_STAGE, onStageInit );
	}
	
	public function onStageInit( e:Event ):Void
	{
		stage.addEventListener( MouseEvent.CLICK, restartGame );
	}
	
	private function restartGame( e:MouseEvent ):Void
	{
		stage.removeEventListener( MouseEvent.CLICK, restartGame );
		parent.removeChild( this );
		dispatchEvent( new Event( "restartGame" ) );
	}
	
}