package vwr.game.spacegame.worldstuff.entities.shots 
{
	import flash.geom.ColorTransform;
	import vwr.game.spacegame.worldstuff.entities.Shot;
	
	/**
	 * ...
	 * @author Victor Reynolds
	 */
	public class Plasma extends Laser 
	{
		[Embed(source = "/../../sprite/pball.png")]
		protected var ppic:Class;
		
		public function Plasma() 
		{
			super();
			removeChild(pic);
			pic = new ppic();
			pic.smoothing = false;
			addChildAt(pic, 0);
			
			damage = 4;
			speed = 10;
			laserSize = 0.75;
			impactSize = 1.5;
			
			pic.scaleX = laserSize;
			pic.scaleY = laserSize;
			pic.x = -(pic.bitmapData.width / 2) * laserSize;
			pic.y = -(pic.bitmapData.height / 2) * laserSize;
			pic.bitmapData.colorTransform(pic.bitmapData.rect, new ColorTransform(2, 1, 2, 0.85, -255, 50, -255, 0));
			pic2.scaleX = impactSize;
			pic2.scaleY = impactSize;
			pic2.x = -(pic2.bitmapData.width / 2) * impactSize;
			pic2.y = -(pic2.bitmapData.height / 2) * impactSize;
			pic2.bitmapData.colorTransform(pic2.bitmapData.rect, new ColorTransform(2, 1.2, 2, 0.85, -250, 0, -250, 0));
		}
		
		public override function Update():void
		{
			super.Update();
			pic.scaleX = laserSize * (0.6 + (Math.random() * 0.4));
			pic.scaleY = pic.scaleX;
			pic.x = -(pic.bitmapData.width / 2) * pic.scaleX;
			pic.y = -(pic.bitmapData.height / 2) * pic.scaleX;
		}
		
		public override function GetType():int
		{
			return 2;
		}
	}
}