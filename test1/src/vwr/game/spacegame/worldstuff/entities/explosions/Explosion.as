package vwr.game.spacegame.worldstuff.entities.explosions 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	
	/**
	 * ...
	 * @author Victor Reynolds
	 */
	public class Explosion extends Sprite 
	{
		public static const tiny:int = 0;
		public static const small:int = 1;
		public static const medium:int = 2;
		public static const large:int = 3;
		public static const huge:int = 4;
		
		[Embed(source = "/../../sprite/explosion1.png")]
		private var mediumexplodepic:Class;
		private var bang:Bitmap;
		private var med:Bitmap;
		private var dark:Bitmap;
		
		private var bangc:Sprite;
		private var medc:Sprite;
		private var darkc:Sprite;
		
		private var counter:Number = 0;
		private var speed:Number = 1.0;
		
		public function Explosion() 
		{
			visible = false;
			
			med = new mediumexplodepic();
			med.x -= med.width / 2;
			med.y -= med.height / 2;
			medc = new Sprite();
			addChild(medc);
			medc.addChild(med);
			
			bang = new mediumexplodepic();
			bang.bitmapData.colorTransform(bang.bitmapData.rect, new ColorTransform(2, 2, 2, 2, 50, 50, 50, 0));
			bang.x -= bang.width / 2;
			bang.y -= bang.height / 2;
			bangc = new Sprite();
			addChild(bangc);
			bangc.addChild(bang);
			
			dark = new mediumexplodepic();
			dark.bitmapData.colorTransform(dark.bitmapData.rect, new ColorTransform(0.2, 0.1, 0.2, 1, 80, 70, 80, 0));
			dark.x -= dark.width / 2;
			dark.y -= dark.height / 2;
			darkc = new Sprite();
			addChildAt(darkc, 0);
			darkc.addChild(dark);
			
			speed = 0.7;
			scaleX = 1.8;
			scaleY = 1.8;
			
			super();
		}
		
		public function Update():void
		{
			if (counter > 0)
			{
				counter -= speed * ((Math.random() / 2) + 0.5);
				visible = true;
				alpha = counter / 15;
				
				var shock:Number = (40 - counter) * 0.4;
				if (counter < 23)
				{
					shock = (counter / 8) + 4;
				}
				medc.scaleX = medc.scaleY = (shock / 8) + 0.1;
				medc.alpha = counter / 30;
				darkc.scaleX = darkc.scaleY = 0.8 + ((30 - counter) / 20);
				darkc.alpha = shock / 14;
				bangc.scaleX = bangc.scaleY = 0.2 + Math.max(0,(counter - 26) / 2);
				bangc.alpha = Math.max(0, (counter - 25) / 4);
			}
			else
			{
				visible = false;
			}
		}
		
		public function SetExplosionSize(type:int):void
		{
			switch (type)
			{
				case 0:
					scaleX = scaleY = 1.0;
					speed = 0.9;
					break;
				case 1:
					scaleX = scaleY = 1.8;
					speed = 0.7;
					break;
				case 2:
					scaleX = scaleY = 2.5;
					speed = 0.5;
					break;
			}
		}
		
		public function ExplodeAt(xpos:Number, ypos:Number):Boolean
		{
			if (counter <= 0)
			{
				x = xpos;
				y = ypos;
				counter = 30;
				rotation = Math.random() * 360;
				return true;
			}
			return false;
		}
	}

}