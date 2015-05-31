package wander
{
	import org.flixel.FlxPoint;
	
	/**
	 * ...
	 * @author zillix
	 */
	public class ZlxPoint extends FlxPoint 
	{
		public var z:Number;
		public function ZlxPoint(X:Number = 0, Y:Number = 0, Z:Number = 0)
		{
			super(X, Y);
			z = Z;
		}
		
		public static function getVector(srcPoint:ZlxPoint, dstPoint:ZlxPoint):ZlxPoint
		{
			var point:ZlxPoint = new ZlxPoint();
			dstPoint.copyTo(point);
			point.x -= srcPoint.x;
			point.y -= srcPoint.y;
			point.z -= srcPoint.z;
			return point;
		}
		
		public static function addVector(srcPoint:ZlxPoint, vector:ZlxPoint) : ZlxPoint
		{
			var point:ZlxPoint = new ZlxPoint();
			srcPoint.copyTo(point);
			point.x += vector.x;
			point.y += vector.y;
			point.z += vector.z;
			return point;
		}
		
	}
	
}