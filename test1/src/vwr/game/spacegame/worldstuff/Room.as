package vwr.game.spacegame.worldstuff 
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import vwr.game.spacegame.worldstuff.Tile;
	import vwr.game.spacegame.worldstuff.tiles.Metal;
	import vwr.game.spacegame.Main;
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
		public var bg:Bitmap;
		public var bgObjs:Array;
		public var parralax:Number = 0.5;
		public var bgScale:Number = 2;
		public var highlightStore:Sprite;
		
		public function Room() 
		{
			super();
			tileGrid = new Array();
			highlightStore = new Sprite();
			addChild(highlightStore);
			bgObjs = new Array();
		}
		
		public final function ConstructRoom(layout:Array):void
		{
			for (var i:int = 0; i < numRows; ++i)
			{
				var row:Array = new Array();
				for (var j:int = 0; j < numCols; ++j)
				{
					var tile:Tile = null;
					if (layout[i][j] == 1)
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
		
		public function HighlightTile(ix:int, iy:int):void
		{
			return;
			
			
			var marker:Shape = new Shape();
			
			var color:uint = 0x009922;
			
			/* for testing purposes
			if (highlightStore.numChildren == 0)
			{
				color = 0x000000;
			}
			else if (highlightStore.numChildren == 1)
			{
				
				color = 0xffffff;
			}
			else if (highlightStore.numChildren == 2)
			{
				
				color = 0xff0000;
			}
			else if (highlightStore.numChildren == 3)
			{
				color = 0x00ff00;
				
			}
			else if (highlightStore.numChildren == 4)
			{
				
				color = 0x0000ff;
			}
			else if (highlightStore.numChildren == 5)
			{
				color = 0xff00ff;
				
			}
			else if (highlightStore.numChildren == 6)
			{
				
				color = 0x00ffff;
			}
			else if (highlightStore.numChildren == 7)
			{
				color = 0xffff00;
				
			}
			else if (highlightStore.numChildren == 8)
			{
				color = 0x888888;
			}
			*/
			marker.graphics.beginFill(color, 0.4);
			marker.graphics.lineStyle(1, 0xff8822, 0.7);
			marker.graphics.drawRect(
				(ix * tileWidth),
				(iy * tileHeight),
				tileWidth,tileHeight);
			marker.graphics.endFill();
			marker.visible = true;
			highlightStore.addChild(marker);
		}
		
		public function Update():void
		{
			this.bg.x = -parent.x * parralax;
			this.bg.y = -parent.y * parralax;
			this.bg.scaleX = bgScale;
			this.bg.scaleY = bgScale;
			this.bg.x -= this.bg.width / 2 - Main.gameWidth / 2;
			this.bg.y -= this.bg.height / 2 - Main.gameHeight / 2;
			
			for each (var bgObj:BgObject in bgObjs)
			{
				bgObj.Update(parent.x, parent.y);
			}
		}
		
		public function getIndexAtPosX(posX:Number):int
		{
			var index:int = int(Math.floor((posX) / this.tileWidth));
			if (index < 0) index = 0;
			if (index > this.numCols - 1) index = this.numCols - 1;
			return index;
		}
		
		public function getIndexAtPosY(posY:Number):int
		{
			var index:int = int(Math.floor((posY) / this.tileHeight));
			if (index < 0) index = 0;
			if (index > this.numRows - 1) index = this.numRows - 1;
			return index;
		}
	}
}