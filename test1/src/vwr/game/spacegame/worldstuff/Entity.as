package vwr.game.spacegame.worldstuff 
{
	import flash.display.Sprite;
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
		public var friction:Number = 0.9;
		
		public function Entity() 
		{
			super();
		}
		
		public function Update():void
		{
			x += xvel;
			y += yvel;
			rotation += rotvel;
			xvel *= friction;
			yvel *= friction;
			rotvel *= friction;
			
			if (Math.abs(xvel) < 0.1) xvel = 0;
			if (Math.abs(yvel) < 0.1) yvel = 0;
			if (Math.abs(rotvel) < 0.1) rotvel = 0;
		}
	}

}