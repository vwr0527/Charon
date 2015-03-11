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
	public class LightMetal extends Tile 
	{
		
		
		[Embed(source = "/../../sprite/mtile02.png")]
		private var picture:Class;
		
		public function LightMetal() 
		{
			var pic:Bitmap = new picture();
			//pic.smoothing = true;
			pic.bitmapData.threshold(pic.bitmapData, pic.bitmapData.rect, new Point(0, 0), "==", 0xffff00ff);
			//pic.x = -pic.bitmapData.width / 2;
			//pic.y = -pic.bitmapData.height / 2;
			pic.width /= 2;
			pic.height /= 2;
			addChild(pic);
		}
		
	}

}