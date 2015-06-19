package wander.demos 
{
	import org.flixel.FlxGroup;
	import wander.Climbable;
	/**
	 * ...
	 * @author ...
	 */
	public class DemoClimbable extends Climbable
	{
		
		[Embed(source = "data/climbMap1.png")]	public var DemoClimbMap:Class;
		
		public function DemoClimbable(X:Number, Y:Number, Z:Number, parentLayer:FlxGroup, ClimbClass:Class = null)
		{
			super(X, Y, Z, parentLayer, DemoClimbMap);
			
			makeGraphic(200, 400, 0xff0000ff);
		}
		
	}

}