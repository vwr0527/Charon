package vwr.game.spacegame.worldstuff.entities 
{
	import flash.display.Sprite;
	import vwr.game.spacegame.worldstuff.Entity;
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author Victor Reynolds
	 */
	public class Cursor extends Entity 
	{
		
		[Embed(source = "/../../sprite/cursor_x.png")]
		private var picture:Class;
		private var pic1:Bitmap;
		private var pic2:Bitmap;
		private var container1:Sprite;
		//private var container2:Sprite;
		
		public function Cursor() 
		{
			super();
			
			container1 = new Sprite();
			//container2 = new Sprite();
			
			pic1 = new picture();
			pic1.smoothing = true;
			pic1.scaleX /= 2;
			pic1.scaleY /= 2;
			pic1.x -= pic1.bitmapData.width / 4;
			pic1.y -= pic1.bitmapData.height / 4;
			container1.addChild(pic1);
			/*
			pic2 = new picture();
			pic2.smoothing = true;
			pic2.x -= pic2.bitmapData.width * 0.375;
			pic2.y -= pic2.bitmapData.height * 0.375;
			pic2.scaleX *= 0.75;
			pic2.scaleY *= 0.75;
			container2.addChild(pic2);
			pic2.alpha = 0.25;
			*/
			addChild(container1);
			//addChild(container2);
		}
		
		public override function Update():void
		{
			//container2.rotation -= 2.5;
			
			container1.rotation += 3;
		}
	}

}