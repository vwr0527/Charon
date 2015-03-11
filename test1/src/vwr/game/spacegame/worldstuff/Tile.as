package vwr.game.spacegame.worldstuff 
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Victor Reynolds
	 */
	public class Tile extends Sprite 
	{
		
		[Embed(source = "/../../sprite/mtile01.png")]
		private var picture:Class;
		
		public function Tile() 
		{
			super();
			var pic:Bitmap = new picture();
			pic.smoothing = true;
			pic.bitmapData.threshold(pic.bitmapData, pic.bitmapData.rect, new Point(0, 0), "==", 0xffff00ff);
			//pic.x = -pic.bitmapData.width / 2;
			//pic.y = -pic.bitmapData.height / 2;
			//pic.width /= 2;
			//pic.height /= 2;
			addChild(pic);
		}
		
	}

}