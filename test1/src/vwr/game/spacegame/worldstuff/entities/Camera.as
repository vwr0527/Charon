package vwr.game.spacegame.worldstuff.entities 
{
	import flash.geom.Point;
	import vwr.game.spacegame.worldstuff.Entity;
	
	/**
	 * ...
	 * @author Victor Reynolds
	 */
	public class Camera extends Entity 
	{
		public var zoom:Number = 1;
		public var targetZoom:Number = 0.9;
		public var maxDistance:Number = 400;
		private var followPoint:Point = new Point();
		
		public function Camera() 
		{
			super();
		}
		
		public override function Update():void
		{
			xvel = (followPoint.x - x) / 8;
			yvel = (followPoint.y - y) / 6;
			
			super.Update();
			//keep tiles and other bitmaps from "jittering"
			x = Math.round(x);
			y = Math.round(y);
		}
		
		public function LearnPositions(playerX:Number, playerY:Number, cursorX:Number, cursorY:Number):void
		{
			followPoint.x = (cursorX + (playerX * 2)) / 3;
			followPoint.y = (cursorY + (playerY * 2)) / 3;
			var fpDist:Number = Math.sqrt(Math.pow((playerX - cursorX) / (stage.stageWidth / stage.stageHeight), 2) + Math.pow(playerY - cursorY, 2));
			if (fpDist > maxDistance)
			{
				followPoint.x = playerX + (((cursorX - playerX) / fpDist) * maxDistance / 3);
				followPoint.y = playerY + (((cursorY - playerY) / fpDist) * maxDistance / 3);
			}
			zoom = targetZoom - Math.min(Math.sqrt(Math.pow((playerX - followPoint.x) / (stage.stageWidth / stage.stageHeight), 2) + Math.pow(playerY - followPoint.y, 2)) / 1000, 0.2);
		}
	}

}