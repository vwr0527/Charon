package vwr.game.spacegame 
{
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Victor Reynolds
	 */
	public class Game extends Sprite
	{
		private var world:World;
		
		public function Game() 
		{
			var myTimer:Timer = new Timer(1000/60);
            myTimer.addEventListener(TimerEvent.TIMER, timerHandler);
            myTimer.start();
			
			world = new World();
			addChild(world);
        }

        public function timerHandler(event:TimerEvent):void
		{
			world.Update();
        }
		
	}

}