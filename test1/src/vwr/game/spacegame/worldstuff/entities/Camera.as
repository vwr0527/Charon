package vwr.game.spacegame.worldstuff.entities 
{
	import vwr.game.spacegame.worldstuff.Entity;
	
	/**
	 * ...
	 * @author Victor Reynolds
	 */
	public class Camera extends Entity 
	{
		
		public function Camera() 
		{
			super();
		}
		
		public override function Update():void
		{
			super.Update();
			//keep tiles and other bitmaps from "jittering"
			x = Math.round(x);
			y = Math.round(y);
		}
		
	}

}