package vwr.game.spacegame.worldstuff 
{
	import flash.display.Shape;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Victor Reynolds
	 */
	public class Tile extends Sprite 
	{
		public var noclip:Boolean = false;
		public var hitbox:Shape;
		public function Tile() 
		{
			super();
			hitbox = new Shape();
			hitbox.graphics.beginFill(0x1144ff, 1);
			hitbox.graphics.drawRect( 0,0, 16, 16);
			hitbox.graphics.endFill();
			addChild(hitbox);
		}
	}

}