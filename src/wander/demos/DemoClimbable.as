package wander.demos 
{
	import org.flixel.FlxGroup;
	import wander.Climbable;
	import wander.Tilemap3D;
	/**
	 * Demo climbable object with a demo climbMap.
	 * @author zillix
	 */
	public class DemoClimbable extends Climbable
	{
		
		public function DemoClimbable(X:Number,
										Y:Number, 
										Z:Number, 
										parentLayer:FlxGroup, 
										SpriteClass:Class,
										ClimbMap:Class)
		{
			super(X, Y, Z, parentLayer, ClimbMap);
			
			loadGraphic(SpriteClass);
			immovable = true;
		}
		
		override protected function createTilemap() : Tilemap3D
		{
			return new DemoTilemap3D();
		}
		
	}

}