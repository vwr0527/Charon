package vwr.game.spacegame 
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	/**
	 * ...
	 * @author Victor Reynolds
	 */
	public class Game extends Sprite
	{
		private var world:World;
		private var input:Input;
		
		public function Game() 
		{
			input = new Input();
			
			addEventListener(Event.ENTER_FRAME, Update);
			
			world = new World();
			
			addChild(world);
			addChild(input);
        }
		

        public function Update(event:Event):void
		{
			input.Update();
			world.Update();
        }
		
	}

}