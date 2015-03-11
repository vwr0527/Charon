package vwr.game.spacegame
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	[SWF(width = '640', height = '400', backgroundColor = '#000000', frameRate = 60)]
	/**
	 * ...
	 * @author Victor Reynolds
	 */
	public class Main extends Sprite 
	{
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			var game:Game = new Game();
			addChild(game);
		}
		
	}
	
}