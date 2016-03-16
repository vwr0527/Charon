package vwr.game.spacegame.worldstuff.entities.shots 
{
	import flash.geom.ColorTransform;
	import vwr.game.spacegame.worldstuff.entities.Shot;
	
	/**
	 * ...
	 * @author Victor Reynolds
	 */
	public class SlowRedLaser extends Laser 
	{
		public function SlowRedLaser() 
		{
			super();
			
			damage = 1;
			speed = 15;
			laserSize = 0.4;
			laserLengthFactor = 0.07;
			impactSize = 0.8;
			
			pic.scaleX = laserSize;
			pic.scaleY = laserSize * speed * laserLengthFactor;
			pic.x = -(pic.bitmapData.width / 2) * laserSize;
			pic.y = -((pic.bitmapData.height * speed * laserLengthFactor) / 4) * laserSize;
			pic.bitmapData.colorTransform(pic.bitmapData.rect, new ColorTransform(1, 2, 2, 1, 50, -255, -255, 0));
			pic2.scaleX = impactSize;
			pic2.scaleY = impactSize;
			pic2.x = -(pic2.bitmapData.width / 2) * impactSize;
			pic2.y = -(pic2.bitmapData.height / 2) * impactSize;
			pic2.bitmapData.colorTransform(pic2.bitmapData.rect, new ColorTransform(1.2, 2, 2, 1, 0, -250, -250, 0));
		}
		
		public override function GetType():int
		{
			return 3;
		}
	}
}