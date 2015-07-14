package wander.demos
{
	import wander.Climbable;
	import wander.Text3D;
	import wander.utils.*;
	import org.flixel.*;
	import wander.Sprite3D;
	/**
	 * Demo class to show off text in 3D
	 * @author zillix
	 */
	public class TextDemo extends Zlx3DDemo
	{
		[Embed(source = "data/map.png")]	public var MapImage:Class;
		
		public function TextDemo()
		{
			super();
			loadMapImage(MapImage);
		}
		
		private static const MIDDLE_TEXT:uint = 0x1EDA02; // 30,218,2 (green)
		private static const FAR_TEXT:uint = 0x572F17; // 87 47 23 (brown)
		private static const CLOSE_TEXT:uint = 0x1B02DA; // 27 2 218 (blue)
		override protected function handleMapPixelColor(color:uint, xPos:int, zPos:int) : FlxObject
		{
			var text:String = "empty";
			var fontSize:int = 12;
			var background:Sprite3D;
			var width:int = 100;
			switch(color)
			{

				case MIDDLE_TEXT:
					text = "hello!";
					fontSize = 40;
					width = 140;
					
					background = new Sprite3D(xPos, 0, zPos + 1); // so it is behind
					background.makeGraphic(200, 150, 0xff00ff00);
					background.immovable = true;
					_objects.add(background);
					break;
					
				case FAR_TEXT:
					text = "large text that is far away! I made this very long so it is visible from a distance";
					fontSize = 127; 	// Max font size in as3
					width = 700;
					
					background = new Sprite3D(xPos, 0, zPos + 1); // so it is behind
					background.makeGraphic(1000, 5000, 0xffff0000);
					background.immovable = true;
					_objects.add(background);
					break;
					
				case CLOSE_TEXT:
					text = "some close text with\nline breaks";
					fontSize = 15;
					width = 100;
					
					background = new Sprite3D(xPos, 0, zPos + 1); // so it is behind
					background.makeGraphic(200, 200, 0xffff0000);
					background.immovable = true;
					_objects.add(background);
					break;
			}
			
			var text3D:Text3D = new Text3D(xPos, 0, zPos, width, text, true);
			text3D.size = fontSize;
			text3D.color = 0xff000000;
			
			// Offset it so the text aligns with the ground
			text3D.y = -text3D.height;
			
			
			return text3D;
		}
	}
	
}