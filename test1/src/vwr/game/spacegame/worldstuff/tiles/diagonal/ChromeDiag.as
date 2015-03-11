package vwr.game.spacegame.worldstuff.tiles.diagonal 
{
	import vwr.game.spacegame.worldstuff.Tile;
	import vwr.game.spacegame.worldstuff.DiagTile;
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Victor Reynolds
	 */
	public class ChromeDiag extends DiagTile 
	{
		
		
		[Embed(source = "/../../sprite/diag-01-br.png")]
		private var picture:Class;
		
		public function ChromeDiag(direction:int) 
		{
			super(direction);
			var pic:Bitmap = new picture();
			pic.bitmapData.threshold(pic.bitmapData, pic.bitmapData.rect, new Point(0, 0), "==", 0xffff00ff);
			removeChildAt(0);
			addChild(pic);
			
			if (dir == 0)
			{
				pic.rotation = 180;
				pic.x += pic.width;
				pic.y += pic.height;
			}
			else if (dir == 1)
			{
				pic.rotation = -90;
				pic.y += pic.height;
			}
			else if (dir == 2)
			{
			}
			else
			{
				pic.rotation = 90;
				pic.x += pic.width;
			}
		}
		
	}

}