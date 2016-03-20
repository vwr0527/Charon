package vwr.game.spacegame.worldstuff.entities.enemies 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import vwr.game.spacegame.worldstuff.entities.Enemy;
	import vwr.game.spacegame.worldstuff.entities.explosions.*;
	import vwr.game.spacegame.worldstuff.entities.Shot;
	import vwr.game.spacegame.worldstuff.Entity;
	import vwr.game.spacegame.Input;
	
	/**
	 * ...
	 * @author Victor Reynolds
	 */
	public class RedEnemy extends Enemy 
	{
		[Embed(source = "/../../sprite/enemy01.png")]
		private var picture:Class;
		
		[Embed(source = "/../../sprite/thrust01.png")]
		private var thrust:Class;
		private var thst:Bitmap;
		private var thst2:Bitmap;
		
		[Embed(source = "/../../sprite/shieldhit1.png")]
		private var shieldhitpic:Class;
		private var hit1:Bitmap;
		private var hitparent:Sprite;
		
		[Embed(source = "/../../sprite/shieldhit2.png")]
		private var shieldhitpic2:Class;
		private var hit2:Bitmap;
		
		private var speed:Number = 0.35;
		private var ai_strafe:Boolean = false;
		private var ai_counter:int = 0;
		private var ai_stunned:int = 0;
		private var ai_shootreload:int = 0;
		private var ai_shootready:Boolean = false;
		private const fullhealth:Number = 20.0;
		private var health:Number = fullhealth;
		
		public function RedEnemy() 
		{
			super();
			var pic:Bitmap = new picture();
			pic.smoothing = true;
			pic.bitmapData.threshold(pic.bitmapData, pic.bitmapData.rect, new Point(0, 0), "==", 0xffff00ff);
			//pic.bitmapData.colorTransform(pic.bitmapData.rect, new ColorTransform(1.85, 1.85, 1.85, 1, -50, -50, -50, 0));
			
			var scaleFac:Number = 1;
			
			pic.scaleX = scaleFac;
			pic.scaleY = scaleFac;
			pic.x = -(pic.bitmapData.width / 2) * scaleFac;
			pic.y = -(pic.bitmapData.height / 2) * scaleFac;
			
			pic.alpha = 1.0;
			addChildAt(pic, 0);
			
			thst = new thrust();
			thst.bitmapData.colorTransform(thst.bitmapData.rect, new ColorTransform(2, 2, 1, 1.5, -255, -255, 50, -110));
			thst.blendMode = "add";
			addChild(thst);
			thst.scaleX = 0.5;
			thst.scaleY = 0.5;
			thst.alpha = 2;
			setThrustDir(0, thst);
			
			thst2 = new thrust();
			thst2.bitmapData.colorTransform(thst2.bitmapData.rect, new ColorTransform(2, 2, 1, 1.5, -255, -255, 50, -110));
			thst2.blendMode = "add";
			addChild(thst2);
			thst2.scaleX = 0.5;
			thst2.scaleY = 0.5;
			thst2.alpha = 2;
			setThrustDir(1, thst2);
			
			hit1 = new shieldhitpic();
			hit1.bitmapData.colorTransform(hit1.bitmapData.rect, new ColorTransform(2, 1, 2, 1, -255, 50, -255, 0));
			hit1.blendMode = "add";
			hit1.scaleX = 2;
			hit1.scaleY = 2;
			hit1.x -= hit1.width / 2;
			hit1.y -= hit1.height / 2;
			hit1.y -= 30;
			hit1.alpha = 0;
			
			hit2 = new shieldhitpic2();
			hit2.bitmapData.colorTransform(hit2.bitmapData.rect, new ColorTransform(2, 1, 2, 1, -255, 50, -255, 0));
			hit2.blendMode = "add";
			hit2.scaleX = 2;
			hit2.scaleY = 2;
			hit2.x -= hit1.width / 2;
			hit2.y -= hit1.height / 2;
			hit2.alpha = 0;
			
			hitparent = new Sprite();
			addChild(hitparent);
			hitparent.addChild(hit1);
			hitparent.addChild(hit2);
			hitparent.scaleX = 1.5;
			hitparent.scaleY = 1.5;
			
			//showhitbox = true;
			
			hitwidth = 60;
			hitheight = 60;
			noclip = false;
			
			friction = 0.95;
			elasticity = 0.2;
			speed = 0.2;
			rotfric = 0.9;
			
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
			rotvel -= (rotvel - (deltaRotation / 3)) / 40;
		}
		
		private var strafingDistance:Number = 500;
		private var strafeAngle:Number = 90;
		private var strafeSpeedFactor:Number = 1.2;
		private var chaseSerpantine:Number = 30;
		private var chaseAngleMod:Number = 0;
		
		public override function SetTarget(xpos:Number, ypos:Number):void
		{
			if (ai_stunned < 0) AimAt(xpos, ypos);
			var rotRad:Number = (rotation / 180) * Math.PI;
			var moveFactor:Number = 1.0;
			
			var distToTarget:Number = Math.sqrt(Math.pow((x - xpos), 2) + Math.pow((y - ypos), 2));
			
			if (distToTarget < strafingDistance)
			{
				rotRad = ((rotation + strafeAngle) / 180) * Math.PI;
				moveFactor = strafeSpeedFactor;
				
				var ximpulse:Number = xvel * friction - Math.sin(rotRad) * speed * moveFactor;
				var yimpulse:Number = yvel * friction + Math.cos(rotRad) * speed * moveFactor;
				var impulse:Number = Math.sqrt(Math.pow(ximpulse, 2) + Math.pow(yimpulse, 2));
				ai_shootready = true;
				
				thst.visible = false;
				thst2.visible = false;
			}
			else
			{
				if (distToTarget > strafingDistance * 1.1)
					chaseAngleMod += (Math.random() - 0.5) * chaseSerpantine;
				chaseAngleMod *= 0.99;
				rotRad = ((rotation + chaseAngleMod) / 180) * Math.PI;
				
				thst.visible = true;
				thst.alpha = Math.abs(80 - chaseAngleMod) / 160;
				setThrustDir(0, thst);
				
				thst2.visible = true;
				thst2.alpha = Math.abs(80 + chaseAngleMod) / 160;
				setThrustDir(1, thst2);
				
				ai_shootready = false;
			}
			
			xvel += Math.sin(rotRad) * speed * moveFactor;
			yvel -= Math.cos(rotRad) * speed * moveFactor;
		}
		
		public override function Update():void
		{
			if (!active)
			{
				visible = false;
				noclip = true;
				return;
			}
			
			++ai_counter;
			if (ai_counter % 400 == (Math.round(Math.random() * 400) as int)) ai_strafe = !ai_strafe;
			if (ai_counter % 300 == (Math.round(Math.random() * 300) as int)) strafeSpeedFactor = (Math.random() * 0.5) + 0.5;
			if (ai_counter % 500 == (Math.round(Math.random() * 500) as int)) strafingDistance = (Math.random() * Math.random() * 300) + 200;
			
			if (ai_strafe)
			{
				strafeAngle = 70;
			}
			else
			{
				strafeAngle = -70;
			}
			
			hit1.alpha *= 0.75;
			hit2.alpha *= 0.99;
			hitparent.rotation -= rotvel;
			--ai_stunned;
			super.Update();
		}
		
		public override function GetHit(shot:Shot):void
		{
			hit1.alpha = 2 + Math.random();
			hit2.alpha = 0.1 + Math.random() * 0.45;
			health -= shot.GetDamage();
			if (health < 0) active = false;
			xvel += 0.1 * (shot.x - shot.px);
			yvel += 0.1 * (shot.y - shot.py);
			rotvel += (Math.random() * 10) - 5;
			ai_stunned = Math.random() * 6;
			hitparent.rotation = -rotation + (((180 / Math.PI) * Math.atan2(y - shot.y, x - shot.x)) - 90);
		}
		
		private var shootLeft:Boolean = false;
		public override function HandleShooting(shootLaserFunc:Function):void
		{
			var rotRad:Number = -(rotation / 180) * Math.PI;
			--ai_shootreload;
			if (ai_shootreload <= 0 && ai_shootready)
			{
				var shotOffsetY:Number = -25;
				var shotOffsetX:Number = 25;
				
				var realShotOffsetX:Number = Math.sin(rotRad) * shotOffsetY;
				var realShotOffsetY:Number = Math.cos(rotRad) * shotOffsetY;
				if (shootLeft)
				{
					realShotOffsetX += Math.sin(rotRad + (Math.PI / 2)) * shotOffsetX;
					realShotOffsetY += Math.cos(rotRad + (Math.PI / 2)) * shotOffsetX;
				}
				else
				{
					realShotOffsetX += Math.sin(rotRad - (Math.PI / 2)) * shotOffsetX;
					realShotOffsetY += Math.cos(rotRad - (Math.PI / 2)) * shotOffsetX;
				}
				shootLeft = !shootLeft;
				
				var realShotOriginX:Number = x + realShotOffsetX;
				var realShotOriginY:Number = y + realShotOffsetY;
				
				ai_shootreload = 25 + (Math.random() * 15);
				shootLaserFunc(realShotOriginX, realShotOriginY, rotation, 2);
			}
		}
		
		public override function Explode(createExplosionFunc:Function):void
		{
			createExplosionFunc(x, y, 1);
			active = false;
		}
		
		public override function Die():void
		{
			active = false;
		}
		
		public override function Respawn():void
		{
			health = fullhealth;
			x = 0;
			y = 0;
			active = true;
			visible = true;
			noclip = false;
			hit1.alpha = 0;
			hit2.alpha = 0;
			xvel = 0;
			yvel = 0;
			rotation = Math.random() * 360;
			rotvel = 0;
		}
		
		private function setThrustDir(dir:int, which:Bitmap):void
		{
			switch (dir)
			{
				case 0:
					which.x = 20 - which.bitmapData.width / 4;
					which.y = 12;
					which.rotation = 0;
					break;
				case 1:
					which.x = -20 - which.bitmapData.width / 4;
					which.y = 12;
					which.rotation = 0;
					break;
				case 2:
					which.x = 13;
					which.y = 7;
					which.rotation = 270;
					which.alpha = 0;
					break;
				case 3:
					which.x = -7 - which.bitmapData.width / 4;
					which.y = 23;
					which.rotation = 32;
					which.alpha = 0;
					break;
				case 4:
					which.x = 8 - which.bitmapData.width / 4;
					which.y = 27;
					which.rotation = -35;
					which.alpha = 0;
					break;
			}
		}
	}
}