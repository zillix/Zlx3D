package org.flixel
{
	import flash.geom.Point;
	
	/**
	 * Stores a 2D floating point coordinate.
	 * 
	 * @author	Adam Atomic
	 */
	public class FlxPoint
	{
		/**
		 * @default 0
		 */
		public var x:Number;
		/**
		 * @default 0
		 */
		public var y:Number;
		
		public var z:Number;
		
		/**
		 * Instantiate a new point object.
		 * 
		 * @param	X		The X-coordinate of the point in space.
		 * @param	Y		The Y-coordinate of the point in space.
		 */
		public function FlxPoint(X:Number=0, Y:Number=0, Z:Number=0)
		{
			x = X;
			y = Y;
			z = Z;
		}
		
		/**
		 * Instantiate a new point object.
		 * 
		 * @param	X		The X-coordinate of the point in space.
		 * @param	Y		The Y-coordinate of the point in space.
		 */
		public function make(X:Number=0, Y:Number=0, Z:Number=0):FlxPoint
		{
			x = X;
			y = Y;
			z = Z;
			return this;
		}
		
		/**
		 * Helper function, just copies the values from the specified point.
		 * 
		 * @param	Point	Any <code>FlxPoint</code>.
		 * 
		 * @return	A reference to itself.
		 */
		public function copyFrom(Point:FlxPoint):FlxPoint
		{
			x = Point.x;
			y = Point.y;
			z = Point.z;
			return this;
		}
		
		/**
		 * Helper function, just copies the values from this point to the specified point.
		 * 
		 * @param	Point	Any <code>FlxPoint</code>.
		 * 
		 * @return	A reference to the altered point parameter.
		 */
		public function copyTo(Point:FlxPoint):FlxPoint
		{
			Point.x = x;
			Point.y = y;
			Point.z = z;
			return Point;
		}
		
		/**
		 * Helper function, just copies the values from the specified Flash point.
		 * 
		 * @param	Point	Any <code>Point</code>.
		 * 
		 * @return	A reference to itself.
		 */
		public function copyFromFlash(FlashPoint:Point):FlxPoint
		{
			x = FlashPoint.x;
			y = FlashPoint.y;
			z = 0;
			return this;
		}
		
		/**
		 * Helper function, just copies the values from this point to the specified Flash point.
		 * 
		 * @param	Point	Any <code>Point</code>.
		 * 
		 * @return	A reference to the altered point parameter.
		 */
		public function copyToFlash(FlashPoint:Point):Point
		{
			FlashPoint.x = x;
			FlashPoint.y = y;
			return FlashPoint;
		}
		
		public static function getVector(srcPoint:FlxPoint, dstPoint:FlxPoint):FlxPoint
		{
			var point:FlxPoint = new FlxPoint();
			dstPoint.copyTo(point);
			point.x -= srcPoint.x;
			point.y -= srcPoint.y;
			point.z -= srcPoint.z;
			return point;
		}
		
		public static function addVector(srcPoint:FlxPoint, vector:FlxPoint) : FlxPoint
		{
			var point:FlxPoint = new FlxPoint();
			srcPoint.copyTo(point);
			point.x += vector.x;
			point.y += vector.y;
			point.z += vector.z;
			return point;
		}
	}
}
