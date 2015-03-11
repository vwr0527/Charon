package vwr.game.spacegame.worldstuff.entities 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
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
		
		[Embed(source = "/../../sprite/thrust01.png")]
		private var thrust1pic:Class;
		private var t1:Bitmap;
		private var t2:Bitmap;
		private var t3:Bitmap;
		private var t4:Bitmap;
		
		[Embed(source = "/../../sprite/shieldhit3.png")]
		private var shieldpic:Class;
		private var shieldbmp:Bitmap;
		[Embed(source = "/../../sprite/shieldhit4.png")]
		private var hitpic:Class;
		private var hitbmp:Bitmap;
		[Embed(source = "/../../sprite/shieldripple.png")]
		private var ripplepic:Class;
		private var ripplebmp:Bitmap;
		
		private var shieldSprite:Sprite;
		private var shieldbubble:Sprite;
		private var hitAnim:Sprite;
		private var rippleAnim:Sprite;
		
		private var speed:Number = 0.3;
		private var counter:int = 0;
		private var isShooting:Boolean = false;
		private var shootLeft:Boolean = false;
		private var refireRate:int = 5;
		private var shield:int = 25;
		private var shieldBroke:int = 0;
		private var maxshield:int = 25;
		private var armor:int = 20;
		private var maxarmor:int = 20;
		private var shieldRechargeTime:int = 100; // time after shield broke to begin recharging.
		private var shieldRechargeRate:int = 10; // every this number of frames, add back 1 to shield
		private var shieldRechargeCounter:int = 0;
		private var shieldHitAnim:int = 0;
		private var shotFromDir:Number = 0;
		private var shieldDamageTaken:Number = 0;
		
		public function Player() 
		{
			super();
			var pic:Bitmap = new picture();
			pic.smoothing = true;
			pic.bitmapData.threshold(pic.bitmapData, pic.bitmapData.rect, new Point(0, 0), "==", 0xffff00ff); //turn pink into transparent
			pic.scaleX = 0.5;
			pic.scaleY = 0.5;
			pic.x = -pic.bitmapData.width / 4;
			pic.y = -pic.bitmapData.height / 4;
			pic.alpha = 1.0;
			addChildAt(pic, 0);
			
			t1 = new thrust1pic();
			t1.smoothing = true;
			t1.scaleX = 1;
			t1.scaleY = 1;
			t1.x = -t1.bitmapData.width / 2;
			t1.y = 22;// -t1.bitmapData.height / 4;
			t1.alpha = 1.0;
			addChildAt(t1, 0);
			
			t2 = new thrust1pic();
			t2.smoothing = true;
			t2.scaleX = 0.5;
			t2.scaleY = 1;
			t2.rotation = 90;
			t2.x -= t2.width / 2;
			t2.y -= t2.height / 2;
			t2.alpha = 1.0;
			addChildAt(t2, 2);
			
			t3 = new thrust1pic();
			t3.smoothing = true;
			t3.scaleX = 0.5;
			t3.scaleY = 1;
			t3.rotation = 180;
			t3.y -= t3.height / 2;
			t3.x += t3.width / 2;
			t3.alpha = 1.0;
			addChildAt(t3, 0);
			
			t4 = new thrust1pic();
			t4.smoothing = true;
			t4.scaleX = 0.5;
			t4.scaleY = 1;
			t4.rotation = 270;
			t4.x += t4.width / 2;
			t4.y += t4.height / 2;
			t4.alpha = 1.0;
			addChildAt(t4, 4);
			
			shieldbmp = new shieldpic();
			shieldbmp.bitmapData.colorTransform(shieldbmp.bitmapData.rect, new ColorTransform(2.0, 1.3, 1.5, 1, -255, 0, 0, 0));
			hitbmp = new hitpic();
			hitbmp.bitmapData.colorTransform(hitbmp.bitmapData.rect, new ColorTransform(2.0, 1.3, 1.5, 1, -255, 0, 0, 0));
			ripplebmp = new ripplepic();
			ripplebmp.bitmapData.colorTransform(ripplebmp.bitmapData.rect, new ColorTransform(2.0, 1.3, 1.5, 2, -255, 0, 0, 0));
			shieldbmp.x -= shieldbmp.width / 2;
			shieldbmp.y -= shieldbmp.height / 2;
			hitbmp.scaleX = 1.7;
			hitbmp.scaleY = 1.5;
			hitbmp.x -= hitbmp.width / 2;
			hitbmp.y -= hitbmp.height / 2;
			hitbmp.y -= 20;
			ripplebmp.scaleX = 2;
			ripplebmp.scaleY = 3;
			ripplebmp.x -= ripplebmp.width / 2;
			ripplebmp.y -= ripplebmp.height / 2;
			ripplebmp.alpha = 1;
			hitbmp.alpha = 1;
			
			hitAnim = new Sprite();
			hitAnim.addChild(hitbmp);
			
			rippleAnim = new Sprite();
			rippleAnim.addChild(ripplebmp);
			
			shieldbubble = new Sprite();
			shieldbubble.addChild(shieldbmp);
			
			shieldSprite = new Sprite();
			shieldSprite.addChild(shieldbubble);
			shieldSprite.addChild(hitAnim);
			shieldSprite.addChild(rippleAnim);
			shieldSprite.scaleX = 1.5;
			shieldSprite.scaleY = 1.4;
			shieldSprite.y -= 5;
			addChild(shieldSprite);
			
			//showhitbox = true;
			hitwidth = 30;
			hitheight = 30;
			noclip = false;
			
			friction = 0.98;
        }
		
		public function AimAt(xpos:Number, ypos:Number):void
		{
			var targetRotation:Number = ((180 / Math.PI) * Math.atan2(ypos - y, xpos - x)) + 90;
			if (targetRotation >= 180) targetRotation -= 360;
			var deltaRotation:Number = targetRotation - rotation;
			if (deltaRotation > 180) deltaRotation -= 360;
			if (deltaRotation < -180) deltaRotation += 360;
			if (deltaRotation > 30) deltaRotation = 30;
			if (deltaRotation < -30) deltaRotation = -30;
			rotvel = deltaRotation / 3;
		}
		
		private var moveDiag:Boolean = false;
		
		public override function Update():void
		{
			var diagSpeed:Number = speed * 0.707;
			moveDiag = false;
			
			if (!(Input.moveDown() == 1 && Input.moveUp() == 1))
			{
				if (Input.moveLeft() == 1 && !Input.moveRight() == 1)
				{
					if (Input.moveDown() == 1)
					{
						xvel -= diagSpeed;
						yvel += diagSpeed;
						moveDiag = true;
					}
					else if (Input.moveUp() == 1)
					{
						xvel -= diagSpeed;
						yvel -= diagSpeed;
						moveDiag = true;
					}
				}
				else if (Input.moveRight() == 1 && !Input.moveLeft() == 1)
				{
					if (Input.moveDown() == 1)
					{
						xvel += diagSpeed;
						yvel += diagSpeed;
						moveDiag = true;
					}
					else if (Input.moveUp() == 1)
					{
						xvel += diagSpeed;
						yvel -= diagSpeed;
						moveDiag = true;
					}
				}
			}
			
			if (!moveDiag)
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
			
			if (Input.mouseButton() == 1)
			{
				isShooting = true;
			}
			else
			{
				isShooting = false;
			}
			
			HandleThrustAnimation();
			HandleShieldAnimation();
			
			if (shieldBroke >= 1)
			{
				shieldBroke++;
				if (shieldBroke >= shieldRechargeTime)
				{
					shieldBroke = 0;
				}
			}
			if (shieldBroke == 0)
			{
				if (shield < maxshield)
				{
					shieldRechargeCounter ++;
					if (shieldRechargeCounter > shieldRechargeRate)
					{
						shield ++;
						shieldRechargeCounter = 0;
					}
				}
			}
			
			super.Update();
		}
		
		private function HandleShieldAnimation():void 
		{
			shieldbubble.rotation = Math.random() * 360;
			shieldbubble.alpha += shieldDamageTaken / 4;
			shieldbubble.alpha *= 0.9;
			if (shieldBroke == 1)
			{
				shieldbubble.scaleX = shieldbubble.scaleY = 1.2;
				shieldbubble.alpha = 2;
			}
			else if (shieldBroke > 1)
			{
				shieldbubble.alpha = 0;
				shieldbubble.scaleX = shieldbubble.scaleY = 1;
			}
			if (shieldBroke == 0 && shield < maxshield && shieldRechargeCounter >= 0)
			{
				shieldbubble.alpha = 0.1 + ((shield / maxshield) * 0.2);
			}
			if (shieldHitAnim >= 1)
			{
				if (shieldHitAnim == 1)
				{
					rippleAnim.alpha = 0.9;
					hitAnim.alpha = 2.4;
					hitbmp.x = ( -hitbmp.width / 2) + (Math.random() - 0.5) * 5;
					hitbmp.y = -20 + ( -hitbmp.height / 2) + (Math.random() - 0.5) * 5;
				}
				hitAnim.alpha *= 0.7;
				rippleAnim.alpha *= 0.8;
				hitAnim.rotation = -rotation + shotFromDir;
				ripplebmp.y = (shieldHitAnim * 5) - 40;
				rippleAnim.rotation = -rotation + shotFromDir;
				++ shieldHitAnim;
				if (shieldHitAnim > 5) shieldHitAnim = 0;
			}
			else
			{
				rippleAnim.alpha = 0;
				hitAnim.alpha = 0;
			}
			shieldDamageTaken = 0;
		}
		
		public function HandleShooting(ShootLaserFunc:Function, cursorX:Number, cursorY:Number):void 
		{
			//Shooting lasers :D
			if (isShooting)
			{
				if (counter % refireRate == 0)
				{
					var playerRotRad:Number = -(rotation / 180) * Math.PI;
					
					var shotOffsetY:Number = -25;
					var shotOffsetX:Number = 33;
					
					var realShotOffsetX:Number = Math.sin(playerRotRad) * shotOffsetY;
					var realShotOffsetY:Number = Math.cos(playerRotRad) * shotOffsetY;
					if (shootLeft)
					{
						realShotOffsetX += Math.sin(playerRotRad + (Math.PI / 2)) * shotOffsetX;
						realShotOffsetY += Math.cos(playerRotRad + (Math.PI / 2)) * shotOffsetX;
					}
					else
					{
						realShotOffsetX += Math.sin(playerRotRad - (Math.PI / 2)) * shotOffsetX;
						realShotOffsetY += Math.cos(playerRotRad - (Math.PI / 2)) * shotOffsetX;
					}
					shootLeft = !shootLeft;
					
					var realShotOriginX:Number = x + realShotOffsetX;
					var realShotOriginY:Number = y + realShotOffsetY;
					
					var shotOriginToCrosshairRotation:Number = ((Math.atan2(realShotOriginY - cursorY, realShotOriginX - cursorX) / Math.PI) * 180) - 90;
					
					ShootLaserFunc(realShotOriginX, realShotOriginY, shotOriginToCrosshairRotation);
				}
				++counter;
			}
			else
			{
				counter = 0;
			}
		}
		
		public function GetHit(eshot:Shot):void 
		{
			rotation += (Math.random() - 0.5) * 10.0;
			xvel += (eshot.x - eshot.px) * 0.03;
			yvel += (eshot.y - eshot.py) * 0.03;
			if (shield > 0)
			{
				shield -= eshot.GetDamage();
				shieldDamageTaken = eshot.GetDamage();
				shieldBroke = 0;
				shieldRechargeCounter = -shieldRechargeTime;
				shieldHitAnim = 1;
				shotFromDir = (((180 / Math.PI) * Math.atan2(y - eshot.y, x - eshot.x)) - 90);
			}
			else
			{
				armor -= eshot.GetDamage();
				if (shieldBroke == 0)
				{
					shieldBroke = 1;
				}
				else if (shieldBroke > 2)
				{
					shieldBroke = 2;
				}
				shieldRechargeCounter = -shieldRechargeTime;
			}
		}
		
		private var thrustleft:Number = 0;
		private var thrustright:Number = 0;
		private var thrustup:Number = 0;
		private var thrustdown:Number = 0;
		
		private function HandleThrustAnimation():void 
		{
			var thrustPlumeMult:Number = 0.125;
			var thrustDieDown:Number = 0.85;
			var thrustAlphaMult:Number = 1.5;
			var thrustMinLength:Number = 0.2;
			var thrustRandomLength:Number = 0.2;
		
			var thrustDir:Number = Math.atan2((Input.moveDown() - Input.moveUp()), (Input.moveRight() - Input.moveLeft()));
			thrustDir -= (rotation / 180) * Math.PI;
			var thrustAmt:Number = Math.min(Math.abs(Input.moveDown() - Input.moveUp()) + Math.abs(Input.moveRight() - Input.moveLeft()) , 1);
			var thrustRealPlumeMult:Number = thrustPlumeMult * thrustAmt;
			
			thrustup += -Math.sin(thrustDir) * thrustRealPlumeMult;
			thrustright += Math.cos(thrustDir) * thrustRealPlumeMult;
			thrustdown += Math.sin(thrustDir) * thrustRealPlumeMult;
			thrustleft += -Math.cos(thrustDir) * thrustRealPlumeMult;
			
			thrustup *= thrustDieDown;
			thrustright *= thrustDieDown;
			thrustdown *= thrustDieDown;
			thrustleft *= thrustDieDown;
			
			t1.alpha = thrustup * thrustAlphaMult;
			t2.alpha = thrustright * thrustAlphaMult;
			t3.alpha = thrustdown * thrustAlphaMult;
			t4.alpha = thrustleft * thrustAlphaMult;
			
			t1.scaleY = Math.max(thrustMinLength, thrustup) + (Math.random() * thrustRandomLength);
			t2.scaleY = Math.max(thrustMinLength, thrustright) + (Math.random() * thrustRandomLength);
			t3.scaleY = Math.max(thrustMinLength, thrustdown) + (Math.random() * thrustRandomLength);
			t4.scaleY = Math.max(thrustMinLength, thrustleft) + (Math.random() * thrustRandomLength);
		}
	}
}