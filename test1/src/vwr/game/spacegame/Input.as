package vwr.game.spacegame 
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.Event;
	/**
	 * ...
	 * @author Victor Reynolds
	 */
	
	public class Input extends Sprite
	{
		private static var mouseDown:int;
		private static var wheelDelta:int;
		private static var keyDown:Array;
		private var keyBuf:Vector.<int>;
		private var cover:Shape;
		
		public function Input() 
		{
			//0 = mouse/key is up
			//2 = mouse/key has just been pressed
			//1 = mouse/key is holding down
			//3 = mouse/key was pressed and released before update was called once
			mouseDown = 0;
			wheelDelta = 0;
			keyDown = new Array(256);
			for (var i:int = 0; i < 256; ++i) keyDown[i] = 0;
			keyBuf = new Vector.<int>();
			
			cover = new Shape();
            cover.graphics.beginFill(0x00000000);
            cover.graphics.drawRect(-4000, -4000, 8000, 8000);
            cover.graphics.endFill();
			cover.alpha = 0;
            addChild(cover);
			
			addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		public function Update():void
		{
			if (mouseDown == 2)
				mouseDown = 1;
			else
			if (mouseDown == 3)
				mouseDown = 0;
				
			if (wheelDelta != 0)
				wheelDelta = 0;
				
			while (keyBuf.length > 0)
			{
				var keyCode:int = keyBuf.pop();
				if (keyDown[keyCode] == 2)
					keyDown[keyCode] = 1;
				else
				if (keyDown[keyCode] == 3)
					keyDown[keyCode] = 0;
			}
		}
		
		private function addedToStageHandler(event:Event):void
		{
			stage.focus = this;
		}
		
		private function mouseDownHandler(event:MouseEvent):void
		{
			if (mouseDown == 0)
				mouseDown = 2;
			stage.focus = this;
		}
		
		private function mouseUpHandler(event:MouseEvent):void
		{
			if (mouseDown == 1)
				mouseDown = 0;
			if (mouseDown == 2)
				mouseDown = 3;
		}
		
		private function mouseWheelHandler(event:MouseEvent):void
		{
			if (event.delta > 0)
			{
				wheelDelta = 1;
			}
			if (event.delta < 0)
			{
				wheelDelta = -1;
			}
		}
		
		private function keyDownHandler(event:KeyboardEvent):void
		{
			if (keyDown[event.keyCode] == 0)
			{
				keyDown[event.keyCode] = 2;
				keyBuf.push(event.keyCode);
			}
		}
		
		private function keyUpHandler(event:KeyboardEvent):void
		{
			if (keyDown[event.keyCode] == 1)
				keyDown[event.keyCode] = 0;
			if (keyDown[event.keyCode] == 2)
				keyDown[event.keyCode] = 3;
		}
		
		public static function moveUp():int
		{
			return keyDown[87];
		}
		public static function moveDown():int
		{
			return keyDown[83];
		}
		public static function moveLeft():int
		{
			return keyDown[65];
		}
		public static function moveRight():int
		{
			return keyDown[68];
		}
		public static function mouseButton():int
		{
			return mouseDown;
		}
		public static function upArrow():int
		{
			return keyDown[38];
		}
		public static function downArrow():int
		{
			return keyDown[40];
		}
		public static function leftArrow():int
		{
			return keyDown[37];
		}
		public static function rightArrow():int
		{
			return keyDown[39];
		}
		public static function p():int
		{
			return keyDown[80];
		}
		public static function lbrac():int
		{
			return keyDown[219];
		}
		public static function rbrac():int
		{
			return keyDown[221];
		}
		public static function esc():int
		{
			return keyDown[27];
		}
		public static function mWheel():int
		{
			return wheelDelta;
		}
	}
}