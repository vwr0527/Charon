package vwr.game.spacegame.worldstuff 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import vwr.game.spacegame.Main;
	/**
	 * ...
	 * @author Victor Reynolds
	 */
	public class BgObject extends Sprite
	{
		public var parralax:Number = 1.0;
		public var bgScale:Number = 1.0;
		public var pic:Bitmap;
		public var xoffset:Number = 0.0;
		public var yoffset:Number = 0.0;
		
		public function BgObject(picture:Bitmap) 
		{
			super();
			pic = picture;
			addChild(pic);
			pic.x -= pic.width / 2;
			pic.y -= pic.height / 2;
		}
		
		public function Update(worldX:Number, worldY:Number):void
		{
			this.x = -worldX * parralax;
			this.y = -worldY * parralax;
			this.scaleX = bgScale;
			this.scaleY = bgScale;
			this.x += this.xoffset + Main.gameWidth / 2;
			this.y += this.yoffset + Main.gameHeight / 2;
		}
	}

}