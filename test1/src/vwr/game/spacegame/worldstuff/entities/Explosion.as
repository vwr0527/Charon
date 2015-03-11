package vwr.game.spacegame.worldstuff.entities 
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
			dark.bitmapData.colorTransform(dark.bitmapData.rect, new ColorTransform(1, 0.5, 0.5, 1, -50, -100, -100, 0));
			dark.x -= dark.width / 2;
			dark.y -= dark.height / 2;
			darkc = new Sprite();
			addChildAt(darkc, 0);
			darkc.addChild(dark);
			
			super();
		}
		
		public function Update():void
		{
			if (counter > 0)
			{
				visible = true;
				counter -= (Math.random() / 2) + 0.5;
				
				alpha = counter / 15;
				
				var shock:Number = 30 - counter;
				if (counter < 25)
				{
					shock = counter / 5;
				}
				else
				{
					rotation = Math.random() * 360;
				}
				medc.scaleX = medc.scaleY = ((shock * shock) / 80) + 0.75;
				medc.alpha = counter / 30;
				darkc.scaleX = darkc.scaleY = ((100 - counter) + shock) / 60;
				darkc.alpha = 0.5;
				if (counter > 25)
				{
					bangc.scaleX = bangc.scaleY = (counter - 25) / 2.5;
					bangc.alpha = (counter - 25) / 4;
				}
				else
				{
					bangc.alpha = 0;
				}
			}
			else
			{
				visible = false;
			}
		}
		
		public function ExplodeAt(xpos:Number, ypos:Number):Boolean
		{
			if (counter <= 0)
			{
				x = xpos;
				y = ypos;
				counter = 30;
				return true;
			}
			return false;
		}
	}

}