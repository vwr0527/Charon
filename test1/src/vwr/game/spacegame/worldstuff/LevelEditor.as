package vwr.game.spacegame.worldstuff 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import vwr.game.spacegame.Input;
	import vwr.game.spacegame.worldstuff.entities.Camera;
	import vwr.game.spacegame.worldstuff.entities.Cursor;
	/**
	 * ...
	 * @author ...
	 */
	public class LevelEditor extends Sprite
	{
		public var active:Boolean = false;
		
		private var infotext:TextField;
		private var textContainer:Sprite;
		
		private var tileType:int = 0;
		
		public function LevelEditor() 
		{
			infotext = new TextField();
			infotext.textColor = 0xFFFFAA;
			var fmt:TextFormat = new TextFormat();
			fmt.font = "System";
			infotext.defaultTextFormat = fmt;
			textContainer = new Sprite();
			textContainer.addChild(infotext);
			infotext.x += 20;
			infotext.y += 10;
			textContainer.scaleX = 2;
			textContainer.scaleY = 2;
			addChild(textContainer);
			infotext.text = "000";
		}
		
		public function Update(camera:Camera, lvl:Room, curs:Cursor):void 
		{
			lvl.HighlightTileAt(curs.x, curs.y);
			
			if (Input.leftArrow() == 1)
			{
				camera.x -= 10;
			}
			if (Input.rightArrow() == 1)
			{
				camera.x += 10;
			}
			if (Input.upArrow() == 1)
			{
				camera.y -= 10;
			}
			if (Input.downArrow() == 1)
			{
				camera.y += 10;
			}
			
			if (Input.mouseButton() == 1)
			{
				lvl.SwitchTileAt(curs.x, curs.y, tileType);
			}
			
			tileType += Input.mWheel();
			if (tileType > 9) tileType = 0;
			if (tileType < 0) tileType = 9;
			
			infotext.visible = true;
			infotext.text = "tile: " + tileType;
			textContainer.x = curs.x + (-x / scaleX) - (scaleX * 25);
			textContainer.y = curs.y + ( -y / scaleX) - (scaleX * 16);
		}
		
		public function invis():void
		{
			infotext.visible = false;
		}
	}
}