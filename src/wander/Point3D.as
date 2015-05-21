package wander
{
	import org.flixel.FlxPoint;
	
	/**
	 * ...
	 * @author zillix
	 */
	public class Point3D extends FlxPoint 
	{
		public var z:Number;
		public function Point3D(X:Number = 0, Y:Number = 0, Z:Number = 0)
		{
			super(X, Y);
			z = Z;
		}
		
	}
	
}