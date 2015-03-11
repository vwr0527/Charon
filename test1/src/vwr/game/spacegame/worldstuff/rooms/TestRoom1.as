package vwr.game.spacegame.worldstuff.rooms 
{
	import vwr.game.spacegame.worldstuff.Room;
	import vwr.game.spacegame.worldstuff.Tile;
	import flash.display.Bitmap;
	import vwr.game.spacegame.worldstuff.tiles.*;
	
	/**
	 * ...
	 * @author Victor Reynolds
	 */
	public class TestRoom1 extends Room 
	{
		[Embed(source = "/../../sprite/bg_blur_dark.png")]
		private var picture:Class;
		
		public function TestRoom1() 
		{
			super();
			
			bg = new picture();
			bg.scaleX = bg.scaleY = 1.25;
			addChildAt(bg, 0);
			
			for (var i:int = 0; i < numRows; ++i)
			{
				var row:Array = new Array();
				for (var j:int = 0; j < numCols; ++j)
				{
					var tile:Tile = null;
					if (i == 0 || i == numRows - 1 || j == 0 || j == numCols - 1 || (j == 8 && i == 5))
					{
						tile = new Metal();
						tile.x = j * tileWidth;
						tile.y = i * tileHeight;
						addChild(tile);
					}
					row.push(tile);
				}
				tileGrid.push(row);
			}
		}
		
	}

}