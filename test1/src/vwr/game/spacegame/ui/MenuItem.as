package vwr.game.spacegame.ui 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author ...
	 */
	public class MenuItem extends Sprite
	{
		//Never Surrender by Darrell Flood
		[Embed(source = "/../../font/Never Surrender.ttf",
        fontName = "myFont",
        mimeType = "application/x-font",
        advancedAntiAliasing="true",
        embedAsCFF = "false")]
		private var myEmbeddedFont:Class;
		
		public var textField:TextField;
		public var textContainer:Sprite;
		
		public var command:String;
		
		public function MenuItem(name:String, com:String)
		{
			super();
			
			textField = new TextField();
			textField.textColor = 0xFFFF00;
			
			textField.defaultTextFormat = new TextFormat("myFont", 20);
			textField.embedFonts = true;
			textField.width += 40;
			
			textContainer = new Sprite();
			textContainer.addChild(textField);
			textField.x = -textContainer.width / 2;
			addChild(textContainer);
			textField.text = name;
			
			command = com;
		}
	}
}