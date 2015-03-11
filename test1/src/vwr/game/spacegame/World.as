package vwr.game.spacegame 
{
	import flash.display.Sprite;
	import vwr.game.spacegame.worldstuff.entities.Player;
	
	/**
	 * ...
	 * @author Victor Reynolds
	 */
	public class World extends Sprite 
	{
		private var sequenceNumber:Number;
		private var player:Player;
		
		public function World() 
		{
			super();
			sequenceNumber = 0;
			player = new Player();
			addChild(player);
		}
		
		public function Update():void
		{
			//trace ("Hello" + sequenceNumber);
			++sequenceNumber;
			player.Update();
		}
	}

}