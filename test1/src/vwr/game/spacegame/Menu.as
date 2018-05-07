package vwr.game.spacegame 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import vwr.game.spacegame.ui.MenuPage;
	
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
		
		private var mainMenu:MenuPage;
		
		public var active:Boolean;
		
		public function Menu() 
		{
			active = false;
			visible = false;
			
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
			
			mainMenu = new MenuPage();
			addChild(mainMenu);
			
			mainMenu.AddMenuItem("New Game", "Game Start");
			mainMenu.AddMenuItem("Continue", "Game Start");
			mainMenu.AddMenuItem("Options", "Nothing");
			mainMenu.AddMenuItem("Quit", "Quit");
		}
		
		public function Update():void
		{
			if (!active)
			{
				visible = false;
				return;
			}
			visible = true;
			mainMenu.Update();
		}
		
		public function IsCommandPending():Boolean
		{
			return mainMenu.IsCommandPending();
		}
		public function GetCommand():String
		{
			return mainMenu.GetCommand();
		}
	}
}