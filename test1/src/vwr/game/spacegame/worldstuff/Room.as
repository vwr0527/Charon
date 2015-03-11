package vwr.game.spacegame.worldstuff 
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import vwr.game.spacegame.worldstuff.Tile;
	/**
	 * ...
	 * @author Victor Reynolds
	 */
	public class Room extends Sprite
	{
		public var id:int = 0;
		public var startx:Number = 0;
		public var starty:Number = 0;
		public var roomWidth:Number = 640;
		public var roomHeight:Number = 400;
		public var tileWidth:Number = 40;
		public var tileHeight:Number = 40;
		public var numRows:int = 10;
		public var numCols:int = 16;
		public var tileGrid:Array;
		
		public function Room() 
		{
			super();
			tileGrid = new Array();
		}
	}
}