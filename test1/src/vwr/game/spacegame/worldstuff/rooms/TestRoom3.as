package vwr.game.spacegame.worldstuff.rooms 
{
	import vwr.game.spacegame.worldstuff.BgPlane;
	import vwr.game.spacegame.worldstuff.entities.Enemy;
	import vwr.game.spacegame.worldstuff.Entity;
	import vwr.game.spacegame.worldstuff.Room;
	import vwr.game.spacegame.worldstuff.Tile;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import vwr.game.spacegame.worldstuff.tiles.*;
	import vwr.game.spacegame.worldstuff.BgObject;
	
	/**
	 * ...
	 * @author Victor Reynolds
	 */
	public class TestRoom3 extends Room 
	{
		[Embed(source = "/../../sprite/starfield-1.jpg")]  //get permission for this.
		private var picture:Class;
		
		[Embed(source = "/../../sprite/spacerock-1.png")]
		private var asteroidpic:Class;
		
		[Embed(source = "/../../sprite/planet-1.png")]
		private var planetpic:Class;
		
		[Embed(source = "/../../sprite/tech01.jpg")] //get permission for this. http://www.spiralforums.biz/index.php?showtopic=11022
		private var wall:Class;
		
		[Embed(source = "/../../sprite/bg_blur_dark.png")]
		private var back:Class;
		
		private var layout:Array = [
		[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 4, 4, 4, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		[0, 8, 1, 9, 0, 0, 0, 0, 0, 0, 0, 1, 4, 3, 3, 3, 1, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 1],
		[0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 4, 0, 0, 3, 1, 3, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 3, 3, 4, 1],
		[0, 7, 1, 6, 0, 0, 0, 0, 1, 1, 4, 1, 4, 0, 0, 3, 1, 3, 0, 0, 0, 0, 0, 0, 0, 1, 3, 0, 0, 3, 4, 1],
		[0, 0, 4, 0, 0, 0, 0, 0, 1, 1, 4, 1, 4, 0, 0, 3, 1, 3, 0, 0, 0, 0, 0, 0, 0, 1, 3, 0, 0, 3, 4, 1],
		[0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 1, 4, 0, 0, 3, 3, 3, 0, 0, 0, 0, 0, 0, 0, 1, 3, 0, 0, 3, 4, 1],
		[0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 1, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 3, 3, 3, 3, 4, 1],
		[0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 1, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 3, 3, 4, 1],
		[1, 9, 4, 0, 0, 0, 0, 0, 0, 0, 8, 1, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1],
		[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 1],
		[4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 1, 4, 0, 0, 0, 0, 3, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 1],
		[4, 3, 3, 3, 4, 4, 3, 3, 3, 3, 4, 1, 4, 0, 0, 0, 0, 3, 1, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 1],
		[4, 3, 3, 3, 4, 4, 0, 0, 0, 0, 4, 1, 4, 0, 0, 0, 0, 3, 1, 1, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 1],
		[4, 4, 4, 4, 4, 4, 0, 0, 0, 0, 4, 1, 4, 0, 0, 0, 0, 0, 7, 1, 1, 9, 0, 0, 0, 0, 0, 0, 0, 0, 4, 1],
		[1, 1, 1, 1, 1, 4, 0, 0, 0, 0, 4, 1, 4, 0, 0, 0, 0, 0, 0, 7, 1, 1, 9, 0, 0, 0, 0, 0, 0, 0, 4, 1],
		[1, 6, 0, 0, 1, 4, 0, 0, 0, 0, 4, 1, 4, 0, 0, 0, 0, 0, 0, 0, 7, 1, 1, 9, 0, 0, 0, 0, 0, 0, 4, 1],
		[0, 0, 0, 0, 1, 4, 0, 0, 0, 0, 4, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 7, 1, 1, 3, 0, 0, 0, 0, 0, 4, 1],
		[0, 0, 0, 0, 1, 4, 3, 3, 3, 3, 4, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 3, 3, 3, 0, 0, 0, 0, 4, 1],
		[0, 0, 0, 0, 1, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 1],
		[0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
		];
		
		
		public function TestRoom3() 
		{
			super();
			
			bg = new picture();
			bg.smoothing = true;
			bgScale = 1;
			addChildAt(bg, 0);
			parralax = 1.0;
			
			numRows = 20;
			numCols = 32;
			tileWidth = 40;
			tileHeight = 40;
			roomWidth = 3280;
			roomHeight = 2800;
			startx = -1000;
			starty = -1000;
			
			var rock:Bitmap = new asteroidpic();
			rock.smoothing = true;
			rock.bitmapData.threshold(rock.bitmapData, rock.bitmapData.rect, new Point(0, 0), "==", 0xffff00ff);
			var bgRockObj:BgObject = new BgObject(rock);
			bgRockObj.parralax = 0.5;
			addChild(bgRockObj);
			bgRockObj.offset.x = -80;
			bgRockObj.offset.y = -50;
			bgObjs.push(bgRockObj);
			
			var pp:Bitmap = new planetpic();
			pp.smoothing = true;
			var bgPlanetObj:BgObject = new BgObject(pp);
			bgPlanetObj.scaleX = 2;
			bgPlanetObj.scaleY = 2;
			bgPlanetObj.parralax = 0.99;
			addChildAt(bgPlanetObj, 1);
			bgPlanetObj.offset.x = 45000;
			bgPlanetObj.offset.y = 5000;
			bgObjs.push(bgPlanetObj);
			
			var wp:Bitmap = new wall();
			wp.smoothing = true;
			wp = BgPlane.AlterBitmap(wp, 512, 512, false, null, 0.5, 1,0,0);
			var wallBg:BgPlane = new BgPlane(wp);
			addChildAt(wallBg, 2);
			wallBg.offset.x = -3000;
			wallBg.offset.y = 800;
			wallBg.parralax = 0.8;
			wallBg.offset2.x = 4280;
			wallBg.offset2.y = 800;
			wallBg.parralax2 = 0.8;
			wallBg.offset3.x = -3000;
			wallBg.offset3.y = 2200;
			wallBg.parralax3 = -1
			wallBg.offset4.x = 4280;
			wallBg.offset4.y = 2200;
			wallBg.parralax4 = -1
			bgObjs.push(wallBg);
			
			var strip:Bitmap = new wall();
			strip.smoothing = true;
			strip = BgPlane.AlterBitmap(strip, 512, 256, false, null, 0.5, 1,0,0);
			var stBg:BgPlane = new BgPlane(strip);
			addChildAt(stBg, 2);
			stBg.offset.x = -3000;
			stBg.offset.y = 800;
			stBg.parralax = 0.9;
			stBg.offset2.x = 4280;
			stBg.offset2.y = 800;
			stBg.parralax2 = 0.9;
			stBg.offset3.x = -3000;
			stBg.offset3.y = 800;
			stBg.parralax3 = 0.8;
			stBg.offset4.x = 4280;
			stBg.offset4.y = 800;
			stBg.parralax4 = 0.8;
			bgObjs.push(stBg);
			
			var bb:Bitmap = new back();
			bb = BgPlane.AlterBitmap(bb, 256, 256, false, null, 1.5, 1, -.25);
			bb.smoothing = true;
			var backDrop:BgObject = new BgObject(bb);
			addChild(backDrop);
			backDrop.pic.width = 760;
			backDrop.pic.height = 720;
			backDrop.offset.x = 860;
			backDrop.offset.y = 400;
			bgObjs.push(backDrop);
			backDrop.parralax = 0.05;
			
			ConstructRoom(layout);
			
			numToSpawn = 20;
		}
		
		public override function Update():void
		{
			super.Update();
			bgObjs[0].rotation += 0.1;
		}
		
		public override function SpawnPendingEntity():Entity
		{
			var badguy:Enemy = new Enemy();
			badguy.xvel = Math.random() * 10;
			badguy.yvel = Math.random() * 10;
			
			super.SpawnPendingEntity();
			return badguy;
		}
	}

}