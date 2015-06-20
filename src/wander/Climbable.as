package wander
{
	import wander.*;
	import org.flixel.*;
	/**
	 * A sprite containing a tilemap.
	 * The tilemap is expected to bound out the non-climbable regions.
	 * When the player comes into contact with a climbable, 
	 * the movement is limited to the X/Y plane (can't move along the Z axis).
	 * While climbing, the player is collided against the tilemap.
	 * @author zillix
	 */
	public class Climbable extends ZlxSprite 
	{
		[Embed(source = "data/climbTiles.png")]	public var AutoTiles:Class;
		
		public var tileMap:Tilemap3D;
		public function Climbable(X:Number, Y:Number, Z:Number, parentLayer:FlxGroup, ClimbClass:Class = null)
		{
			super(X, Y, Z);
			
			if (ClimbClass == null)
			{
				trace("Failed to initialize Climbable!");
				return;
			}
			
			tileMap = new Tilemap3D();
			tileMap.loadMap(FlxTilemap.bitmapToCSV(FlxG.addBitmap(ClimbClass)), AutoTiles, 20, 20);
			tileMap.z = Z - .01;
			tileMap.y =  0;
			tileMap.x = X;
			tileMap.offset = new FlxPoint(tileMap.width / 2, tileMap.height);
			tileMap.origin = new FlxPoint(tileMap.width / 2, tileMap.height);
			parentLayer.add(tileMap);
		}
	}
	
}