package vwr.game.spacegame.worldstuff.entities 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import vwr.game.spacegame.worldstuff.entities.shots.SlowRedLaser;
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
		public function Shot() 
		{
			super();
        }
		
		public override function Confine(minx:Number, miny:Number, maxx:Number, maxy:Number):void
		{
			super.Confine(minx, miny, maxx, maxy);
		}
		
		public override function CollideTiles(currentRoom:Room):void
		{
			super.CollideTiles(currentRoom);
		}
		
		//returns true or false. don't modify ent. let world handle it.
		public function HitEnt(ent:Entity):Boolean
		{
			return false;
		}
		
		//this only checks if x -> px intersects a specified square. It doesn't change anything.
		protected function DidIntersectSquare(minx:Number, miny:Number, maxx:Number, maxy:Number):Boolean 
		{
			return false;
		}
		
		//it will only get here if collidetiles determines that it was within the tile
		//therefore, it doesn't check if it is actually intersecting the square.
		protected function HitSquare(xmin:Number, ymin:Number, xmax:Number, ymax:Number):void
		{
		}
		
		public function DoHit():void
		{
		}
		
		public function GetType():int
		{
			return 0;
		}
		
		public override function Update():void
		{
			super.Update();
		}
		
		//if the bullet is ready to be shot, it will shoot it and return true
		//if it's not ready, it returns false
		public function Shoot(xpos:Number, ypos:Number, dir:Number):Boolean
		{
			return false;
		}
		
		public function GetDamage():Number
		{
			return 0;
		}
	}
}