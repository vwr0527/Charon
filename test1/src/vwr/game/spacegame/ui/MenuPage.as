package vwr.game.spacegame.ui 
{
	import flash.display.Sprite;
	import vwr.game.spacegame.Input;
	import vwr.game.spacegame.Main;
	/**
	 * ...
	 * @author ...
	 */
	public class MenuPage extends Sprite
	{
		public var menuItems:Array;
		public var active:Boolean;
		
		private var command:String;
		private var commandPending:Boolean;
		
		public function MenuPage() 
		{
			super();
			
			menuItems = new Array();
		}
		
		public function AddMenuItem(name:String, com:String):void
		{
			var newItem:MenuItem = new MenuItem(name, com);
			
			newItem.textField.y = (30 * menuItems.length) - 30;
			newItem.textField.x = -newItem.textField.width / 2;
			
			menuItems.push(newItem);
			addChild(newItem);
		}
		
		public function Update():void
		{
			for (var i:int = 0; i < menuItems.length; ++i)
			{
				if (mouseY > menuItems[i].textField.y - 5 && mouseY < menuItems[i].textField.y + 25)
				{
					menuItems[i].textField.textColor = 0xFFFFFF;
					if (Input.mouseButton() == 2)
					{
						SetCommand(menuItems[i].command);					
					}
				}
				else
				{
					menuItems[i].textField.textColor = 0xFFFF00;
				}
			}
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