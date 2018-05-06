package vwr.game.spacegame 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.system.fscommand;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
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
		
		private var infotext:Array;
		private var textContainer:Array;
		private var numMenuItems:Number;
		private var command:String;
		private var commandPending:Boolean;
		
		public var active:Boolean;
		
		public function Menu() 
		{
			active = false;
			visible = false;
			command = "";
			commandPending = false;
			
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
			infotext = new Array();
			textContainer = new Array();
			numMenuItems = 0;
			
			AddMenuItem("New Game");
			AddMenuItem("Continue");
			AddMenuItem("Options");
			AddMenuItem("Quit");
		}
		
		public function Update():void
		{
			if (!active)
			{
				visible = false;
				return;
			}
			visible = true;
			
			for (var i:int = 0; i < numMenuItems; ++i)
			{
				if (mouseY > infotext[i].y - 5 && mouseY < infotext[i].y + 25)
				{
					infotext[i].textColor = 0xFFFFFF;
					if (Input.mouseButton() == 2)
					{
						if (i == 3)
						{
							fscommand("quit");
						}
						if (i == 0 || i == 1)
						{
							SetCommand("Game Start");
						}
					}
				}
				else
				{
					infotext[i].textColor = 0xFFFF00;
				}
			}
		}
		
		private function AddMenuItem(name:String):void
		{
			var fmt:TextFormat = new TextFormat();
			fmt.font = "System";
			
			infotext.push(new TextField());
			infotext[numMenuItems].textColor = 0xFFFF00;
			infotext[numMenuItems].defaultTextFormat = fmt;			
			textContainer.push(new Sprite());
			textContainer[numMenuItems].addChild(infotext[numMenuItems]);
			infotext[numMenuItems].y = (30 * numMenuItems) - 30;
			infotext[numMenuItems].x = -textContainer[numMenuItems].width / 2;
			addChild(textContainer[numMenuItems]);
			infotext[numMenuItems].text = name;
			
			++numMenuItems;
		}
		
		private function SetCommand(com:String):void
		{
			command = com;
			commandPending = true;
		}
		public function IsCommandPending():Boolean
		{
			return commandPending;
		}
		public function GetCommand():String
		{
			commandPending = false;
			return command;
		}
	}
}