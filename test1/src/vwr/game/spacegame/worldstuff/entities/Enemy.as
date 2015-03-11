package vwr.game.spacegame.worldstuff.entities 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import vwr.game.spacegame.worldstuff.Entity;
	import vwr.game.spacegame.Input;
	
	/**
	 * ...
	 * @author Victor Reynolds
	 */
	public class Enemy extends Entity 
	{
		private var controlEnabled:Boolean = true;
		
		[Embed(source = "/../../sprite/drone-1.png")]
		private var picture:Class;
		private var speed:Number = 0.35;
		private var ai_strafe:Boolean = false;
		private var ai_counter:int = 0;
		
		public function Enemy() 
		{
			super();
			var pic:Bitmap = new picture();
			pic.smoothing = true;
			pic.bitmapData.threshold(pic.bitmapData, pic.bitmapData.rect, new Point(0, 0), "==", 0xffff00ff);
			pic.bitmapData.colorTransform(pic.bitmapData.rect, new ColorTransform(1.85,1.85,1.85, 1, -50, -50, -50, 0));
			
			var scaleFac:Number = 0.5;
			
			pic.scaleX = scaleFac;
			pic.scaleY = scaleFac;
			pic.x = -(pic.bitmapData.width / 2) * scaleFac;
			pic.y = -(pic.bitmapData.height / 2) * scaleFac;
			
			pic.alpha = 1.0;
			addChildAt(pic, 0);
			//showhitbox = true;
			hitwidth = 30;
			hitheight = 30;
			noclip = false;
			
			friction = 0.94;
			elasticity = 0.5;
			
			ai_strafe = Math.random() > 0.5;
			strafeSpeedFactor = (Math.random() * 0.5) + 0.5;
        }
		
		private function AimAt(xpos:Number, ypos:Number):void
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
		
		private var strafingDistance:Number = 200;
		private var strafeAngle:Number = 90;
		private var strafeSpeedFactor:Number = 0.7;
		private var chaseSerpantine:Number = 50;
		private var chaseAngleMod:Number = 0;
		
		public function SetTarget(xpos:Number, ypos:Number):void
		{
			AimAt(xpos, ypos);
			var rotRad:Number = (rotation / 180) * Math.PI;
			var moveFactor:Number = 1.0;
			
			if (Math.sqrt(Math.pow((x - xpos), 2) + Math.pow((y - ypos), 2)) < strafingDistance)
			{
				rotRad = ((rotation + strafeAngle) / 180) * Math.PI;
				moveFactor = strafeSpeedFactor;
			}
			else
			{
				chaseAngleMod += (Math.random() - 0.5) * chaseSerpantine;
				chaseAngleMod *= 0.9;
				rotRad = ((rotation + chaseAngleMod) / 180) * Math.PI;
			}
			
			xvel += Math.sin(rotRad) * speed * moveFactor;
			yvel -= Math.cos(rotRad) * speed * moveFactor;
		}
		
		public override function Update():void
		{
			++ai_counter;
			if (ai_counter % 400 == (Math.round(Math.random() * 400) as int)) ai_strafe = !ai_strafe;
			if (ai_counter % 300 == (Math.round(Math.random() * 300) as int)) strafeSpeedFactor = (Math.random() * 0.5) + 0.5;
			if (ai_counter % 500 == (Math.round(Math.random() * 500) as int)) strafingDistance = (Math.random() * Math.random() * Math.random() * 300) + 150;
			
			if (ai_strafe)
			{
				strafeAngle = 90;
			}
			else
			{
				strafeAngle = -90;
			}
			
			super.Update();
		}
	}

}