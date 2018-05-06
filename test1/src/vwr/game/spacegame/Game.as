package vwr.game.spacegame 
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.ui.Mouse;
	/**
	 * ...
	 * @author Victor Reynolds
	 */
	public class Game extends Sprite
	{
		private var world:World;
		private var input:Input;
		private var menu:Menu;
		private var cinematic:Cinematic;
		private var cursor:MenuCursor;
		
		public function Game() 
		{
			input = new Input();
			
			addEventListener(Event.ENTER_FRAME, Update);
			
			world = new World();
			menu = new Menu();
			cinematic = new Cinematic();
			cursor = new MenuCursor();
			
			Mouse.hide();
			
			addChild(world);
			addChild(cinematic);
			addChild(menu);
			addChild(cursor);
			addChild(input);
        }
		
        public function Update(event:Event):void
		{
			world.Update();
			cinematic.Update();
			menu.Update();
			
			cursor.x = mouseX;
			cursor.y = mouseY;
			cursor.visible = menu.active || cinematic.active;
			
			if (Input.esc() == 2)
			{
				if (cinematic.active)
				{
					menu.active = !menu.active;
					world.SetMenuActive(menu.active);
				}
				else
				{
					menu.active = !menu.active;
					world.Pause(menu.active);
					world.SetMenuActive(menu.active);
				}
			}
			if (Input.mouseButton() == 2)
			{
				if (cinematic.active && !menu.active)
				{
					menu.active = true;
					world.SetMenuActive(menu.active);
				}
			}
			
			input.Update();
			
			if (menu.IsCommandPending())
			{
				if (menu.GetCommand() == "Game Start")
				{
					world.Pause(false);
					menu.active = false;
					world.SetMenuActive(menu.active);
					cinematic.active = false;
				}
			}
        }
	}
}