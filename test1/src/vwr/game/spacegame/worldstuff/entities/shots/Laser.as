package vwr.game.spacegame.worldstuff.entities.shots 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import vwr.game.spacegame.worldstuff.DiagTile;
	import vwr.game.spacegame.worldstuff.entities.Shot;
	import vwr.game.spacegame.worldstuff.Entity;
	import vwr.game.spacegame.Input;
	import vwr.game.spacegame.worldstuff.Room;
	import vwr.game.spacegame.worldstuff.Tile;
	
	/**
	 * ...
	 * @author Victor Reynolds
	 */
	public class Laser extends Shot 
	{
		[Embed(source = "/../../sprite/shot01.png")]
		protected var picture:Class;
		protected var pic:Bitmap;
		[Embed(source = "/../../sprite/hit01.png")]
		protected var hitpic:Class;
		protected var pic2:Bitmap;
		
		protected var speed:Number = 30;
		protected var damage:Number = 4;
		
		protected var impact:int = 5; // 0 = traveling, 1 or more is frames after hit
		protected var counter:int = 0;
		protected var laserSize:Number = 0.65;
		protected var laserLengthFactor:Number = 0.035;
		protected var impactSize:Number = 0.75;
		protected var slope:Number = 0;
		protected var intercept:Number = 0;
		
		public function Laser() 
		{
			super();
			pic = new picture();
			pic.smoothing = false;
			pic.bitmapData.colorTransform(pic.bitmapData.rect, new ColorTransform(1, 2, 2, 1, 50, -255, -255, 0));
			
			pic.scaleX = laserSize;
			pic.scaleY = laserSize * speed * laserLengthFactor;
			pic.x = -(pic.bitmapData.width / 2) * laserSize;
			pic.y = -((pic.bitmapData.height * speed * laserLengthFactor) / 4) * laserSize;
			
			pic.alpha = 1.0;
			addChildAt(pic, 0);
			
			//impact pic
			pic2 = new hitpic();
			pic2.smoothing = false;
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
			if (tile is DiagTile)
			{
				HitDiagTile(tile as DiagTile);
				return;
			}
			
			HitSquare(tile.x, tile.y, tile.x + tile.width, tile.y + tile.height);
		}
		
		//returns true or false. don't modify ent. let world handle it.
		public override function HitEnt(ent:Entity):Boolean
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
				//we know it must have at least hit something this far away.
				//it may have hit something closer, but it's correct to modify its coordinates.
				HitSquare(minx, miny, maxx, maxy);
				return true;
			}
			else
			{
				return false;
			}
		}
		
		//this only checks if x -> px intersects a specified square. It doesn't change anything.
		protected override function DidIntersectSquare(minx:Number, miny:Number, maxx:Number, maxy:Number):Boolean 
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
		protected override function HitSquare(xmin:Number, ymin:Number, xmax:Number, ymax:Number):void
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
		
		
		protected override function HitDiagTile(tile:DiagTile):void 
		{
			var xmin:Number = tile.x;
			var ymin:Number = tile.y;
			var xmax:Number = tile.x + tile.width;
			var ymax:Number = tile.y + tile.height;
			
			if (tile.dir == 1)
			{
				// __
				// \|
				
				if (yvel > 0)
				{
					var xatwall:Number = (ymin - intercept) / slope;
					if (y > ymin && (xatwall > xmin && xatwall < xmax))
					{
						if (py < ymin)
						{
							x = xatwall;
							y = ymin;
							DoHit();
							return;
						}
						else if ((px - py) > (xmin - ymin))
						{
							DoHit();
							return;
						}
					}
				}
				if (xvel < 0)
				{
					var yatwall:Number = (slope * xmax) + intercept;
					if (x < xmax && (yatwall > ymin && yatwall < ymax))
					{
						if (px > xmax)
						{
							x = xmax;
							y = yatwall;
							DoHit();
							return;
						}
						else if ((px - py) > (xmin - ymin))
						{
							DoHit();
							return;
						}
					}
				}
				if (line_line(px, x, xmin, xmax, py, y, ymin, ymax))
				{
					if ((x - y) > (x_intersect - y_intersect))
					{
						x = x_intersect;
						y = y_intersect;
						if (x > xmax) x = xmax;
						if (x < xmin) x = xmin;
						if (y > ymax) y = ymax;
						if (y < ymin) y = ymin;
						DoHit();
						return;
					}
				}
			}
			else if (tile.dir == 0)
			{
				// __
				// |/
				
				if (yvel > 0)
				{
					xatwall = (ymin - intercept) / slope;
					if (y > ymin && (xatwall > xmin && xatwall < xmax))
					{
						if (py < ymin)
						{
							x = xatwall;
							y = ymin;
							DoHit();
							return;
						}
						else if ((px + py) < (xmin + ymax))
						{
							DoHit();
							return;
						}
					}
				}
				if (xvel > 0)
				{
					yatwall = (slope * xmin) + intercept;
					if (x > xmin && (yatwall > ymin && yatwall < ymax))
					{
						if (px < ymin)
						{
							x = xmin;
							y = yatwall;
							DoHit();
							return;
						}
						else if ((px + py) < (xmin + ymax))
						{
							DoHit();
							return;
						}
					}
				}
				if (line_line(px, x, xmin, xmax, py, y, ymax, ymin))
				{
					if ((x + y) < (x_intersect + y_intersect))
					{
						x = x_intersect;
						y = y_intersect;
						if (x > xmax) x = xmax;
						if (x < xmin) x = xmin;
						if (y > ymax) y = ymax;
						if (y < ymin) y = ymin;
						DoHit();
						return;
					}
				}
			}
			else if (tile.dir == 3)
			{
				// |\
				// --
				
				if (yvel < 0)
				{
					xatwall = (ymax - intercept) / slope;
					if (y < ymax && (xatwall > xmin && xatwall < xmax))
					{
						if (py > ymax)
						{
							x = xatwall;
							y = ymax;
							DoHit();
							return;
						}
						else if ((px - py) < (xmin - ymin))
						{
							DoHit();
							return;
						}
					}
				}
				if (xvel > 0)
				{
					yatwall = (slope * xmin) + intercept;
					if (x > xmin && (yatwall > ymin && yatwall < ymax))
					{
						if (px < xmin)
						{
							x = xmin;
							y = yatwall;
							DoHit();
							return;
						}
						else if ((px - py) < (xmin - ymin))
						{
							DoHit();
							return;
						}
					}
				}
				if (line_line(px, x, xmin, xmax, py, y, ymin, ymax))
				{
					if ((x - y) < (x_intersect - y_intersect))
					{
						x = x_intersect;
						y = y_intersect;
						if (x > xmax) x = xmax;
						if (x < xmin) x = xmin;
						if (y > ymax) y = ymax;
						if (y < ymin) y = ymin;
						DoHit();
						return;
					}
				}
			}
			else if (tile.dir == 2)
			{
				// /|
				// --
				
				if (yvel < 0)
				{
					xatwall = (ymax - intercept) / slope;
					if (y < ymax && (xatwall > xmin && xatwall < xmax))
					{
						if (py > ymax)
						{
							x = xatwall;
							y = ymax;
							DoHit();
							return;
						}
						else if ((px + py) > (xmin + ymax))
						{
							DoHit();
							return;
						}
					}
				}
				if (xvel < 0)
				{
					yatwall = (slope * xmax) + intercept;
					if (x < xmax && (yatwall > ymin && yatwall < ymax))
					{
						if (px > xmax)
						{
							x = xmax;
							y = yatwall;
							DoHit();
							return;
						}
						else if ((px + py) > (xmin + ymax))
						{
							DoHit();
							return;
						}
					}
				}
				if (line_line(px, x, xmin, xmax, py, y, ymax, ymin))
				{
					if ((x + y) > (x_intersect + y_intersect))
					{
						x = x_intersect;
						y = y_intersect;
						if (x > xmax) x = xmax;
						if (x < xmin) x = xmin;
						if (y > ymax) y = ymax;
						if (y < ymin) y = ymin;
						DoHit();
						return;
					}
				}
			}
		}
		
		public override function DoHit():void
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
		public override function Shoot(xpos:Number, ypos:Number, dir:Number):Boolean
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
		
		public override function IsActive():Boolean
		{
			return impact != 5;
		}
		
		public override function GetDamage():Number
		{
			return damage;
		}
		
		public override function GetType():int
		{
			return 1;
		}

		private var x_intersect:Number;
		private var y_intersect:Number;
		
		private function line_line(x1:Number, x2:Number, x3:Number, x4:Number, y1:Number, y2:Number, y3:Number, y4:Number):Boolean
		{
			var x12:Number = x1 - x2;
			var x34:Number = x3 - x4;
			var y12:Number = y1 - y2;
			var y34:Number = y3 - y4;
			var c:Number = x12 * y34 - y12 * x34;
			if (fabs(c) < 0.0001)
			{
				// No intersection
				return false;
			}
			else
			{
				// Intersection
				var a:Number = x1 * y2 - y1 * x2;
				var b:Number = x3 * y4 - y3 * x4;
				x_intersect = (a * x34 - b * x12) / c;
				y_intersect = (a * y34 - b * y12) / c;
				return true;
			}
		}
		
		private function fabs(num:Number):Number
		{
			if (num < 0) return -num;
			else return num;
		}
	}
}