package vwr.game.spacegame 
{
	import flash.display.Sprite;
	import vwr.game.spacegame.worldstuff.entities.*;
	import vwr.game.spacegame.worldstuff.Entity;
	import vwr.game.spacegame.worldstuff.Room;
	import vwr.game.spacegame.worldstuff.rooms.TestRoom1;
	
	/**
	 * ...
	 * @author Victor Reynolds
	 */
	public class World extends Sprite 
	{
		private var sequenceNumber:Number;
		private var player:Player;
		private var camera:Camera;
		private var currentRoom:Room;
		private var roomList:Array;
		private var activeEntityList:Array;
		
		private var maxx:Number;
		private var maxy:Number;
		private var minx:Number;
		private var miny:Number;
		
		private var elasticity:Number = 0.7;
		
		public function World() 
		{
			super();
			sequenceNumber = 0;
			
			roomList = new Array();
			currentRoom = new TestRoom1();
			roomList.push(currentRoom);
			addChild(currentRoom);
			
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
			
			
			//section
			//update all entities
			for each(var ent:Entity in activeEntityList)
			{
				ent.Update();
				//section
				//Confine to room
				if (ent.x > maxx)
				{
					ent.x = maxx;
					ent.xvel *= -elasticity;
				}
				if (ent.y > maxy)
				{
					ent.y = maxy;
					ent.yvel *= -elasticity;
				}
				if (ent.x < minx)
				{
					ent.x = minx;
					ent.xvel *= -elasticity;
				}
				if (ent.y < miny)
				{
					ent.y = miny;
					ent.yvel *= -elasticity;
				}
			}
			
			camera.xvel = (player.x - camera.x) / 10;
			camera.yvel = (player.y - camera.y) / 10;
			x = (stage.stageWidth / 2) - camera.x;
			y = (stage.stageHeight / 2) - camera.y;
		}
	}

}