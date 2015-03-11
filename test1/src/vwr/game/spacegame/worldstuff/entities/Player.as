package vwr.game.spacegame.worldstuff.entities 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import vwr.game.spacegame.worldstuff.Entity;
	import vwr.game.spacegame.Input;
	
	/**
	 * ...
	 * @author Victor Reynolds
	 */
	public class Player extends Entity 
	{
		private var controlEnabled:Boolean = true;
		
		[Embed(source = "/../../sprite/ship_col.png")]
		private var picture:Class;
		
		public function Player() 
		{
			super();
			var pic:Bitmap = new picture();
			pic.smoothing = true;
			pic.bitmapData.threshold(pic.bitmapData, pic.bitmapData.rect, new Point(0, 0), "==", 0xffff00ff);
			pic.x = -pic.bitmapData.width / 4;
			pic.y = -pic.bitmapData.height / 4;
			pic.scaleX = 0.5;
			pic.scaleY = 0.5;
			addChild(pic);
        }
		
		public override function Update():void
		{
			var speed:Number = 3;
			var diag:Number = speed * 0.707;
			var skip:Boolean = false;
			if (!(Input.moveDown() == 1 && Input.moveUp() == 1))
			{
				if (Input.moveLeft() == 1 && !Input.moveRight() == 1)
				{
					if (Input.moveDown() == 1)
					{
						xvel -= diag;
						yvel += diag;
						skip = true;
					}
					else if (Input.moveUp() == 1)
					{
						xvel -= diag;
						yvel -= diag;
						skip = true;
					}
				}
				else if (Input.moveRight() == 1 && !Input.moveLeft() == 1)
				{
					if (Input.moveDown() == 1)
					{
						xvel += diag;
						yvel += diag;
						skip = true;
					}
					else if (Input.moveUp() == 1)
					{
						xvel += diag;
						yvel -= diag;
						skip = true;
					}
				}
			}
			
			if (!skip)
			{
				if (Input.moveLeft() == 1)
					xvel -= speed;
				if (Input.moveRight() == 1)
					xvel += speed;
				if (Input.moveUp() == 1)
					yvel -= speed;
				if (Input.moveDown() == 1)
					yvel += speed;
			}
			
			super.Update();
		}
	}

}