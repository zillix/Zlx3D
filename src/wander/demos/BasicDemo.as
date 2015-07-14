package wander.demos 
{
	import org.flixel.FlxObject;
	import wander.Sprite3D;
	/**
	 * ...
	 * @author ...
	 */
	public class BasicDemo extends Zlx3DDemo 
	{
		[Embed(source = "data/map.png")]	public var MapImage:Class;
		
		public function BasicDemo() 
		{
			super();
			loadMapImage(MapImage);
		}
		
		private static const MIDDLE:uint = 0x1EDA02; // 30,218,2 (green)
		private static const FAR:uint = 0x572F17; // 87 47 23 (brown)
		private static const NEAR:uint = 0x1B02DA; // 27 2 218 (blue)
		override protected function handleMapPixelColor(color:uint, xPos:int, zPos:int) : FlxObject
		{
			var object:Sprite3D = new Sprite3D(xPos, 0, zPos);
			// Intentionally not making these immovable,
			// 		because it's funnier that way.
			
			switch(color)
			{

				case MIDDLE:
					object.makeGraphic(80, 120, 0xff00ff00);
					break;
					
				case FAR:
					object.makeGraphic(400, 1000, 0xffff0000);
					break;
					
				case NEAR:
					object.makeGraphic(100, 150, 0xff0000ff);
					break;
			}
			
			return object;
		}
		
	}

}