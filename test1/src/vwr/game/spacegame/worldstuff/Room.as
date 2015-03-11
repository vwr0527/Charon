package vwr.game.spacegame.worldstuff 
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import vwr.game.spacegame.worldstuff.entities.Camera;
	import vwr.game.spacegame.worldstuff.Tile;
	import vwr.game.spacegame.worldstuff.tiles.*;
	import vwr.game.spacegame.Main;
	import vwr.game.spacegame.worldstuff.tiles.diagonal.ChromeDiag;
	/**
	 * ...
	 * @author Victor Reynolds
	 * 
	 * reminder:
	 * topleft corner of the topleft tile is 0,0
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
		private var highlightStore:Sprite;
		public var numToSpawn:int = 0;
		
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
					if (layout[i][j] != 0)
					{
						tile = makeNewTile(layout[i][j]);
						tile.x = j * tileWidth;
						tile.y = i * tileHeight;
						tile.width = tileWidth;
						tile.height = tileHeight;
						addChild(tile);
					}
					row.push(tile);
				}
				tileGrid.push(row);
			}
		}
		
		private function makeNewTile(id:int):Tile 
		{
			if (id == 0) return null;
			else if (id == 1) return new Metal();
			else if (id == 2) return new Plating();
			else if (id == 3) { var newtile:Tile = new Plating(); newtile.noclip = true; return newtile; }
			else if (id == 4) { newtile = new DarkLightMetal(); newtile.noclip = true; return newtile; }
			else if (id == 5) { return new LightMetal(); }
			else if (id == 6) { return new ChromeDiag(0); }
			else if (id == 7) { return new ChromeDiag(1); }
			else if (id == 8) { return new ChromeDiag(2); }
			else if (id == 9) { return new ChromeDiag(3); }
			
			return null;
		}
		
		public function ResetHighlight():void 
		{
			while (highlightStore.numChildren > 0)
			{
				highlightStore.removeChildAt(0);
			}
		}
		public function Update():void
		{
		}
		public function UpdateBG(camera:Camera):void
		{
			this.bg.x = camera.x * parralax;
			this.bg.y = camera.y * parralax;
			this.bg.scaleX = this.bg.scaleY = bgScale;
			this.bg.x -= this.bg.width / 2;
			this.bg.y -= this.bg.height / 2;
			this.bg.x += (startx + (roomWidth / 2)) * (1 - parralax);
			this.bg.y += (starty + (roomHeight / 2)) * (1 - parralax);
			
			for each (var bgObj:BgObject in bgObjs)
			{
				bgObj.Update(camera);
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
		
		public function SpawnPendingEntity():Entity
		{
			--numToSpawn;
			return null;
		}
		
		public function HighlightTile(ix:int, iy:int):void
		{
			setChildIndex(highlightStore, this.numChildren - 1);
			var marker:Shape = new Shape();
			var color:uint = 0x009922;
			
			/*
			// for testing purposes
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
	}
}