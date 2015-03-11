package vwr.game.spacegame.worldstuff 
{
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Victor Reynolds
	 */
	public class Entity extends Sprite
	{
		public var xvel:Number = 0.0;
		public var yvel:Number = 0.0;
		public var rotvel:Number = 0.0;
		public var friction:Number = 0.99;
		public var rotfric:Number = 0.99;
		protected var hitbox:Shape;
		public var noclip:Boolean = true;
		
		public function Entity() 
		{
			super();
			hitbox = new Shape();
			hitbox.graphics.beginFill(0xff9922, 0.2);
			hitbox.graphics.lineStyle(1, 0x1188ff, 0.7);
			hitbox.graphics.drawRect( -5, -5, 10, 10);
			hitbox.graphics.endFill();
			hitbox.visible = false;
			addChild(hitbox);
		}
		
		public function Update():void
		{
			x += xvel;
			y += yvel;
			rotation += rotvel;
			hitbox.rotation = -rotation;
			xvel *= friction;
			yvel *= friction;
			rotvel *= rotfric;
			
			if (Math.abs(xvel) < 0.1) xvel = 0;
			if (Math.abs(yvel) < 0.1) yvel = 0;
			if (Math.abs(rotvel) < 0.1) rotvel = 0;
		}
		
		public var elasticity:Number = 0.75;
		public function Confine(minx:Number, miny:Number, maxx:Number, maxy:Number):void
		{
			//need to unrotate hitbox for this, and rerotate it after
			hitbox.rotation = 0;
			if (x + hitbox.width / 2 > maxx)
			{
				x = maxx - hitbox.width / 2;
				xvel *= -elasticity;
			}
			if (y + hitbox.height / 2 > maxy)
			{
				y = maxy - hitbox.height / 2;
				yvel *= -elasticity;
			}
			if (x - hitbox.width / 2  < minx)
			{
				x = minx + hitbox.width / 2;
				xvel *= -elasticity;
			}
			if (y - hitbox.height / 2 < miny)
			{
				y = miny + hitbox.height / 2;
				yvel *= -elasticity;
			}
			//rerotate hitbox
			hitbox.rotation = -rotation;
		}
		
		private var hittime:Number = -1.0;
		public function HitTile(tile:Tile):void
		{
		}
	}

}

				/*
				if (tile.hitbox.hitTestObject(hitbox))
				{
					trace ("hit" + asdf);
					tile.hitbox.
					++asdf;
				}
				/*
				var minx:Number = x - (hitbox.width / 2);
				var miny:Number = y - (hitbox.height / 2);
				var maxx:Number = x + (hitbox.width / 2);
				var maxy:Number = y + (hitbox.height / 2);
				
				var tminx:Number = tile.x - (tile.width / 2);
				var tminy:Number = tile.y - (tile.height / 2);
				var tmaxx:Number = tile.x + (tile.width / 2);
				var tmaxy:Number = tile.y + (tile.height / 2);
				
				var hit:Boolean = false;
				
				if (minx > tminx && minx < tmaxx)
				{
					if (miny > tminy && miny < tmaxy)
					{
						hit = true;
					}
				}
				if (maxx > tminx && maxx < tmaxx)
				{
					if (maxy > tminy && maxy < tmaxy)
					{
						hit = true;
					}
				}
				
				if (minx > tminx && minx < tmaxx)
				{
					if (maxy > tminy && maxy < tmaxy)
					{
						hit = true;
					}
				}
				if (maxx > tminx && maxx < tmaxx)
				{
					if (miny > tminy && miny < tmaxy)
					{
						hit = true;
					}
				}
				
				if (hit)
					trace("hit");
				*/