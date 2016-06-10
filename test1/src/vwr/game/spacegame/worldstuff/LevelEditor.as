package vwr.game.spacegame.worldstuff 
{
	import vwr.game.spacegame.Input;
	import vwr.game.spacegame.worldstuff.entities.Camera;
	import vwr.game.spacegame.worldstuff.entities.Cursor;
	/**
	 * ...
	 * @author ...
	 */
	public class LevelEditor 
	{
		public var active:Boolean = false;
		
		public function LevelEditor() 
		{
			
		}
		
		public function Update(camera:Camera, lvl:Room, curs:Cursor):void 
		{
				lvl.HighlightTileAt(curs.x, curs.y);
				if (Input.leftArrow() == 1)
				{
					camera.x -= 10;
				}
				if (Input.rightArrow() == 1)
				{
					camera.x += 10;
					
				}
				if (Input.upArrow() == 1)
				{
					camera.y -= 10;
					
				}
				if (Input.downArrow() == 1)
				{
					camera.y += 10;
					
				}
		}
		
	}

}