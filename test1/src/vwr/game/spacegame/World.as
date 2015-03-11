package vwr.game.spacegame 
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import vwr.game.spacegame.worldstuff.entities.*;
	import vwr.game.spacegame.worldstuff.Entity;
	import vwr.game.spacegame.worldstuff.Room;
	import vwr.game.spacegame.worldstuff.Tile;
	import vwr.game.spacegame.worldstuff.rooms.*;
	
	/**
	 * ...
	 * @author Victor Reynolds
	 */
	public class World extends Sprite 
	{
		private var sequenceNumber:Number;
		private var player:Player;
		private var enemy:Enemy;
		private var camera:Camera;
		private var cursor:Cursor;
		private var followPoint:Point;
		private var currentRoom:Room;
		private var roomList:Array;
		private var activeEntityList:Array;
		private var tilesTouching:Array;
		private var shotArray:Array;
		
		private var maxx:Number;
		private var maxy:Number;
		private var minx:Number;
		private var miny:Number;
		
		public function World() 
		{
			super();
			sequenceNumber = 0;
			
			roomList = new Array();
			currentRoom = new TestRoom3();
			cursor = new Cursor();
			roomList.push(currentRoom);
			addChild(currentRoom);
			addChild(cursor);
			
			maxx = currentRoom.startx + currentRoom.roomWidth;
			maxy = currentRoom.starty + currentRoom.roomHeight;
			minx = currentRoom.startx;
			miny = currentRoom.starty;
			
			activeEntityList = new Array();
			player = new Player();

			camera = new Camera();
			followPoint = new Point();
			addChild(player);
			addChild(camera);
			activeEntityList.push(player);
			activeEntityList.push(camera);
			player.x = 320;//currentRoom.startx + (currentRoom.roomWidth) / 2;
			player.y = 200;// currentRoom.starty + (currentRoom.roomHeight) / 2;
			
			//player.showhitbox = true;
			camera.x = player.x;
			camera.y = player.y;
			
			player.x -= 20;
			player.y += 100
			player.xvel = 10;
			player.yvel = 10;
			
			shotArray = new Array();
			for (var i:int = 0; i < 30; ++i)
			{
				var newshot:Shot = new Shot();
				activeEntityList.push(newshot);
				addChild(newshot);
				shotArray.push(newshot);
			}
		}
		
		public function Update():void
		{
			++sequenceNumber;
			
			while (currentRoom.highlightStore.numChildren > 0)
			{
				currentRoom.highlightStore.removeChildAt(0);
			}
			
			//spawn pending entities
			while (currentRoom.numToSpawn > 0)
			{
				var toAdd:Entity = currentRoom.SpawnPendingEntity();
				addChild(toAdd);
				activeEntityList.push(toAdd);
			}
			
			//update all entities
			for each(var ent:Entity in activeEntityList)
			{
				if (ent is Enemy)
				{
					(ent as Enemy).SetTarget(player.x, player.y);
				}
				ent.Update();
				if (ent.noclip == false)
				{
					//Collider with other ents
					for each (var othent:Entity in activeEntityList)
					{
						if (othent is Shot && ent is Enemy)
						{
							if ((othent as Shot).IsActive())
							if (othent.x > ent.x - ent.hitwidth / 2 && othent.x < ent.x + ent.hitwidth / 2
								&& othent.y > ent.y - ent.hitheight / 2 && othent.y < ent.y + ent.hitheight / 2)
							{
								(othent as Shot).DoHit();
								ent.x = (Math.random() * 3280) - 1000;
								ent.y = (Math.random() * 2800) - 1000;
							}
						}
					}
					
					//Confine to room
					ent.Confine(minx, miny, maxx, maxy);
					ent.CollideTiles(currentRoom);
				}
			}
			
			//Shooting lasers :D
			if (player.MouseDown())
			{
				if (sequenceNumber % 4 == 1)
				{
					var playerRotRad:Number = -(player.rotation / 180) * Math.PI;
					
					var shotOffsetY:Number = -25;
					var shotOffsetX:Number = 33;
					
					var realShotOffsetX:Number = Math.sin(playerRotRad) * shotOffsetY;
					var realShotOffsetY:Number = Math.cos(playerRotRad) * shotOffsetY;
					if (sequenceNumber % 8 == 1)
					{
						realShotOffsetX += Math.sin(playerRotRad + (Math.PI / 2)) * shotOffsetX;
						realShotOffsetY += Math.cos(playerRotRad + (Math.PI / 2)) * shotOffsetX;
					}
					else
					{
						realShotOffsetX += Math.sin(playerRotRad - (Math.PI / 2)) * shotOffsetX;
						realShotOffsetY += Math.cos(playerRotRad - (Math.PI / 2)) * shotOffsetX;
					}
					
					var realShotOriginX:Number = player.x + realShotOffsetX;
					var realShotOriginY:Number = player.y + realShotOffsetY;
					
					var shotOriginToCrosshairRotation:Number = ((Math.atan2(realShotOriginY - cursor.y, realShotOriginX - cursor.x) / Math.PI) * 180) - 90;
					
					for (var i:int = 0; i < shotArray.length; ++i)
					{
						if ((shotArray[i] as Shot).Shoot(realShotOriginX, realShotOriginY, shotOriginToCrosshairRotation))
						{
							(shotArray[i] as Shot).Update();
							break;
						}
					}
				}
			}
			else
			{
				sequenceNumber = 0;
			}
			
			
			followPoint.x = (cursor.x + (player.x * 2)) / 3;
			followPoint.y = (cursor.y + (player.y * 2)) / 3;
			camera.xvel = (followPoint.x - camera.x) / 8;
			camera.yvel = (followPoint.y - camera.y) / 6;
			camera.zoom = 1 - Math.min((Math.pow((player.x - cursor.x) / (stage.stageWidth / stage.stageHeight), 2) + Math.pow(player.y - cursor.y, 2)) / 1500000, 0.125);
			scaleX = scaleY = camera.zoom;
			x = (Main.gameWidth / 2) - (camera.x * camera.zoom);
			y = (Main.gameHeight / 2) - (camera.y * camera.zoom);
			
			cursor.x = mouseX;
			cursor.y = mouseY;
			
			cursor.Update();
			player.AimAt(cursor.x, cursor.y);
			
			currentRoom.UpdateBG(camera);
			currentRoom.Update();
		}
	}

}