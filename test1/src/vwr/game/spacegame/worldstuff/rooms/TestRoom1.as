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
			addChild(bg);
			/*
			numRows = 20;
			numCols = 32;
			tileWidth = 20;
			tileHeight = 20;
			*/
			for (var i:int = 0; i < numRows; ++i)
			{
				var row:Array = new Array();
				for (var j:int = 0; j < numCols; ++j)
				{
					var tile:Tile = new Metal();
					tile.x = j * tileWidth;
					tile.y = i * tileHeight;
					row.push(tile);
					addChild(tile);
					if (i != 0 && i != numRows - 1)
					{
						if (j != 0 && j != numCols - 1)
						{
							tile.visible = false;
						}
					}
				}
				tileGrid.push(row);
			}
		}
		
	}

}