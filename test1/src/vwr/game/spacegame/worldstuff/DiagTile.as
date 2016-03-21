package vwr.game.spacegame.worldstuff 
{
	/**
	 * ...
	 * @author Victor Reynolds
	 */
	public class DiagTile extends Tile 
	{
		/*
		 * dir = 0
		 * __
		 * |/
		 * 
		 * dir = 1
		 * __
		 * \|
		 * 
		 * dir = 2
		 * 
		 * /|
		 * --
		 * 
		 * dir = 3
		 * 
		 * |\
		 * --
		 * 
		 */
		public var dir:int = 0;
		public function DiagTile(direction:int) 
		{
			if (direction > 3) direction = 3;
			if (direction < 0) direction = 0;
			dir = direction;
		}
		
	}

}