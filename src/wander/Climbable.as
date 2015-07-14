package wander
{
	import wander.*;
	import org.flixel.*;
	/**
	 * A Sprite3D that the player can climb when they come into contact with it.
	 * 
	 * @param parentLayer
	 * 		The layer to which the climb map will be added. This usually doesn't matter, since they are normally invisible.
	 * 
	 * @param ClimbClass
	 * 		A class definition for an embedded climb map png.
	 * 		Black pixels in the climb map are interpreted as impassable, unclimbable regions.
	 * 		Nonblack pixels are ignored.
	 * 		Typically, you would create a climb map by copying the displayed sprite
	 * 		and flood-filling the impassable regions with black.
	 * 
	 * @author zillix
	 */
	public class Climbable extends Sprite3D 
	{
		[Embed(source = "data/climbTiles.png")]	public var AutoTiles:Class;
		
		private static const DEFAULT_SCALE:int = 20;
		
		private var _climbMap:Tilemap3D;
		public function Climbable(X:Number, Y:Number, Z:Number, climbMapLayer:FlxGroup, ClimbClass:Class = null)
		{
			super(X, Y, Z);
			
			immovable = true;
			
			if (ClimbClass == null)
			{
				trace("Failed to initialize Climbable!");
				return;
			}
			
			scale = new Point3D(DEFAULT_SCALE, DEFAULT_SCALE, 1);
			
			_climbMap = createTilemap();
			_climbMap.loadMap(FlxTilemap.bitmapToCSV(FlxG.addBitmap(ClimbClass)), AutoTiles, scale.x, scale.y);
			_climbMap.x = X;
			_climbMap.y = Y;
			_climbMap.z = Z - .01;	// So it doesn't obscure the sprite, if visible
			_climbMap.offset = new FlxPoint(_climbMap.width / 2, _climbMap.height);
			_climbMap.origin = new FlxPoint(_climbMap.width / 2, _climbMap.height);

			climbMapLayer.add(_climbMap);
		}
		
		public function get climbMap() : Tilemap3D
		{
			return _climbMap;
		}
		
		// Can be overridden by child classes
		protected function createTilemap() : Tilemap3D
		{
			var map:Tilemap3D = new Tilemap3D();
			map.visible = false;
			return map;
		}
	}
	
}