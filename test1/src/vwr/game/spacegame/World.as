package vwr.game.spacegame 
{
	import flash.display.Sprite;
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
		private var camera:Camera;
		private var cursor:Cursor;
		private var currentRoom:Room;
		private var roomList:Array;
		private var activeEntityList:Array;
		private var tilesTouching:Array;
		
		private var maxx:Number;
		private var maxy:Number;
		private var minx:Number;
		private var miny:Number;
		
		public function World() 
		{
			super();
			sequenceNumber = 0;
			
			roomList = new Array();
			currentRoom = new TestRoom2();
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
			player.x = 320;
			player.y = 200;
			camera.x = 320;
			camera.y = 200;
		}
		
		public function Update():void
		{
			++sequenceNumber;
			
			currentRoom.Update();
			
			//section
			//update all entities
			for each(var ent:Entity in activeEntityList)
			{
				ent.Update();
				if (ent.noclip == false)
				{
					//section
					//Confine to room
					ent.Confine(minx, miny, maxx, maxy);
					ent.CollideTiles(currentRoom);
				}
			}
			
			camera.xvel = (player.x - camera.x) / 10;
			camera.yvel = (player.y - camera.y) / 10;
			x = (stage.stageWidth / 2) - camera.x;
			y = (stage.stageHeight / 2) - camera.y;
			
			currentRoom.bg.x = -x * 0.5;
			currentRoom.bg.y = -y * 0.5;
			currentRoom.bg.x -= currentRoom.bg.width / 10;
			currentRoom.bg.y -= currentRoom.bg.height / 10;
			
			cursor.x = mouseX;
			cursor.y = mouseY;
			
			cursor.Update();
			player.AimAt(cursor.x, cursor.y);
		}
	}

}