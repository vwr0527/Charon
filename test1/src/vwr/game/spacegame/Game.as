package vwr.game.spacegame 
{
	import flash.display.ShaderInput;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
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
			
			var myTimer:Timer = new Timer(1000 / Settings.UPDATE_FREQUENCY);
            myTimer.addEventListener(TimerEvent.TIMER, timerHandler);
            myTimer.start();
			
			world = new World();
			
			addChild(world);
			addChild(input);
        }
		

        public function timerHandler(event:TimerEvent):void
		{
			input.Update();
			world.Update();
        }
		
	}

}