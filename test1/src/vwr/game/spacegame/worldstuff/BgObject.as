package vwr.game.spacegame.worldstuff 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Point;
	import vwr.game.spacegame.Main;
	import com.zehfernando.display.drawPlane;
	/**
	 * ...
	 * @author Victor Reynolds
	 */
	public class BgObject extends Sprite
	{
		public var parralax:Number = 1.0;
		public var pic:Bitmap;
		public var offset:Point;
		
		public function BgObject(picture:Bitmap) 
		{
			super();
			pic = picture;
			addChild(pic);
			offset = new Point();
		}
		
		public function Update(worldX:Number, worldY:Number):void
		{
			this.x = - ((worldX + this.offset.x) * parralax);
			this.y = - ((worldY + this.offset.y) * parralax);
			this.x += this.offset.x + (Main.gameWidth / 2);
			this.y += this.offset.y + (Main.gameHeight / 2);
			pic.x = -pic.width / 2;
			pic.y = -pic.height / 2;
		}
	}

}