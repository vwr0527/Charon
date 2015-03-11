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
		private var px:Number = 0.0;
		private var py:Number = 0.0;
		public var hitwidth:Number = 0.0;
		public var hitheight:Number = 0.0;
		public var rotvel:Number = 0.0;
		public var friction:Number = 0.99;
		public var rotfric:Number = 0.99;
		public var elasticity:Number = 0.75;
		private var hitboxGraphic:Shape;
		public var noclip:Boolean = true;
		public var showhitbox:Boolean = false;
		
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
		
		private function HitTile(tile:Tile):void
		{
			if (tile == null) return;
			
			var dx:Number = x - px;
			var dy:Number = y - py;
			
			// if movement is downright
			if (dx >= 0 && dy >= 0)
			{
				//trace("a");
				DoCornerBounce(x + (hitwidth / 2), y + (hitheight / 2), tile.x,				 tile.y,				 dx, dy);
			}
			else
			// if movement is downleft
			if (dx <= 0 && dy >= 0)
			{
				//trace("b");
				DoCornerBounce(x - (hitwidth / 2), y + (hitheight / 2), tile.x + tile.width, tile.y,				 dx, dy);
			}
			else
			// if movement is upright
			if (dx >= 0 && dy <= 0)
			{
				//trace("c");
				DoCornerBounce(x + (hitwidth / 2), y - (hitheight / 2), tile.x,				 tile.y + tile.height,	 dx, dy);
			}
			else
			// if movement is upleft
			if (dx <= 0 && dy <= 0)
			{
				//trace("d");
				DoCornerBounce(x - (hitwidth / 2), y - (hitheight / 2), tile.x + tile.width, tile.y + tile.height,	 dx, dy);
			}
		}
		
		private function DoCornerBounce(entityCornerX:Number, entityCornerY:Number, tileCornerX:Number, tileCornerY:Number, deltaX:Number, deltaY:Number):void 
		{
			// if entityCornerX exceeds tileCornerX
			// and entCornerY exceeds tileCornerY
				//figure out if the cornerpoint crossed the vertical or horizontal
				//calculate the slope from prevcornerpoint to tilecorner
				//calculate the slope from prevcornerpoint to currentcornerpoint
				//if slope2 < slope1, crossed horizontal, else crossed vertical
			var moveRight:Boolean = (deltaX >= 0);
			var moveDown:Boolean = (deltaY >= 0);
			if ((entityCornerX > tileCornerX) == moveRight && (entityCornerY > tileCornerY) == moveDown)
			{
				var prevEntityCornerX:Number = entityCornerX - deltaX;
				var prevEntityCornerY:Number = entityCornerY - deltaY;
				
				var prevCornerXInsideTile:Boolean = ((prevEntityCornerX > tileCornerX) == moveRight);
				var prevCornerYInsideTile:Boolean = ((prevEntityCornerY > tileCornerY) == moveDown);
				if (prevEntityCornerX == tileCornerX && deltaX < 0) prevCornerXInsideTile = false; //goddamnit
				if (prevCornerXInsideTile)
				{
					BounceY(tileCornerY - entityCornerY);
				}
				else if (prevCornerYInsideTile)
				{
					BounceX(tileCornerX - entityCornerX);
				}
				else
				{
					var slopeEntityPrevToCur:Number = (entityCornerY - prevEntityCornerY) / (entityCornerX - prevEntityCornerX);
					var slopeEntityPrevToTile:Number = (tileCornerY - prevEntityCornerY) / (tileCornerX - prevEntityCornerX);
					
					//because if the movement is downleft or upright, the slope is reversed.
					var xorCornerXYInTile:Boolean = (prevCornerXInsideTile && !prevCornerYInsideTile) || (!prevCornerXInsideTile && prevCornerYInsideTile);
					
					if ((slopeEntityPrevToCur < slopeEntityPrevToTile) == xorCornerXYInTile)
					{
						BounceX(tileCornerX - entityCornerX);
					}
					else
					{
						BounceY(tileCornerY - entityCornerY);
					}
				}
			}
		}
		private var extraPush:Number = 0.1;
		private function BounceX(pushOut:Number):void 
		{
			x = x + pushOut;
			if (pushOut >= 0)
			{
				px += extraPush;
				x += extraPush / 2;
			}
			else
			{
				px -= extraPush;
				x -= extraPush / 2;
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
		private function BounceY(pushOut:Number):void 
		{
			y = y + pushOut;
			if (pushOut >= 0)
			{
				py += extraPush;
				y += extraPush / 2;
			}
			else
			{
				py -= extraPush;
				y -= extraPush / 2;
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
	}

}
