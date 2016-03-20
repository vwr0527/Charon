package vwr.game.spacegame 
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import vwr.game.spacegame.worldstuff.entities.*;
	import vwr.game.spacegame.worldstuff.entities.explosions.*;
	import vwr.game.spacegame.worldstuff.entities.shots.Laser;
	import vwr.game.spacegame.worldstuff.entities.shots.Plasma;
	import vwr.game.spacegame.worldstuff.entities.shots.SlowRedLaser;
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
		
		public function World() 
		{
			super();
			sequenceNumber = 0;
			
			roomList = new Array();
			currentRoom = new TestRoom3();//        <----------  Level the game starts on
			cursor = new Cursor();
			roomList.push(currentRoom);
			addChild(currentRoom);
			addChild(cursor);
			
			maxx = currentRoom.startx + currentRoom.roomWidth;
			maxy = currentRoom.starty + currentRoom.roomHeight;
			minx = currentRoom.startx;
			miny = currentRoom.starty;
			
			entityList = new Array();
			
			player = new Player();
			camera = new Camera();
			addChild(player);
			addChild(camera);			
			entityList.push(player);
			entityList.push(camera);
			player.x = currentRoom.startx + (currentRoom.roomWidth) / 2;
			player.y = currentRoom.starty + (currentRoom.roomHeight) / 2;
			
			//player.showhitbox = true;
			camera.x = player.x;
			camera.y = player.y;
			
			shotList = new Array();
			enemyList = new Array();
			explosionList = new Array();
			enemyShotList = new Array();
		}
		
		public function Update():void
		{
			++sequenceNumber;
			
			currentRoom.ResetHighlight();
			
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
					//TODO: Collide with other ents
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
					if (shot.HitEnt(enemy))
					{
						enemy.GetHit(shot);
						if (!enemy.IsActive())
						{
							enemy.Explode(CreateExplosion);
							enemy.Respawn();
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
		
		private function ShootLaser(xpos:Number, ypos:Number, dir:Number):void
		{
			for (var i:int = 0; i < shotList.length; ++i)
			{
				if ((shotList[i] as Shot).Shoot(xpos,ypos,dir))
				{
					(shotList[i] as Shot).Update();
					(shotList[i] as Shot).CollideTiles(currentRoom);
					break;
				}
			}
			//must have failed to find any empty player shots
			var newshot:Shot = new Laser();
			entityList.push(newshot);
			addChild(newshot);
			shotList.push(newshot);
			
			newshot.Shoot(xpos, ypos, dir);
			newshot.Update();
			newshot.CollideTiles(currentRoom);
		}
		
		private function ShootEnemyLaser(xpos:Number, ypos:Number, dir:Number, type:int):void
		{
			for (var i:int = 0; i < enemyShotList.length; ++i)
			{
				if ((enemyShotList[i] as Shot).GetType() != type) continue;
				if ((enemyShotList[i] as Shot).Shoot(xpos,ypos,dir))
				{
					(enemyShotList[i] as Shot).Update();
					(enemyShotList[i] as Shot).CollideTiles(currentRoom);
					return;
				}
			}
			//must have failed to find any empty enemy lasers
			var newEnmShot:Shot;
			switch (type)
			{
				case 2:
					newEnmShot = new Plasma();
					break;
				case 3:
					newEnmShot = new SlowRedLaser();
					break;
				default:
					trace("error, no such enemy shot type");
					return;
			}
			enemyShotList.push(newEnmShot);
			addChild(newEnmShot);
			entityList.push(newEnmShot);
			
			newEnmShot.Shoot(xpos, ypos, dir);
			newEnmShot.Update();
			newEnmShot.CollideTiles(currentRoom);
		}
		
		private function CreateExplosion(x:Number, y:Number, size:int):void
		{
			for (var i:int = 0; i < explosionList.length; ++i)
			{
				if (explosionList[i].ExplodeAt(x, y))
				{
					explosionList[i].SetExplosionSize(size);
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