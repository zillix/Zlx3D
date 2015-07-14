package wander
{
	import org.flixel.FlxPoint;
	
	/**
	 * Simple point that supports a Z value.
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
		
		public static function getVector(srcPoint:Point3D, dstPoint:Point3D):Point3D
		{
			var point:Point3D = new Point3D();
			dstPoint.copyTo(point);
			point.x -= srcPoint.x;
			point.y -= srcPoint.y;
			point.z -= srcPoint.z;
			return point;
		}
		
		public static function addVector(srcPoint:Point3D, vector:Point3D) : Point3D
		{
			var point:Point3D = new Point3D();
			srcPoint.copyTo(point);
			point.x += vector.x;
			point.y += vector.y;
			point.z += vector.z;
			return point;
		}
		
		override public function copyTo(Point:FlxPoint):FlxPoint
		{
			super.copyTo(Point);
			
			if (Point is Point3D)
			{
				Point3D(Point).z = z;
			}
			
			return Point;
		}
		
	}
	
}