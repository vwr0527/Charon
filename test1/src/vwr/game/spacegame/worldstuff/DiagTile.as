package vwr.game.spacegame.worldstuff 
{
	/**
	 * ...
	 * @author Victor Reynolds
	 */
	public class DiagTile extends Tile 
	{
		public var dir:int = 0;
		public function DiagTile(direction:int) 
		{
			dir = direction;
			if (direction == 0)
			{
			}
			else if (direction == 1)
			{
			}
			else if (direction == 2)
			{
			}
			else
			{
				dir = 3;
			}
		}
		
	}

}