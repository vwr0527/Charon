package vwr.game.spacegame.worldstuff 
{
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import com.zehfernando.display.drawPlane;
	import vwr.game.spacegame.Main;
	import vwr.game.spacegame.worldstuff.entities.Camera;
	/**
	 * ...
	 * @author Victor Reynolds
	 */
	public class BgPlane extends BgObject 
	{
		public var parralax2:Number = 0.0;
		public var parralax3:Number = 0.0;
		public var parralax4:Number = 0.0;
		
		public var offset2:Point;
		public var offset3:Point;
		public var offset4:Point;
		
		private var p1:Point;
		private var p2:Point;
		private var p3:Point;
		private var p4:Point;
		
		public function BgPlane(picture:Bitmap)
		{
			super(picture);
			removeChildAt(0);
			parralax = 0.0;
			
			offset2 = new Point();
			offset3 = new Point();
			offset4 = new Point();
			
			p1 = new Point();
			p2 = new Point();
			p3 = new Point();
			p4 = new Point();
		}
		
		public override function Update(camera:Camera):void
		{
			calcPointPos(camera.x, camera.y, parralax, offset, p1);
			calcPointPos(camera.x, camera.y, parralax2, offset2, p2);
			calcPointPos(camera.x, camera.y, parralax3, offset3, p3);
			calcPointPos(camera.x, camera.y, parralax4, offset4, p4);
			
			drawPlane(this.graphics, pic.bitmapData, p1, p2, p3, p4);
		}
		
		private function calcPointPos(worldX:Number, worldY:Number, parra:Number, offset:Point, p:Point):void
		{
			//p.x = ((offset.x * (1 - parra)) - (worldX * parra)) + (Main.gameWidth / 2);
			//p.y = ((offset.y * (1 - parra)) - (worldY * parra)) + (Main.gameHeight / 2);
			
			p.x = ((1 - parra) * offset.x) + (worldX * parra);
			p.y = ((1 - parra) * offset.y) + (worldY * parra);
		}
		
		public static function AlterBitmap(bmp:Bitmap, newWidth:int = 0, newHeight:int = 0, transparency:Boolean = false, matrix:Matrix = null, scaleX:Number = 1, scaleY:Number = 1, startX:Number = 0, startY:Number = 0, rotation:Number = 0, repeating:Boolean = true):Bitmap
		{
			if (newWidth == 0) newWidth = bmp.width;
			if (newHeight == 0) newHeight = bmp.height;
			if (matrix == null)
			{
				matrix = new Matrix();
				matrix.scale(scaleX * newWidth / bmp.width, scaleY * newHeight / bmp.height);
				matrix.translate(startX * newWidth, startY * newHeight);
				matrix.rotate(rotation);
			}
			var container:Sprite = new Sprite();
			container.graphics.beginBitmapFill(bmp.bitmapData, matrix, repeating, true);
			container.graphics.lineTo(newWidth, 0);
			container.graphics.lineTo(newWidth, newHeight);
			container.graphics.lineTo(0, newHeight);
			container.graphics.lineTo(0, 0);
			container.graphics.endFill();
			var bmpData:BitmapData = new BitmapData(newWidth, newHeight, transparency, 0x00FFFFFF);
			bmpData.draw(container);
			var newBmp:Bitmap = new Bitmap(bmpData, bmp.pixelSnapping, bmp.smoothing);
			return newBmp;
		}
	}
}

/*
		public function BgPlane(picture:Bitmap, bitmapWidth:Number = 0, bitmapHeight:Number = 0, bitmapOffsetX:Number = 0, bitmapOffsetY:Number = 0, trapezoid:int = 0, trapezoidRatio:Number = 0)
		{
			super(picture);
			removeChildAt(0);
			parralax = 0.0;
			
			offset2 = new Point();
			offset3 = new Point();
			offset4 = new Point();
			
			p1 = new Point();
			p2 = new Point();
			p3 = new Point();
			p4 = new Point();
			
			if (bitmapWidth > 0 && bitmapHeight > 0)
			{
				bitmapWidth *= picture.width;
				bitmapHeight *= picture.height;
				trapezoidRatio /= 2;
				
				var _tile:BitmapData = picture.bitmapData;
				// container to draw tiles
				var _container:Sprite = new Sprite();
				
				var startpos:Matrix = new Matrix();
				startpos.translate(bitmapOffsetX * picture.width, bitmapOffsetY * picture.height);
				_container.graphics.beginBitmapFill(_tile, startpos);
				
				if (trapezoid == 1) //down
				{
					_container.graphics.lineTo(bitmapWidth, 0);
					_container.graphics.lineTo((bitmapWidth/2) + (bitmapWidth * trapezoidRatio), bitmapHeight);
					_container.graphics.lineTo((bitmapWidth / 2) - (bitmapWidth * trapezoidRatio), bitmapHeight);
					_container.graphics.lineTo(0, 0);
				}
				else if (trapezoid == 2) //left
				{
					_container.graphics.moveTo(bitmapWidth, 0);
					_container.graphics.lineTo(bitmapWidth, 0);
					_container.graphics.lineTo(bitmapWidth, bitmapHeight);
					_container.graphics.lineTo(0, (bitmapHeight/2) + (bitmapHeight * trapezoidRatio));
					_container.graphics.lineTo(0, (bitmapHeight/2) - (bitmapHeight * trapezoidRatio));
				}
				else if (trapezoid == 3) //up
				{
					_container.graphics.moveTo((bitmapWidth / 2) + (bitmapWidth * trapezoidRatio), 0);
					_container.graphics.lineTo((bitmapWidth / 2) + (bitmapWidth * trapezoidRatio), 0);
					_container.graphics.lineTo(bitmapWidth, bitmapHeight);
					_container.graphics.lineTo(0, bitmapHeight);
					_container.graphics.lineTo((bitmapWidth / 2) - (bitmapWidth * trapezoidRatio), 0);
				}
				else if (trapezoid == 4) //right
				{
					_container.graphics.moveTo(bitmapWidth, (bitmapHeight/2) - (bitmapHeight * trapezoidRatio));
					_container.graphics.lineTo(bitmapWidth, (bitmapHeight/2) - (bitmapHeight * trapezoidRatio));
					_container.graphics.lineTo(bitmapWidth, (bitmapHeight/2) + (bitmapHeight * trapezoidRatio));
					_container.graphics.lineTo(0, bitmapHeight);
					_container.graphics.lineTo(0, 0);
				}
				else
				{
					_container.graphics.drawRect(0, 0, bitmapWidth, bitmapHeight);
				}
				_container.graphics.endFill();
				
				var _newBitmapData:BitmapData = new BitmapData(bitmapWidth, bitmapHeight, true, 0x00FFFFFF);
				_newBitmapData.draw(_container)
				
				pic = new Bitmap(_newBitmapData);
				pic.smoothing = picture.smoothing;
			}
		}
		
		//testroom3 constructor
		
			var bb:Bitmap = new back();
			bb.smoothing = true;
			
			var backDrop:BgPlane = new BgPlane(bb,1,0.5,0,0,1,0);
			addChild(backDrop);
			backDrop.offset.x = 120;
			backDrop.offset.y = -200;
			backDrop.parralax = 0.0;
			backDrop.offset2.x = 960;
			backDrop.offset2.y = -200;
			backDrop.parralax2 = 0.0;
			backDrop.offset3.x = 120;
			backDrop.offset3.y = 200;
			backDrop.parralax3 = 0.1;
			backDrop.offset4.x = 960;
			backDrop.offset4.y = 200;
			backDrop.parralax4 = 0.1;
			bgObjs.push(backDrop);
			
			var backDrop2:BgPlane = new BgPlane(bb,0.5,1,-0.5,0,2,0);
			addChild(backDrop2);
			backDrop2.offset.x = 540;
			backDrop2.offset.y = -200;
			backDrop2.parralax = 0.1;
			backDrop2.offset2.x = 960;
			backDrop2.offset2.y = -200;
			backDrop2.parralax2 = 0.0;
			backDrop2.offset3.x = 540;
			backDrop2.offset3.y = 600;
			backDrop2.parralax3 = 0.1;
			backDrop2.offset4.x = 960;
			backDrop2.offset4.y = 600;
			backDrop2.parralax4 = 0.0;
			bgObjs.push(backDrop2);
			
			var backDrop3:BgPlane = new BgPlane(bb,1,0.5,0,-0.5,3,0);
			addChild(backDrop3);
			backDrop3.offset.x = 120;
			backDrop3.offset.y = 200;
			backDrop3.parralax = 0.1;
			backDrop3.offset2.x = 960;
			backDrop3.offset2.y = 200;
			backDrop3.parralax2 = 0.1;
			backDrop3.offset3.x = 120;
			backDrop3.offset3.y = 600;
			backDrop3.parralax3 = 0.0;
			backDrop3.offset4.x = 960;
			backDrop3.offset4.y = 600;
			backDrop3.parralax4 = 0.0;
			bgObjs.push(backDrop3);
			
			var backDrop4:BgPlane = new BgPlane(bb,0.5,1,0,0,4,0);
			addChild(backDrop4);
			backDrop4.offset.x = 120;
			backDrop4.offset.y = -200;
			backDrop4.parralax = 0.0;
			backDrop4.offset2.x = 540;
			backDrop4.offset2.y = -200;
			backDrop4.parralax2 = 0.1;
			backDrop4.offset3.x = 120;
			backDrop4.offset3.y = 600;
			backDrop4.parralax3 = 0.0;
			backDrop4.offset4.x = 540;
			backDrop4.offset4.y = 600;
			backDrop4.parralax4 = 0.1;
			bgObjs.push(backDrop4);
			
		*/