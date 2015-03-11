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
		private var shotList:Array;
		private var enemyList:Array;
		
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
			addChild(player);
			addChild(camera);
			activeEntityList.push(player);
			activeEntityList.push(camera);
			player.x = 320;//currentRoom.startx + (currentRoom.roomWidth) / 2;
			player.y = 200;// currentRoom.starty + (currentRoom.roomHeight) / 2;
			
			//player.showhitbox = true;
			camera.x = player.x;
			camera.y = player.y;
			
			player.x = -50;
			player.y = -50;
			player.xvel = 0;
			player.yvel = 0;
			
			shotList = new Array();
			for (var i:int = 0; i < 30; ++i)
			{
				var newshot:Shot = new Shot();
				if (i == 0) newshot.elasticity = 0.54321;
				activeEntityList.push(newshot);
				addChild(newshot);
				shotList.push(newshot);
			}
			
			enemyList = new Array();
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
				activeEntityList.push(toAdd);
				if (toAdd is Enemy) enemyList.push(toAdd);
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
					//==nothing here yet==
					//Confine to room
					ent.Confine(minx, miny, maxx, maxy);
					ent.CollideTiles(currentRoom);
				}
			}
			//shots check if hit enemies
			for each(var shot:Shot in shotList)
			{
				if (!shot.IsActive()) continue;
				
				var closestEnemy:Enemy = null;
				
				for each(var enm:Enemy in enemyList)
				{
					if (shot.HitEnt(enm)) closestEnemy = enm;
				}
				
				if (closestEnemy != null)
				{
					closestEnemy.x = 0;// (Math.random() * currentRoom.roomWidth) + currentRoom.startx;
					closestEnemy.y = 0;// (Math.random() * currentRoom.roomHeight) + currentRoom.starty;
				}
			}
			
			player.HandleShooting(ShootLaser, cursor.x, cursor.y);
			
			camera.LearnPositions(player.x, player.y, cursor.x, cursor.y);
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
		}
	}
}