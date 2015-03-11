package vwr.game.spacegame.worldstuff 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Point;
	import vwr.game.spacegame.Main;
	import com.zehfernando.display.drawPlane;
	import vwr.game.spacegame.worldstuff.entities.Camera;
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
		
		public function Update(camera:Camera):void
		{
			//this.x = - ((((Main.gameWidth / 2) - camera.x) + this.offset.x) * parralax) + this.offset.x + (Main.gameWidth / 2);
			//this.y = - ((((Main.gameHeight / 2) - camera.y) + this.offset.y) * parralax) + this.offset.y + (Main.gameHeight / 2);
			// -( (a - b + c) * p) + c + a
			// -( ap - bp + cp ) + c + a
			// -ap + bp - cp + c + a
			// -ap + a - cp + c + bp
			// a(-p + 1) + c(-p + 1) + bp
			// (1 - p)(a + b) + bp
			
			this.x = ((1 - parralax) * ((Main.gameWidth / 2) + this.offset.x)) + (camera.x * parralax);
			this.y = ((1 - parralax) * ((Main.gameHeight / 2) + this.offset.y)) + (camera.y * parralax);
			pic.x = -pic.width / 2;
			pic.y = -pic.height / 2;
		}
	}

}