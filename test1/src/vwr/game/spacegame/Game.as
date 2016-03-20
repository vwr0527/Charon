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
		
		public function Game() 
		{
			input = new Input();
			
			addEventListener(Event.ENTER_FRAME, Update);
			
			world = new World();
			menu = new Menu();
			
			Mouse.hide();
			
			addChild(world);
			addChild(menu);
			addChild(input);
        }
		
        public function Update(event:Event):void
		{
			input.Update();
			world.Update();
			menu.Update();
        }
	}
}