package vwr.game.spacegame.worldstuff 
{
	import adobe.utils.ProductManager;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Victor Reynolds
	 */
	public class Entity extends Sprite
	{
		public var xvel:Number = 0.0;
		public var yvel:Number = 0.0;
		protected var px:Number = 0.0;
		protected var py:Number = 0.0;
		public var hitwidth:Number = 0.0;
		public var hitheight:Number = 0.0;
		public var rotvel:Number = 0.0;
		public var friction:Number = 0.99;
		public var rotfric:Number = 0.99;
		public var elasticity:Number = 0.75;
		private var hitboxGraphic:Shape;
		public var noclip:Boolean = true;
		public var showhitbox:Boolean = false;
		private static const extraPush:Number = 0.1;
		
		public function Entity() 
		{
			super();
			hitboxGraphic = new Shape();
			hitboxGraphic.graphics.beginFill(0xff9922, 0.2);
			hitboxGraphic.graphics.lineStyle(1, 0x1188ff, 0.7);
			hitboxGraphic.graphics.drawRect( -5, -5, 10, 10);
			hitboxGraphic.graphics.endFill();
			hitboxGraphic.visible = false;
			addChild(hitboxGraphic);
		}
		
		public function Update():void
		{
			px = x;
			py = y;
			x += xvel;
			y += yvel;
			rotation += rotvel;
			xvel *= friction;
			yvel *= friction;
			rotvel *= rotfric;
			
			if (Math.abs(xvel) < 0.1) xvel = 0;
			if (Math.abs(yvel) < 0.1) yvel = 0;
			if (Math.abs(rotvel) < 0.1) rotvel = 0;
			
			hitboxGraphic.visible = showhitbox;
			if (showhitbox)
			{
				hitboxGraphic.rotation = 0;
				hitboxGraphic.width = hitwidth;
				hitboxGraphic.height = hitheight;
				hitboxGraphic.rotation = -rotation;
			}
		}
		
		public function Confine(minx:Number, miny:Number, maxx:Number, maxy:Number):void
		{
			var cwidth:Number = hitwidth / 2;
			var cheight:Number = hitheight / 2;
			if (x + cwidth > maxx)
			{
				x = maxx - cwidth;
				xvel *= -elasticity;
			}
			if (y + cheight > maxy)
			{
				y = maxy - cheight;
				yvel *= -elasticity;
			}
			if (x - cwidth  < minx)
			{
				x = minx + cwidth;
				xvel *= -elasticity;
			}
			if (y - cheight < miny)
			{
				y = miny + cheight;
				yvel *= -elasticity;
			}
		}
		
		public function CollideTiles(currentRoom:Room):void 
		{
			//if outside of tileGrid's bounds, do nothing
			if (this.y + this.hitheight / 2 < 0
			|| this.x + this.hitwidth / 2 < 0
			|| this.y - this.hitheight / 2 > (currentRoom.numRows * currentRoom.tileHeight)
			|| this.x - this.hitwidth / 2 > (currentRoom.numCols * currentRoom.tileWidth))
			{
				return;
			}
			
			//if no tiles, do nothing
			if (currentRoom.tileGrid.length == 0) return;
			
			//collide with tiles
			var left_index:int = currentRoom.getIndexAtPosX(this.x - this.hitwidth / 2);
			var right_index:int = currentRoom.getIndexAtPosX(this.x + this.hitwidth / 2);
			var top_index:int = currentRoom.getIndexAtPosY(this.y - this.hitheight / 2);
			var bottom_index:int = currentRoom.getIndexAtPosY(this.y + this.hitheight / 2);
			var closest_index_x:int = currentRoom.getIndexAtPosX(this.x);
			var closest_index_y:int = currentRoom.getIndexAtPosY(this.y);
			
			//choose tiles closest to the center first
			//create an expanding square, on each side choose an alternating tile left or right from the center
			
			//getting max_layers is as easy as getting the distance to the center of any edge, and adding 1 to it
			var max_layers:int = closest_index_x - left_index;
			if (closest_index_y - top_index > max_layers) max_layers = closest_index_y - top_index;
			if (bottom_index - closest_index_y > max_layers) max_layers = bottom_index - closest_index_y;
			if (right_index - closest_index_x > max_layers) max_layers = right_index - closest_index_x;
			max_layers += 1;
			
			//trace(max_layers);
			for (var layer:int = 0; layer < max_layers; ++layer)
			{
				if (layer == 0)
				{
					this.HitTile(currentRoom.tileGrid[closest_index_y][closest_index_x]);
					currentRoom.HighlightTile(closest_index_x, closest_index_y);
					continue;
				}
				
				//1 layer is a 3x3 square, 2 layers is a 5x5 square, etc...
				//for each edge, for layer 1, iterate 2x, layer 2: 4x, layer 3: 6x
				//final clockwise corner tile of each edge is left alone. It's the next edge's responsibility
				for (var i:int = 0; i < layer * 2; ++i)
				{
					var alternator:int = (((i % 2) * 2) - 1) * Math.ceil(i / 2);
					var dist_from_center:int = Math.ceil(layer / 2);
					var chosen_index_x:int = 0;
					var chosen_index_y:int = 0;
					//top
					chosen_index_x = closest_index_x + alternator;
					chosen_index_y = closest_index_y - dist_from_center;
					if (chosen_index_x <= right_index && chosen_index_x >= left_index && chosen_index_y <= bottom_index && chosen_index_y >= top_index)
					{
						this.HitTile(currentRoom.tileGrid[chosen_index_y][chosen_index_x]);
						currentRoom.HighlightTile(chosen_index_x, chosen_index_y);
					}
					//right
					chosen_index_x = closest_index_x + dist_from_center;
					chosen_index_y = closest_index_y + alternator;
					if (chosen_index_x <= right_index && chosen_index_x >= left_index && chosen_index_y <= bottom_index && chosen_index_y >= top_index)
					{
						this.HitTile(currentRoom.tileGrid[chosen_index_y][chosen_index_x]);
						currentRoom.HighlightTile(chosen_index_x, chosen_index_y);
					}
					//bottom
					chosen_index_x = closest_index_x - alternator;
					chosen_index_y = closest_index_y + dist_from_center;
					if (chosen_index_x <= right_index && chosen_index_x >= left_index && chosen_index_y <= bottom_index && chosen_index_y >= top_index)
					{
						this.HitTile(currentRoom.tileGrid[chosen_index_y][chosen_index_x]);
						currentRoom.HighlightTile(chosen_index_x, chosen_index_y);
					}
					//left
					chosen_index_x = closest_index_x - dist_from_center;
					chosen_index_y = closest_index_y - alternator;
					if (chosen_index_x <= right_index && chosen_index_x >= left_index && chosen_index_y <= bottom_index && chosen_index_y >= top_index)
					{
						this.HitTile(currentRoom.tileGrid[chosen_index_y][chosen_index_x]);
						currentRoom.HighlightTile(chosen_index_x, chosen_index_y);
					}
				}
			}
		}
		
		protected function HitTile(tile:Tile):void
		{
			if (tile == null) return;
			if (tile.noclip) return;
			if (tile is DiagTile)
			{
				HitDiagTile(tile as DiagTile);
				return;
			}
			
			var dx:Number = x - px;
			var dy:Number = y - py;
			
			var bottomhit:Boolean = (y + hitheight / 2) > tile.y && (y + hitheight / 2) < tile.y + tile.height;
			var tophit:Boolean = (y - hitheight / 2) > tile.y && (y - hitheight / 2) < tile.y + tile.height;
			var lefthit:Boolean = (x - hitwidth / 2) > tile.x && (x - hitwidth / 2) < tile.x + tile.width;
			var righthit:Boolean = (x + hitwidth / 2) > tile.x && (x + hitwidth / 2) < tile.x + tile.width;
			/*
			var pbottomhit:Boolean = (py + hitheight / 2) > tile.y + extraPush && (py + hitheight / 2) < tile.y + tile.height - extraPush;
			var ptophit:Boolean = (py - hitheight / 2) > tile.y + extraPush && (py - hitheight / 2) < tile.y + tile.height - extraPush;
			var plefthit:Boolean = (px - hitwidth / 2) > tile.x + extraPush && (px - hitwidth / 2) < tile.x + tile.width - extraPush;
			var prighthit:Boolean = (px + hitwidth / 2) > tile.x + extraPush && (px + hitwidth / 2) < tile.x + tile.width - extraPush;
			*/
			var pbottomhit:Boolean = (py + hitheight / 2) > tile.y && (py + hitheight / 2) < tile.y + tile.height;
			var ptophit:Boolean = (py - hitheight / 2) > tile.y && (py - hitheight / 2) < tile.y + tile.height;
			var plefthit:Boolean = (px - hitwidth / 2) > tile.x && (px - hitwidth / 2) < tile.x + tile.width;
			var prighthit:Boolean = (px + hitwidth / 2) > tile.x && (px + hitwidth / 2) < tile.x + tile.width;
			
			var on_leftwall:Boolean = Math.abs((px + hitwidth / 2) - (tile.x - extraPush)) < 0.01 || Math.abs((x + hitwidth / 2) - (tile.x - extraPush)) < 0.01;
			var on_rightwall:Boolean = Math.abs((px - hitwidth / 2) - (tile.x + tile.width + extraPush)) < 0.01 || Math.abs((x - hitwidth / 2) - (tile.x + tile.width + extraPush)) < 0.01;
			var on_topwall:Boolean = Math.abs((py + hitheight / 2) - (tile.y - extraPush)) < 0.01 || Math.abs((y + hitheight / 2) - (tile.y - extraPush)) < 0.01;
			var on_bottomwall:Boolean = Math.abs((py - hitheight / 2) - (tile.y + tile.height + extraPush)) < 0.01 || Math.abs((y - hitheight / 2) - (tile.y + tile.height + extraPush)) < 0.01;
			
			if (bottomhit && righthit && !pbottomhit && !prighthit && !on_topwall && !on_leftwall && dx > 0 && dy > 0)
			{
				DoCornerBounce(x + (hitwidth / 2), y + (hitheight / 2), tile.x, tile.y);
			}
			else
			if (bottomhit && lefthit && !pbottomhit && !plefthit && !on_topwall && !on_rightwall && dx < 0 && dy > 0)
			{
				DoCornerBounce(x - (hitwidth / 2), y + (hitheight / 2), tile.x + tile.width, tile.y);
			}
			else
			if (tophit && righthit && !ptophit && !prighthit && !on_bottomwall && !on_leftwall && dx > 0 && dy < 0)
			{
				DoCornerBounce(x + (hitwidth / 2), y - (hitheight / 2), tile.x, tile.y + tile.height);
			}
			else
			if (tophit && lefthit && !ptophit && !plefthit && !on_bottomwall && !on_rightwall && dx < 0 && dy < 0)
			{
				DoCornerBounce(x - (hitwidth / 2), y - (hitheight / 2), tile.x + tile.width, tile.y + tile.height);
			}
			else
			if (tophit && !ptophit && !on_leftwall && !on_rightwall && dy < 0)
			{
				BounceY(tile.y + tile.height - (y - hitheight / 2));
			}
			else
			if (bottomhit && !pbottomhit && !on_leftwall && !on_rightwall && dy > 0)
			{
				BounceY(tile.y - (y + hitheight / 2));
				yvel -= extraPush;
				xvel *= friction;
			}
			else
			if (lefthit && !plefthit && !on_topwall && !on_bottomwall && dx < 0)
			{
				BounceX(tile.x + tile.width - (x - hitwidth / 2));
			}
			else
			if (righthit && !prighthit && !on_topwall && !on_bottomwall && dx > 0)
			{
				BounceX(tile.x - (x + hitwidth / 2));
				xvel -= extraPush;
				yvel *= friction;
			}
		}
		
		protected function DoCornerBounce(entityCornerX:Number, entityCornerY:Number, tileCornerX:Number, tileCornerY:Number):void 
		{
			// if entityCornerX exceeds tileCornerX
			// and entCornerY exceeds tileCornerY
				//figure out if the cornerpoint crossed the vertical or horizontal
				//calculate the slope from prevcornerpoint to tilecorner
				//calculate the slope from prevcornerpoint to currentcornerpoint
				//if slope2 < slope1, crossed horizontal, else crossed vertical
			var dx:Number = x - px;
			var dy:Number = y - py;
			//crossed horizontal at time t
			var prevCornerX:Number = entityCornerX - dx;
			var prevCornerY:Number = entityCornerY - dy;
			//assume that the crossed point on the tile is inbetween the entity point and previous entity point
			var t:Number = Math.abs(prevCornerX - tileCornerX) / Math.abs(dx);
			var ypoint:Number = (t * dy) + prevCornerY;
			if (ypoint > tileCornerY)
			{
				if (dy > 0)
				{
					BounceX(tileCornerX - entityCornerX);
				}
				else
				{
					BounceY(tileCornerY - entityCornerY);
				}
			}
			else
			{
				if (dy > 0)
				{
					BounceY(tileCornerY - entityCornerY);
				}
				else
				{
					BounceX(tileCornerX - entityCornerX);
				}
			}
		}
		
		protected function BounceX(pushOut:Number):void 
		{
			x = x + pushOut;
			
			if (pushOut >= 0)
			{
				x += extraPush;
			}
			else
			{
				x -= extraPush;
			}
			xvel *= -elasticity;
			yvel *= friction; // nice to have: wall friction
			
			//insurance against things digging themselves further into walls
			if (pushOut < 0)
			{
				if (xvel > 0)
				{
					xvel *= -1;
				}
			}
			else
			{
				if (xvel < 0)
				{
					xvel *= -1;
				}
			}
		}
		protected function BounceY(pushOut:Number):void 
		{
			y = y + pushOut;
			if (pushOut >= 0)
			{
				y += extraPush;
			}
			else
			{
				y -= extraPush;
			}
			yvel *= -elasticity;
			xvel *= friction; // nice to have: wall friction
			
			//insurance against things digging themselves further into walls
			if (pushOut < 0)
			{
				if (yvel > 0)
				{
					yvel *= -1;
				}
			}
			else
			{
				if (yvel < 0)
				{
					yvel *= -1;
				}
			}
		}
		
		protected function HitDiagTile(tile:DiagTile):void 
		{
			//if diagtype == 3, bottom left
			//0 = topleft
			//1 = topright
			//2 = bottomright
		
			var exwall:Number; //exwall = entity's hitbox's edge x position. the edge facing the tile's vertical wall
			var exslop:Number; // the opposite side from exwall
			var pxwall:Number; //same as exwall but for entity's previous position
			var pxslop:Number; //same as pxwall but at the opposite side
			var txwall:Number; //the x coordinate of the tile's vertical wall
			var txslop:Number; // the opposite side from txwall
			
			var exwdir:Number;  //exwdir = if the entity has to move left to hit the tile's vertical wall, this value is -1, else 1
			var exwleft:Boolean;
			
			if (tile.dir == 1 || tile.dir == 2)
			{
				exwall = x - hitwidth / 2;
				pxwall = px - hitwidth / 2;
				txwall = tile.x + tile.width;
				exwleft = true;
				exwdir = -1;
				exslop = x + hitwidth / 2;
				txslop = tile.x;
				pxslop = px + hitwidth / 2;
			}
			else
			{
				exwall = x + hitwidth / 2;
				pxwall = px + hitwidth / 2;
				txwall = tile.x;
				exwleft = false;
				exwdir = 1;
				exslop = x - hitwidth / 2;
				txslop = tile.x + tile.width;
				pxslop = px - hitwidth / 2;
			}
			
			var eywall:Number; //exwall = entity's hitbox's edge x position. the edge facing the tile's vertical wall
			var eyslop:Number; // the opposite side from exwall
			var pywall:Number; //same as exwall but for entity's previous position
			var pyslop:Number; //same as pxwall but at the opposite side
			var tywall:Number; //the x coordinate of the tile's vertical wall
			var tyslop:Number; // the opposite side from txwall
			
			var eywdir:Number;  //exwdir = if the entity has to move left to hit the tile's vertical wall, this value is -1, else 1
			var eywup:Boolean;
			
			if (tile.dir == 2 || tile.dir == 3)
			{
				eywall = y - hitheight / 2;
				pywall = py - hitheight / 2;
				tywall = tile.y + tile.height;
				eywup = true;
				eywdir = -1;
				eyslop = y + hitheight / 2;
				tyslop = tile.y;
				pyslop = py + hitheight / 2;
			}
			else
			{
				eywall = y + hitheight / 2;
				pywall = py + hitheight / 2;
				tywall = tile.y;
				eywup = false;
				eywdir = 1;
				eyslop = y - hitheight / 2;
				tyslop = tile.y + tile.height;
				pyslop = py - hitheight / 2;
			}
			
			var x_bounce:Boolean = (exwall < txwall) == exwleft && (pxwall - (exwdir * extraPush) > txwall) == exwleft;
			var y_bounce:Boolean = (eywall < tywall) == eywup && (pywall - (eywdir * extraPush) > tywall) == eywup;
			var on_xwall:Boolean = pxwall == txwall - (exwdir * extraPush) || exwall == txwall - (exwdir * extraPush);//(pxwall > (txwall + (extraPush * 2 * exwdir))) == exwleft && pxwall > txwall + (extraPush * 2 * exwdir);
			var on_ywall:Boolean = pywall == tywall - (eywdir * extraPush) || eywall == tywall - (eywdir * extraPush);//(pywall > (tywall + (extraPush * 2 * eywdir))) == eywup && pywall > tywall + (extraPush * 2 * eywdir);
			
			//only topleft corner hits the tile
			var cornerX:Number = exslop - txwall;
			var cornerY:Number = eyslop - tywall
			var pcornerX:Number = pxslop - txwall;
			var pcornerY:Number = pyslop - tywall;
			
			//these handle the condition that it hits the 90 degree walls of the triangle
			if (x_bounce && y_bounce && !on_ywall && !on_xwall)
			{
				DoCornerBounce(exwall, eywall, txwall, tywall);
				trace("corner bounce");
			}
			else if (x_bounce && !on_ywall)
			{
				BounceX(txwall - exwall);
			}
			else if (y_bounce && !on_xwall)
			{
				BounceY(tywall - eywall);
			}
			//these handle the condition that it hits the pointy parts of the triangle
			else if ((exwall < txwall) == exwleft && (exslop > txwall) == exwleft &&
						(pyslop + (extraPush * eywdir) < tyslop) == eywup && (eyslop > tyslop) == eywup)
			{
				BounceY(tyslop - eyslop);
			}
			else if ((eyslop > tywall) == eywup && (eywall < tywall) == eywup &&
						(pxslop + (extraPush * exwdir) < txslop) == exwleft && (exslop > txslop) == exwleft)
			{
				BounceX(txslop - exslop);
			}
			else
			//finally, the part that actually handles the slope
			if ((cornerX * exwdir) + (cornerY * eywdir) < tile.width && (pcornerX * exwdir) + (pcornerY * eywdir) > tile.width)
			{
				var temp:Number = xvel;
				xvel = yvel * -elasticity * exwdir * eywdir;
				yvel = temp * -elasticity * exwdir * eywdir;
				
				var pushOutAmt:Number = extraPush + ((tile.width - ((cornerX * exwdir) + (cornerY * eywdir))) / 2);
				x += pushOutAmt * exwdir;
				y += pushOutAmt * eywdir;
			}
			
			//catch-all

			if (tile.dir == 1 || tile.dir == 2)
			{
				exwall = x - hitwidth / 2;
				pxwall = px - hitwidth / 2;
				txwall = tile.x + tile.width;
				exwleft = true;
				exwdir = -1;
				exslop = x + hitwidth / 2;
				txslop = tile.x;
				pxslop = px + hitwidth / 2;
			}
			else
			{
				exwall = x + hitwidth / 2;
				pxwall = px + hitwidth / 2;
				txwall = tile.x;
				exwleft = false;
				exwdir = 1;
				exslop = x - hitwidth / 2;
				txslop = tile.x + tile.width;
				pxslop = px - hitwidth / 2;
			}
			
			if (tile.dir == 2 || tile.dir == 3)
			{
				eywall = y - hitheight / 2;
				pywall = py - hitheight / 2;
				tywall = tile.y + tile.height;
				eywup = true;
				eywdir = -1;
				eyslop = y + hitheight / 2;
				tyslop = tile.y;
				pyslop = py + hitheight / 2;
			}
			else
			{
				eywall = y + hitheight / 2;
				pywall = py + hitheight / 2;
				tywall = tile.y;
				eywup = false;
				eywdir = 1;
				eyslop = y - hitheight / 2;
				tyslop = tile.y + tile.height;
				pyslop = py - hitheight / 2;
			}
			
			var xyDiffSum:Number = ((exslop - txslop) * exwdir) + ((eyslop  - tyslop) * eywdir);
			
			if (((exslop > txslop) == exwleft && (eyslop > tyslop) == eywup)
			&& ((exslop < txwall) == exwleft && (eyslop < tywall) == eywup)
			&& (xyDiffSum + tile.width < 0))
			{
				x -= exwdir * (((xyDiffSum + tile.width) / 2) - extraPush);
				y -= eywdir * (((xyDiffSum + tile.width) / 2) - extraPush);
			}
			else
			if ((exwall < txwall == exwleft && (eywall < tywall) == eywup)
			&& (((exwall - txwall) * exwdir) + ((eywall - tywall) * eywdir) < tile.width))
			{
				if (((exwall - txwall) * exwdir) < ((eywall - tywall) * eywdir))
				{
					x -= (extraPush + exwall - txwall) * exwdir;
				}
				else
				{
					y -= (extraPush + eywall - tywall) * eywdir;
				}
			}
		}
	}

}
