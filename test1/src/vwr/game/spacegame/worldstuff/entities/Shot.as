package vwr.game.spacegame.worldstuff.entities 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import vwr.game.spacegame.worldstuff.Entity;
	import vwr.game.spacegame.Input;
	import vwr.game.spacegame.worldstuff.Room;
	import vwr.game.spacegame.worldstuff.Tile;
	
	/**
	 * ...
	 * @author Victor Reynolds
	 */
	public class Shot extends Entity 
	{
		private var controlEnabled:Boolean = true;
		
		[Embed(source = "/../../sprite/shot01.png")]
		private var picture:Class;
		[Embed(source = "/../../sprite/hit01.png")]
		private var hitpic:Class;
		
		private var speed:Number = 28;
		private var impact:int = 5; // 0 = traveling, 1 or more is frames after hit
		private var counter:int = 0;
		
		public function Shot() 
		{
			super();
			var pic:Bitmap = new picture();
			pic.smoothing = true;
			pic.bitmapData.threshold(pic.bitmapData, pic.bitmapData.rect, new Point(0, 0), "==", 0xffff00ff);
			pic.bitmapData.colorTransform(pic.bitmapData.rect, new ColorTransform(2, 0.5, 0.5, 1, 250, 50, 50, 0));
			
			var scaleFac:Number = 0.75;
			
			pic.scaleX = scaleFac;
			pic.scaleY = scaleFac;
			pic.x = -(pic.bitmapData.width / 2) * scaleFac;
			pic.y = -(pic.bitmapData.height / 2) * scaleFac;
			
			pic.alpha = 1.0;
			addChildAt(pic, 0);
			
			//impact pic
			var pic2:Bitmap = new hitpic();
			pic2.smoothing = true;
			pic2.bitmapData.threshold(pic2.bitmapData, pic2.bitmapData.rect, new Point(0, 0), "==", 0xffff00ff);
			pic2.bitmapData.colorTransform(pic2.bitmapData.rect, new ColorTransform(1.2,1.2,1.2, 1, 0, -50, -50, 0));
			
			var scaleFac2:Number = 1;
			
			pic2.scaleX = scaleFac2;
			pic2.scaleY = scaleFac2;
			pic2.x = -(pic2.bitmapData.width / 2) * scaleFac2;
			pic2.y = -(pic2.bitmapData.height / 2) * scaleFac2;
			
			pic2.alpha = 1.0;
			addChildAt(pic2, 1);
			
			//showhitbox = true;
			hitwidth = 1;
			hitheight = 1;
			noclip = false;
			
			friction = 1;
			elasticity = 0.0;
        }
		
		public override function Confine(minx:Number, miny:Number, maxx:Number, maxy:Number):void
		{
			if (x > maxx)
			{
				DoHit();
			}
			if (y > maxy)
			{
				DoHit();
			}
			if (x  < minx)
			{
				DoHit();
			}
			if (y < miny)
			{
				DoHit();
			}
		}
		public override function CollideTiles(currentRoom:Room):void
		{
			//if outside of tileGrid's bounds, do nothing
			if (this.y + this.hitheight / 2 < 0
			|| this.x + this.hitwidth / 2 < 0
			|| this.y - this.hitheight / 2 > (currentRoom.numRows * currentRoom.tileHeight)
			|| this.x - this.hitwidth / 2 > (currentRoom.numCols * currentRoom.tileWidth))
			{
				return;
			}
			
			//if no tiles, do nothing
			if (currentRoom.tileGrid.length == 0) return;
			
			//point collision
			var closest_index_x:int = currentRoom.getIndexAtPosX(this.x);
			var closest_index_y:int = currentRoom.getIndexAtPosY(this.y);
			HitTile(currentRoom.tileGrid[closest_index_y][closest_index_x]);
		}
		
		private function HitTile(tile:Tile):void
		{
			if (tile == null) return;
			if (tile.noclip) return;
			/*if (tile is DiagTile)
			{
				HitDiagTile(tile as DiagTile);
				return;
			}*/
			DoHit();
		}
		
		private function DoHit():void
		{
			if (impact != 0) return;
			impact = 1;
			counter = 0;
			xvel = 0;
			yvel = 0;
		}
		
		public override function Update():void
		{
			++counter;
			if (impact > 0 && impact <= 4)
			{
				getChildAt(0).alpha = 0;
				getChildAt(1).alpha = (4 - impact) * 1.0;
				rotation = Math.random() * 360;
				scaleX = scaleY = (4 - impact) * 1.0;
				++impact;
			}
			if (impact == 5)
			{
				getChildAt(0).alpha = 0;
				getChildAt(1).alpha = 0;
			}
			if (impact == 0)
			{
				getChildAt(0).alpha = 1;
				getChildAt(1).alpha = 0;
				scaleX = scaleY = 1.0;
			}
			super.Update();
			if (counter > 100 && impact == 0) DoHit();
		}
		
		//if the bullet is ready to be shot, it will shoot it and return true
		//if it's not ready, it returns false
		public function Shoot(xpos:Number, ypos:Number, dir:Number):Boolean
		{
			if (impact == 5)
			{
				x = xpos;
				y = ypos;
				var raddir:Number = (dir / 180) * Math.PI;
				xvel = -Math.sin(-raddir) * speed;
				yvel = -Math.cos(raddir) * speed;
				rotation = dir;
				impact = 0;
				counter = 0;
				return true;
			}
			return false;
		}
	}

}