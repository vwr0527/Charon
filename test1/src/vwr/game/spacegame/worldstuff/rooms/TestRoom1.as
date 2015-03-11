package vwr.game.spacegame.worldstuff.rooms 
{
	import vwr.game.spacegame.worldstuff.Room;
	import vwr.game.spacegame.worldstuff.Tile;
	import flash.display.Shape;
	
	/**
	 * ...
	 * @author Victor Reynolds
	 */
	public class TestRoom1 extends Room 
	{
		
		public function TestRoom1() 
		{
			super();
			
			var bg:Shape = new Shape();
			bg.graphics.beginFill(0x644f4f);
			bg.graphics.drawRect(startx, starty, roomWidth, roomHeight);
			bg.graphics.endFill();
			addChild(bg);
			
			for (var i:int = 0; i < numRows; ++i)
			{
				var row:Array = new Array();
				for (var j:int = 0; j < numCols; ++j)
				{
					var tile:Tile = new Tile();
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