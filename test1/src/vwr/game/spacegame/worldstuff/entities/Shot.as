package vwr.game.spacegame.worldstuff.entities 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import vwr.game.spacegame.worldstuff.Entity;
	import vwr.game.spacegame.Input;
	import vwr.game.spacegame.worldstuff.Room;
	import vwr.game.spacegame.worldstuff.Tile;
	
	/**
	 * ...
	 * @author Victor Reynolds
	 */
	public class Shot extends Entity 
	{
		private var controlEnabled:Boolean = true;
		
		[Embed(source = "/../../sprite/shot01.png")]
		private var picture:Class;
		[Embed(source = "/../../sprite/hit01.png")]
		private var hitpic:Class;
		
		private var speed:Number = 30;
		private var impact:int = 5; // 0 = traveling, 1 or more is frames after hit
		private var counter:int = 0;
		private var laserSize:Number = 0.65;
		private var laserLengthFactor:Number = 0.035;
		private var impactSize:Number = 0.75;
		private var slope:Number = 0;
		private var intercept:Number = 0;
		
		public function Shot() 
		{
			super();
			var pic:Bitmap = new picture();
			pic.smoothing = true;
			pic.bitmapData.threshold(pic.bitmapData, pic.bitmapData.rect, new Point(0, 0), "==", 0xffff00ff);
			pic.bitmapData.colorTransform(pic.bitmapData.rect, new ColorTransform(1, 2, 2, 1, 50, -255, -255, 0));
			
			pic.scaleX = laserSize;
			pic.scaleY = laserSize * speed * laserLengthFactor;
			pic.x = -(pic.bitmapData.width / 2) * laserSize;
			pic.y = -((pic.bitmapData.height * speed * laserLengthFactor) / 4) * laserSize;
			
			pic.alpha = 1.0;
			addChildAt(pic, 0);
			
			//impact pic
			var pic2:Bitmap = new hitpic();
			pic2.smoothing = true;
			pic2.bitmapData.threshold(pic2.bitmapData, pic2.bitmapData.rect, new Point(0, 0), "==", 0xffff00ff);
			pic2.bitmapData.colorTransform(pic2.bitmapData.rect, new ColorTransform(1.2, 1.2, 1.2, 1, 0, -50, -50, 0));
			
			pic2.scaleX = impactSize;
			pic2.scaleY = impactSize;
			pic2.x = -(pic2.bitmapData.width / 2) * impactSize;
			pic2.y = -(pic2.bitmapData.height / 2) * impactSize;
			
			pic2.alpha = 1.0;
			addChildAt(pic2, 1);
			
			//showhitbox = true;
			hitwidth = 1;
			hitheight = 1;
			noclip = false;
			
			friction = 1;
			elasticity = 0.0;
			
			//enableHighlightTiles = true;
        }
		
		public override function Confine(minx:Number, miny:Number, maxx:Number, maxy:Number):void
		{
			if (x > maxx)
			{
				DoHit();
			}
			if (y > maxy)
			{
				DoHit();
			}
			if (x  < minx)
			{
				DoHit();
			}
			if (y < miny)
			{
				DoHit();
			}
		}
		
		public override function CollideTiles(currentRoom:Room):void
		{
			//if currently not a real laser projectile, do nothing
			if (impact != 0) return;
			
			//if no tiles, do nothing
			if (currentRoom.tileGrid.length == 0) return;
			/*
			//if outside of tileGrid's bounds, do nothing
			//TODO: Take into account corner cutting
			if ((this.y < 0
			|| this.x < 0
			|| this.y > (currentRoom.numRows * currentRoom.tileHeight)
			|| this.x > (currentRoom.numCols * currentRoom.tileWidth))
			&&
			(this.py < 0
			|| this.px < 0
			|| this.py > (currentRoom.numRows * currentRoom.tileHeight)
			|| this.px > (currentRoom.numCols * currentRoom.tileWidth)))
			{
				return;
			}*/
			
			//line collision
			var sxi:int = 0; //start x index
			var syi:int = 0;
			var exi:int = 0; //end x index
			var eyi:int = 0;
			
			sxi = Math.floor(px / currentRoom.tileWidth) as int;
			syi = Math.floor(py / currentRoom.tileHeight) as int;
			
			exi = Math.floor(x / currentRoom.tileWidth) as int;
			eyi = Math.floor(y / currentRoom.tileHeight) as int;
			
			if (sxi < currentRoom.numCols && syi < currentRoom.numRows && sxi >= 0 && syi >= 0)
			{
				if (enableHighlightTiles) currentRoom.HighlightTile(sxi, syi);
				HitTile(currentRoom.tileGrid[syi][sxi]);
			}
			
			var next_y_intercept:Number = 0
			if (sxi > exi)
			{
				next_y_intercept = ((currentRoom.tileWidth * sxi) * slope) + intercept;
			}
			else if (sxi < exi)
			{
				next_y_intercept = ((currentRoom.tileWidth * (sxi + 1)) * slope) + intercept;
			}
			
			var tyi:int = 0; //target y index - the y index of the y position of the next intercept
			tyi = Math.floor(next_y_intercept / currentRoom.tileHeight) as int;
			if ((syi == eyi) || !((syi <= tyi && tyi <= eyi) || (eyi <= tyi && tyi <= syi)))
			{
				tyi = eyi;
			}
			
			var emergencyBrakes:int = 0; //prevent infinite loop. probably will never need.
			
			//for cxi,cyi (current tile x,y index) not equal to exi,eyi (end tile x,y index)
			for (var cxi:int = sxi, cyi:int = syi; !(cxi == exi && cyi == eyi); )
			{
				//find out why it's looping too long
				if (emergencyBrakes > 100)
				{
					trace("emergency brakes applied");
					break;
				}
				emergencyBrakes ++;
				
				//the case where the end index is directly above or below you
				//or the there's a new target y index
				if (cxi == exi || cyi != tyi)
				{
					if (cyi < eyi)
					{
						cyi ++;
					}
					else
					{
						cyi --;
					}
				}
				else
				{
					if (cxi > exi)
					{
						cxi --;
						next_y_intercept = ((currentRoom.tileWidth * cxi) * slope) + intercept;
					}
					else
					{
						cxi ++;
						next_y_intercept = ((currentRoom.tileWidth * (cxi + 1)) * slope) + intercept;
					}
					tyi = Math.floor(next_y_intercept / currentRoom.tileHeight) as int;
					if ((cyi == eyi) || !((cyi <= tyi && tyi <= eyi) || (eyi <= tyi && tyi <= cyi)))
					{
						tyi = eyi;
					}
				}
				
				if (cxi >= currentRoom.numCols || cyi >= currentRoom.numRows || cxi < 0 || cyi < 0)
				{
					continue; //add thing that checks if the ship has sailed, if so, break;
				}
				else
				{
					if (enableHighlightTiles) currentRoom.HighlightTile(cxi, cyi);
					HitTile(currentRoom.tileGrid[cyi][cxi]);
				}
			}
		}
		
		protected override function HitTile(tile:Tile):void
		{
			if (tile == null || tile.noclip)
			{
				return;
			}
			/*if (tile is DiagTile)
			{
				HitDiagTile(tile as DiagTile);
				return;
			}*/
			
			HitSquare(tile.x, tile.y, tile.x + tile.width, tile.y + tile.height);
		}
		
		//returns true or false. let world handle it.
		public function HitEnt(ent:Entity):Boolean
		{
			if (ent == null || ent.noclip == true || impact > 1 || this.noclip == true)
			{
				return false;
			}
			
			var minx:Number = ent.x - (ent.hitwidth / 2);
			var miny:Number = ent.y - (ent.hitheight / 2);
			var maxx:Number = ent.x + (ent.hitwidth / 2);
			var maxy:Number = ent.y + (ent.hitheight / 2);
			
			if (DidIntersectSquare(minx, miny, maxx, maxy))
			{
				HitSquare(minx, miny, maxx, maxy);
				return true;
			}
			else
			{
				return false;
			}
		}
		
		//this only checks if x -> px intersects a specified square. It doesn't change anything.
		protected function DidIntersectSquare(minx:Number, miny:Number, maxx:Number, maxy:Number):Boolean 
		{
			var lineIntersectRect:Boolean = false;
			
			var x_inside:Boolean = x > minx && x < maxx;
			var y_inside:Boolean = y > miny && y < maxy;
			
			if (x_inside && y_inside) lineIntersectRect = true;
			
			var px_inside:Boolean = px > minx && px < maxx;
			var py_inside:Boolean = py > miny && py < maxy;
			
			if (px_inside && py_inside) lineIntersectRect = true;
			
			if (lineIntersectRect == false)
			{
				if (slope == Number.MAX_VALUE)
				{
					if (intercept >= minx && intercept <= maxx)
					{
						if (y_inside || py_inside ||
							(y > maxy && py < miny) ||
							(py > maxy && y < miny))
						{
							lineIntersectRect = true;
						}
					}
				}
				else
				{
					if ((x_inside || px_inside ||
						(px < minx && x > maxx) ||
						(x < minx && px > maxx))
						&&
						(y_inside || py_inside ||
						(py < miny && y > maxy) ||
						(y < miny && py > maxy)))
					{
						var y1:Number = minx * slope + intercept;
						var y2:Number = maxx * slope + intercept;
						
						if ((y1 > miny && y1 < maxy) ||
							(y2 > miny && y2 < maxy) ||
							(y1 < miny && y2 > maxy) ||
							(y2 < miny && y1 > maxy))
						{
							lineIntersectRect = true;
						}
					}
				}
			}
			
			return lineIntersectRect;
		}
		
		//it will only get here if collidetiles determines that it was within the tile
		//therefore, it doesn't check if it is actually intersecting the square.
		protected function HitSquare(xmin:Number, ymin:Number, xmax:Number, ymax:Number):void
		{
			//y-intercept = newx newy, and x-intercept = newx2 newy2
			var new_x:Number = 0;
			var new_y:Number = 0;
			var new_x2:Number = 0;
			var new_y2:Number = 0;
			if (x > px)
			{
				new_y = (slope * xmin) + intercept;
				new_x = xmin;
			}
			else
			{
				new_y = (slope * xmax) + intercept;
				new_x = xmax;
			}
			
			if (slope != 0)
			{
				if (y > py)
				{
					new_x2 = (ymin - intercept) / slope;
					new_y2 = ymin;
				}
				else
				{
					new_x2 = (ymax - intercept) / slope;
					new_y2 = ymax;
				}
			}
			else
			{
				new_x2 = x;
				if (y > py)
				{
					new_y2 = ymin;
				}
				else
				{
					new_y2 = ymax;
				}
			}
			
			var cur_delta:Number = Math.abs(x - px) + Math.abs(y - py);
			var new_delta:Number = Number.MAX_VALUE;  //if the next part fails, then these are essentially discounted.
			var new2_delta:Number = Number.MAX_VALUE;
			
			//verify that it is actually on the tile wall
			if (new_y > ymin && new_y < ymax)
			{
				new_delta = Math.abs(new_x - px) + Math.abs(new_y - py);
			}
			if (new_x2 > xmin && new_x2 < xmax)
			{
				new2_delta = Math.abs(new_x2 - px) + Math.abs(new_y2 - py);
			}
			
			//see which is smallest
			//x, y should = smallest distance
			if (new_delta < cur_delta)
			{
				if (new2_delta < cur_delta)
				{
					x = new_x2;
					y = new_y2;
				}
				else
				{
					x = new_x;
					y = new_y;
				}
			}
			else if (new2_delta < cur_delta)
			{
				x = new_x2;
				y = new_y2;
			}
			
			DoHit();
		}
		
		public function DoHit():void
		{
			if (impact != 0) return;
			impact = 1;
			counter = 0;
			xvel = 0;
			yvel = 0;
			
			getChildAt(0).alpha = 0;
			getChildAt(1).alpha = 1;
			rotation = Math.random() * 360;
			scaleX = scaleY = 2.2;
		}
		
		public override function Update():void
		{
			++counter;
			//counter 1 is for muzzle flash, counter 2 is for extra distance before leaving barrel
			if (impact == 0)
			{
				if (counter == 1)
				{
					//borrowing rotfric as a holder for previous rotation
					rotfric = rotation;
					rotation = Math.random() * 360;
					return;
				}
				if (counter > 1)
				{
					if (counter == 2)
					{
						rotation = rotfric;
						//x -= xvel / 4;
						//y -= yvel / 4;
					}
					var pic:Bitmap = getChildAt(0) as Bitmap;
					
					pic.alpha = 1;
					getChildAt(1).alpha = 0;
					scaleX = scaleY = 1.0;
					
					if (friction != 1)
					{
						var realSpeed:Number = Math.sqrt(Math.pow(xvel, 2) + Math.pow(yvel, 2));
						
						pic.scaleX = laserSize;
						pic.scaleY = laserSize * realSpeed * laserLengthFactor;
						pic.x = -(pic.bitmapData.width / 2) * laserSize;
						pic.y = -((pic.bitmapData.height * realSpeed * laserLengthFactor) / 4) * laserSize;
						
						if (realSpeed < 0.1) impact = 5;
					}
				}
			}
			if (impact > 0 && impact <= 4)
			{
				getChildAt(0).alpha = 0;
				getChildAt(1).alpha = ((3 - impact) + 2) * 0.25;
				rotation = Math.random() * 360;
				scaleX = scaleY = (4 - impact) * 1.0;
				++impact;
			}
			if (impact == 5)
			{
				getChildAt(0).alpha = 0;
				getChildAt(1).alpha = 0;
			}
			super.Update();
			if (counter > 100 && impact == 0) DoHit();
		}
		
		//if the bullet is ready to be shot, it will shoot it and return true
		//if it's not ready, it returns false
		public function Shoot(xpos:Number, ypos:Number, dir:Number):Boolean
		{
			if (impact == 5)
			{
				x = xpos;
				y = ypos;
				px = xpos;
				py = ypos;
				var raddir:Number = (dir / 180) * Math.PI;
				xvel = -Math.sin(-raddir) * speed;
				yvel = -Math.cos(raddir) * speed;
				if (xvel != 0)
				{
					slope = yvel / xvel;
					intercept = y - (slope * x);
				}
				else
				{
					slope = Number.MAX_VALUE;
					intercept = xpos;
				}
				rotation = dir;
				impact = 0;
				counter = 0;
				getChildAt(0).alpha = 0;
				getChildAt(1).alpha = 1;
				scaleX = scaleY = 2;
				return true;
			}
			return false;
		}
		
		public function IsActive():Boolean
		{
			return impact == 0;
		}
		
		public function GetDamage():Number
		{
			return 4;
		}
	}
}