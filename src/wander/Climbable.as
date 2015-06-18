package wander
{
	import wander.*;
	import org.flixel.*;
	/**
	 * ...
	 * @author zillix
	 */
	public class Climbable extends GameObject 
	{
		[Embed(source = "data/climbTiles.png")]	public var AutoTiles:Class;
		[Embed(source = "data/climbMap1.png")]	public var ClimbMap1:Class;
		
		public var tileMap:Tilemap3D;
		public function Climbable(X:Number, Y:Number, Z:Number, parentLayer:FlxGroup, ClimbClass:Class = null)
		{
			super(X, Y, Z);
			
			if (ClimbClass == null)
			{
				ClimbClass = ClimbMap1;
			}
			
			tileMap = new Tilemap3D();
			tileMap.loadMap(FlxTilemap.bitmapToCSV(FlxG.addBitmap(ClimbClass)), AutoTiles, 20, 20);// , FlxTilemap.OFF, 0, 0, 0);
			tileMap.z = Z - .01;
			this.setOffsets();
			tileMap.y =  0;
			tileMap.x = X;
			tileMap.offset = new FlxPoint(tileMap.width / 2, tileMap.height);
			tileMap.origin = new FlxPoint(tileMap.width / 2, tileMap.height);
			parentLayer.add(tileMap);
		}
		
		override public function update():void
		{
			super.update();
		}
	}
	
}