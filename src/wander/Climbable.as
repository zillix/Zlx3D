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
		
		private var _unclimbableMap:Tilemap3D;	// Blocked regions. Used for collision while climbing.
		private var _climbableMap:Tilemap3D;	// Unblocked regions. Used for collision with the climbable.
		
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
			
			_unclimbableMap = setUpMap(ClimbClass, false);
			_climbableMap = setUpMap(ClimbClass, true);

			climbMapLayer.add(_unclimbableMap);
		}
		
		private function setUpMap(ClimbClass:Class, invert:Boolean) : Tilemap3D
		{
			var map:Tilemap3D = createTilemap();
			map.loadMap(FlxTilemap.bitmapToCSV(
								FlxG.addBitmap(ClimbClass),
								invert
							), 
							AutoTiles, 
							scale.x, 
							scale.y
						);
			map.x = x;
			map.y = y;
			map.z = z - .01;	// So it doesn't obscure the sprite, if visible
			map.offset = new FlxPoint(map.width / 2, map.height);
			map.origin = new FlxPoint(map.width / 2, map.height);
			
			return map;
		}
		
		// Defines the *blocked* regions
		public function get unclimbableMap() : Tilemap3D
		{
			return _unclimbableMap;
		}
		
		// Defines the *unblocked* regions
		public function get climbableMap() : Tilemap3D
		{
			return _climbableMap;
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