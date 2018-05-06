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
	public class Cinematic extends Sprite 
	{
		[Embed(source = "/../../sprite/title.png")]
		private var titleresource:Class;
		private var titleBmp:Bitmap;
		private var title:Sprite;
		
		public var active:Boolean;
		public var userInteracted:Boolean;
		
		[Embed(source = "/../../sprite/neptune-1.jpg")]
		private var bgpic:Class;
		public function Cinematic() 
		{
			active = true;
			
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
		
		public function Update():void
		{
			if (active)
			{
				visible = true;
				if (Input.mouseButton() == 1 || Input.esc() == 2) userInteracted = true;
			}
			if (!active)
			{
				visible = false;
			}
		}
	}

}