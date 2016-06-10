package vwr.game.spacegame 
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import vwr.game.spacegame.worldstuff.entities.*;
	import vwr.game.spacegame.worldstuff.entities.explosions.*;
	import vwr.game.spacegame.worldstuff.entities.shots.Laser;
	import vwr.game.spacegame.worldstuff.entities.shots.Plasma;
	import vwr.game.spacegame.worldstuff.entities.shots.SlowRedLaser;
	import vwr.game.spacegame.worldstuff.Entity;
	import vwr.game.spacegame.worldstuff.Room;
	import vwr.game.spacegame.worldstuff.Tile;
	import vwr.game.spacegame.worldstuff.rooms.*;
	import vwr.game.spacegame.worldstuff.LevelEditor;
	
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
		private var entityList:Array;
		private var tilesTouching:Array;
		private var shotList:Array;
		private var enemyShotList:Array;
		private var enemyList:Array;
		private var explosionList:Array;
		
		private var maxx:Number;
		private var maxy:Number;
		private var minx:Number;
		private var miny:Number;
		
		private var infotext:TextField;
		private var textContainer:Sprite;
		private var showDebugText:Boolean = false;
		
		private var roomNum:int = 2;
		
		private var lvlEdit:LevelEditor;
		
		public function World() 
		{
			super();
			sequenceNumber = 0;
			
			roomList = new Array();
			LoadAllRooms();
			
			cursor = new Cursor();
			addChild(cursor);
			
			entityList = new Array();
			shotList = new Array();
			enemyList = new Array();
			explosionList = new Array();
			enemyShotList = new Array();
			
			player = new Player();
			camera = new Camera();
			addChild(player);
			addChild(camera);			
			entityList.push(player);
			entityList.push(camera);
			
			LoadRoom(roomNum);
			
			if (currentRoom != null)
			{
				player.x = currentRoom.startx + (currentRoom.roomWidth) / 2;
				player.y = currentRoom.starty + (currentRoom.roomHeight) / 2;
			}
			camera.x = player.x;
			camera.y = player.y;
			
			infotext = new TextField();
			infotext.textColor = 0xFFFFAA;
			var fmt:TextFormat = new TextFormat();
			fmt.font = "System";
			infotext.defaultTextFormat = fmt;
			textContainer = new Sprite();
			textContainer.addChild(infotext);
			infotext.x += 20;
			infotext.y += 10;
			textContainer.scaleX = 2;
			textContainer.scaleY = 2;
			addChild(textContainer);
			infotext.text = "000";
			
			lvlEdit = new LevelEditor();
		}
		
		public function Update():void
		{
			if (Input.lbrac() == 2)
			{
				++roomNum;
				if (roomNum > 3)
				{
					roomNum = 0;
				}
				LoadRoom(roomNum);
			}
			if (Input.rbrac() == 2)
			{
				--roomNum;
				if (roomNum < 0)
				{
					roomNum = 3;
				}
				LoadRoom(roomNum);
			}
			if (Input.p() == 2)
			{
				lvlEdit.active = !lvlEdit.active;
			}
			
			++sequenceNumber;
			
			currentRoom.ResetHighlight();
			
			if (lvlEdit.active)
			{
				lvlEdit.Update(camera, currentRoom, cursor);
			}
			else
			{
				
				//spawn pending entities
				while (currentRoom.numToSpawn > 0)
				{
					var toAdd:Entity = currentRoom.SpawnPendingEntity();
					addChild(toAdd);
					entityList.push(toAdd);
					if (toAdd is Enemy) enemyList.push(toAdd);
				}
				
				//update all entities
				for each(var ent:Entity in entityList)
				{
					if (!ent.IsActive())
					{
						if (ent.parent != null) removeChild(ent);
						continue;
					}
					ent.Update();
					if (ent.noclip == false)
					{
						ent.Confine(minx, miny, maxx, maxy);
						ent.CollideTiles(currentRoom);
					}
				}
				
				//shots check if hit enemies
				for each(var shot:Shot in shotList)
				{
					if (!shot.IsActive()) continue;
					
					for each(enemy in enemyList)
					{
						if (!enemy.IsActive()) continue;
						if (shot.HitEnt(enemy))
						{
							enemy.GetHit(shot);
							if (!enemy.IsActive())
							{
								enemy.Explode(CreateExplosion);
							}
							break;
						}
					}
				}
				
				//enemy shots check if hit player
				for each(var eshot:Shot in enemyShotList)
				{
					if (!eshot.IsActive()) continue;
					if (eshot.HitEnt(player))
						player.GetHit(eshot);
				}
				
				for each(var expl:Explosion in explosionList)
				{
					if (!expl.IsActive() && expl.parent != null)
					{
						removeChild(expl);
						continue;
					}
					expl.Update();
				}
				
				for each(var enemy:Enemy in enemyList)
				{
					if (enemy.IsActive())
					{
						enemy.SetTarget(player.x, player.y);
						enemy.HandleShooting(ShootEnemyLaser);
					}
				}
				
				player.HandleShooting(ShootLaser, cursor.x, cursor.y);
				
				camera.ReceivePositions(player.x, player.y, cursor.x, cursor.y);
				
				player.AimAt(cursor.x, cursor.y);
				currentRoom.Update();
			}
			
			infotext.visible = showDebugText;
			if (showDebugText)
			{
				setChildIndex(textContainer, numChildren - 1);
				infotext.text = "entities: " + entityList.length + "\nenemies: " + enemyList.length + "\nshots: " + shotList.length + "\nenemy shots: " + enemyShotList.length + "\nexplosions: " + explosionList.length;
				textContainer.x = (-x / scaleX) - (scaleX * 25);
				textContainer.y = ( -y / scaleX) - (scaleX * 16);
			}
			
			scaleX = scaleY = camera.zoom;
			x = (Main.gameWidth / 2) - (camera.x * camera.zoom);
			y = (Main.gameHeight / 2) - (camera.y * camera.zoom);
			
			cursor.x = mouseX;
			cursor.y = mouseY;
			cursor.Update();
			
			currentRoom.UpdateBG(camera);
		}
		
		private function LoadAllRooms():void
		{
			roomList.push(new TestRoom1());
			roomList.push(new TestRoom2());
			roomList.push(new TestRoom3());
			roomList.push(new TestRoom4());
		}
		
		private function LoadRoom(roomId:int):void
		{
			if (currentRoom != null && currentRoom.parent != null)
			{
				removeChild(currentRoom);
			}
			
			currentRoom = roomList[roomId];
			maxx = currentRoom.startx + currentRoom.roomWidth;
			maxy = currentRoom.starty + currentRoom.roomHeight;
			minx = currentRoom.startx;
			miny = currentRoom.starty;
			
			addChildAt(currentRoom, 0);
		}
		
		private function ShootLaser(xpos:Number, ypos:Number, dir:Number):void
		{
			CreateShotHelper(xpos, ypos, dir, 1, shotList);
		}
		
		private function ShootEnemyLaser(xpos:Number, ypos:Number, dir:Number, type:int):void
		{
			CreateShotHelper(xpos, ypos, dir, type, enemyShotList);
		}
		
		private function CreateShotHelper(xpos:Number, ypos:Number, dir:Number, type:int, whichArray:Array):void
		{
			for (var i:int = 0; i < whichArray.length; ++i)
			{
				if ((whichArray[i] as Shot).GetType() != type) continue;
				if ((whichArray[i] as Shot).Shoot(xpos,ypos,dir))
				{
					
					(whichArray[i] as Shot).Update();
					(whichArray[i] as Shot).CollideTiles(currentRoom);
					addChild((whichArray[i] as Shot));
					return;
				}
			}
			//must have failed to find any empty shots
			var newShot:Shot;
			switch (type)
			{
				case 1:
					newShot = new Laser();
					break;
				case 2:
					newShot = new Plasma();
					break;
				case 3:
					newShot = new SlowRedLaser();
					break;
				default:
					trace("error, no such shot type");
					return;
			}
			whichArray.push(newShot);
			addChild(newShot);
			entityList.push(newShot);
			
			newShot.Shoot(xpos, ypos, dir);
			newShot.Update();
			newShot.CollideTiles(currentRoom);
		}
		
		private function CreateExplosion(x:Number, y:Number, size:int):void
		{
			for (var i:int = 0; i < explosionList.length; ++i)
			{
				if (explosionList[i].ExplodeAt(x, y))
				{
					explosionList[i].SetExplosionSize(size);
					addChild(explosionList[i]);
					return;
				}
			}
			//must have failed to find any empty explosions			
			var newexplosion:Explosion = new Explosion();
			addChild(newexplosion);
			explosionList.push(newexplosion);
			
			newexplosion.ExplodeAt(x, y);
			newexplosion.SetExplosionSize(size);
		}
	}
}