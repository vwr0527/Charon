package vwr.game.spacegame.worldstuff.entities 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import vwr.game.spacegame.worldstuff.Entity;
	import vwr.game.spacegame.Input;
	
	/**
	 * ...
	 * 1. idea: Enemy that suicide explodes
	 * 
	 * @author Victor Reynolds
	 */
	public class Enemy extends Entity 
	{
		public function Enemy() 
		{
			super();
			
			//showhitbox = true;
			
			hitwidth = 30;
			hitheight = 30;
			noclip = false;
			
			friction = 0.94;
			elasticity = 0.5;
        }
		
		public function SetTarget(xpos:Number, ypos:Number):void
		{
		}
		
		public override function Update():void
		{
			super.Update();
		}
		
		public function GetHit(shot:Shot):void
		{
		}
		
		public function HandleShooting(shootLaserFunc:Function):void
		{
		}
		
		public function Explode(createExplosionFunc:Function):void
		{
		}
		
		public function Die():void
		{
		}
		
		public function Respawn():void
		{
		}
		
		private function setThrustDir(dir:int, which:Bitmap):void
		{
		}
	}
}