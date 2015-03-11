package vwr.game.spacegame.worldstuff.entities 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import vwr.game.spacegame.worldstuff.Entity;
	import vwr.game.spacegame.Input;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Victor Reynolds
	 */
	public class Player extends Entity 
	{
		private var controlEnabled:Boolean = true;
		
		[Embed(source = "/../../sprite/ship_col.png")]
		private var picture:Class;
		private var speed:Number = 0.5;
		
		
		public function Player() 
		{
			super();
			var pic:Bitmap = new picture();
			pic.smoothing = true;
			pic.bitmapData.threshold(pic.bitmapData, pic.bitmapData.rect, new Point(0, 0), "==", 0xffff00ff);
			pic.scaleX = 0.5;
			pic.scaleY = 0.5;
			pic.x = -pic.bitmapData.width / 4;
			pic.y = -pic.bitmapData.height / 4;
			pic.alpha = 1.0;
			addChildAt(pic, 0);
			//showhitbox = true;
			hitwidth = 30;
			hitheight = 30;
			noclip = false;
			
			friction = 0.95;
        }
		
		public function AimAt(xpos:Number, ypos:Number):void
		{
			var targetRotation:Number = ((180 / Math.PI) * Math.atan2(ypos - y, xpos - x)) + 90;
			if (targetRotation >= 180) targetRotation -= 360;
			var deltaRotation:Number = targetRotation - rotation;
			if (deltaRotation > 180) deltaRotation -= 360;
			if (deltaRotation < -180) deltaRotation += 360;
			//trace ("current: " + rotation + " , target: " + targetRotation);
			if (deltaRotation > 30) deltaRotation = 30;
			if (deltaRotation < -30) deltaRotation = -30;
			rotvel = deltaRotation / 3;
		}
		
		public override function Update():void
		{
			if (stage != null)
			{
				stage.addEventListener(MouseEvent.MOUSE_DOWN, mouse_down);
				stage.addEventListener(MouseEvent.MOUSE_UP, mouse_up);
			}
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
		
		private function mouse_down(e:MouseEvent):void
		{
		   isMouseDown = true;
		}
		private function mouse_up(e:MouseEvent):void
		{
		   isMouseDown = false;
		}
		public function MouseDown():Boolean
		{
			return isMouseDown;
		}
		private var isMouseDown:Boolean = false;
	}
}