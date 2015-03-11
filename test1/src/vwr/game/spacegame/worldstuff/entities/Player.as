package vwr.game.spacegame.worldstuff.entities 
{
	import flash.display.Bitmap;
	import vwr.game.spacegame.worldstuff.Entity;
	
	/**
	 * ...
	 * @author Victor Reynolds
	 */
	public class Player extends Entity 
	{
		[Embed(source = "/../../sprite/ship_col.png")]
		private var picture:Class;
		
		public function Player() 
		{
			super();
			var pic:Bitmap = new picture();
			addChild(pic);
		}
		
		public function Update():void
		{
			x += 1;
			y += 1;
		}
	}

}