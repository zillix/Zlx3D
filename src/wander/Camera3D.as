package wander
{
	import flash.geom.Point;
	import org.flixel.*;
	import wander.utils.MathUtils;
	/**
	 * ...
	 * @author zillix
	 */
	public class Camera3D extends FlxCamera 
	{
		private var scrollSpeed:FlxPoint;
		
		public var focalLength:int = 200;
		public var fieldOfView:int;
		public var ratio:Number;
		public var z:Number;
		
		public var viewHeight:Number;
		public var viewWidth:Number;
		
		public var position:FlxPoint;
		
		public var followDist:FlxPoint;
		public var followTarget:GameObject;
		public var followSpeed:FlxPoint;
		
		public var deadDist:FlxPoint;
		
		public var reachTargetCallback:Function;
		
		public function Camera3D(X:int,Y:int,Width:int,Height:int,Zoom:Number=0)
		{
			init();
		
			position = new FlxPoint();
			ratio = FlxG.height / FlxG.width;
			z = 0;
			
			super(X, Y, Width, Height, Zoom);
			
			viewHeight = FlxG.height;
			viewWidth = ratio * viewHeight;
		}
		
		public function init():void
		{
			scrollSpeed = new FlxPoint(100, 100, 100);
			followSpeed = new FlxPoint(300, 300, 500);
			deadDist = new FlxPoint(100, 0, 100);
		}
		
		public override function update():void
		{
			if (followTarget != null)
			{
				var targetPoint:FlxPoint = FlxPoint.addVector(
					new FlxPoint(
						followTarget.x,
						followTarget.y,
						followTarget.z),
					followDist);
					
				moveToward(targetPoint);
					
			}
			
				
			if (FlxG.keys.W)
			{
				followDist.y += FlxG.elapsed * scrollSpeed.y;
			}
			
			if (FlxG.keys.S)
			{
				followDist.y -= FlxG.elapsed * scrollSpeed.y;
			}
			
			if (FlxG.keys.A)
			{
				followDist.x -= FlxG.elapsed * scrollSpeed.x;
			}
			
			if (FlxG.keys.D)
			{
				followDist.x += FlxG.elapsed * scrollSpeed.x;
			}
			
			if (FlxG.keys.U)
			{
				focalLength -= FlxG.elapsed * scrollSpeed.z;
			}
			
			if (FlxG.keys.I)
			{
				focalLength += FlxG.elapsed * scrollSpeed.z;
			}
	
			
		
		}
		
		private function moveToward(point:FlxPoint):void
		{
			if (Math.abs(position.x - point.x) > deadDist.x)
			{
				if (position.x < point.x)
				{
					position.x = Math.min(point.x, position.x + FlxG.elapsed * followSpeed.x);
				}
				if (position.x > point.x)
				{
					position.x = Math.max(point.x,position. x - FlxG.elapsed * followSpeed.x);
				}
			}
			
			if (Math.abs(position.y - point.y) > deadDist.y)
			{
				if (position.y < point.y)
				{
					position.y = Math.min(point.y, position.y + FlxG.elapsed * followSpeed.y);
				}
				if (position.y > point.y)
				{
					position.y = Math.max(point.y, position.y - FlxG.elapsed * followSpeed.y);
				}
			}
			
			
			if (Math.abs(position.z - point.z) > deadDist.z)
			{
				if (position.z < point.z)
				{
					position.z = Math.min(point.z, position.z + FlxG.elapsed * followSpeed.z);
				}
				if (position.z > point.z)
				{
					position.z = Math.max(point.z, position.z - FlxG.elapsed * followSpeed.z);
				}
			}
			
			 if (position.x == point.x
				&& position.y == point.y
				&& position.z == point.z)
			{
				if (reachTargetCallback != null)
				{
					reachTargetCallback();
				}
			}
		}
		
		
		
		public function startScan(object:GameObject):void
		{
			var oldTarget:GameObject = followTarget;
			var oldFollowDist:FlxPoint = followDist;
			followTarget = object;
			
			var xBuffer:int = 20;
			var desiredZ:Number = -(object.width * object.scale.x * focalLength) / (viewWidth - xBuffer);
			followDist = new FlxPoint(object.x, object.y - object.height * object.scale.y + 20, desiredZ);
			followSpeed.y = 100;
			deadDist = new FlxPoint();
			
			reachTargetCallback = function():void 
			{ 
				init();
				followTarget = oldTarget; 
				followDist = oldFollowDist;
			}
		}
	}
	
}