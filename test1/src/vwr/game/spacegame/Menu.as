package vwr.game.spacegame 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Victor Reynolds
	 * 
	 * http://amanindesign.bigcartel.com/product/edge-font
		 * http://www.amanindesign.com/
		 * John Charles Alexander
		 * need permission
	 */
	public class Menu extends Sprite 
	{
		[Embed(source = "/../../sprite/title.png")]
		private var titleresource:Class;
		private var titleBmp:Bitmap;
		private var title:Sprite;
		
		[Embed(source = "/../../sprite/neptune-1.jpg")]
		private var bgpic:Class;
		public function Menu() 
		{
			titleBmp = new titleresource();
			title = new Sprite();
			title.addChild(titleBmp);
			addChild(title);
			titleBmp.x -= titleBmp.bitmapData.width / 2;
			titleBmp.y -= titleBmp.bitmapData.height / 2;
			titleBmp.smoothing = true;
			super();
			x += Main.gameWidth / 2;
			y += Main.gameHeight / 2;
			title.scaleX = 0.75;
			title.scaleY = 0.75;
			title.y -= Main.gameHeight / 4;
			
			var bgbmp:Bitmap = new bgpic();
			bgbmp.x -= bgbmp.bitmapData.width / 2;
			bgbmp.y -= bgbmp.bitmapData.height / 2;
			bgbmp.smoothing = true;
			addChildAt(bgbmp, 0);
		}
		
		private var startfade:Boolean = false;
		public function Update():void
		{
			if (Input.mouseButton() == 1) startfade = true;
			if (startfade) alpha *= 0.9;
			if (alpha < 0.1) visible = false;
		}
	}

}