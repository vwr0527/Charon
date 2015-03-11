package vwr.game.spacegame.worldstuff.tiles 
{
	import vwr.game.spacegame.worldstuff.Tile;
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Victor Reynolds
	 */
	public class Plating extends Tile 
	{
		
		[Embed(source = "/../../sprite/plating.png")]
		private var picture:Class;
		
		public function Plating()
		{
			super();
			
			var pic:Bitmap = new picture();
			//pic.smoothing = true;
			pic.bitmapData.threshold(pic.bitmapData, pic.bitmapData.rect, new Point(0, 0), "==", 0xffff00ff);
			//pic.x = -pic.bitmapData.width / 2;
			//pic.y = -pic.bitmapData.height / 2;
			//pic.width /= 2;
			//pic.height /= 2;
			pic.width = 40;
			pic.height = 40;
			addChild(pic);
		}
		
	}

}