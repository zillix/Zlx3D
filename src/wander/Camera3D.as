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
		private var scrollSpeed:ZlxPoint;
		
		public var focalLength:int = 200;
		public var fieldOfView:int;
		public var ratio:Number;
		public var z:Number;
		
		public var viewHeight:Number;
		public var viewWidth:Number;
		
		public var position:ZlxPoint;
		
		public var followDist:ZlxPoint;
		public var followTarget:GameObject;
		public var followSpeed:ZlxPoint;
		
		public var deadDist:ZlxPoint;
		
		public var reachTargetCallback:Function;
		
		public function Camera3D(X:int,Y:int,Width:int,Height:int,Zoom:Number=0)
		{
			init();
		
			position = new ZlxPoint();
			ratio = FlxG.height / FlxG.width;
			z = 0;
			
			super(X, Y, Width, Height, Zoom);
			
			viewHeight = FlxG.height;
			viewWidth = ratio * viewHeight;
		}
		
		public function init():void
		{
			scrollSpeed = new ZlxPoint(100, 100, 100);
			followSpeed = new ZlxPoint(300, 300, 500);
			deadDist = new ZlxPoint(100, 0, 100);
		}
		
		public static var TIME_REVERSED:Number = 0.5;
		public override function update():void
		{
			if (followTarget != null)
			{
				var followZ:Number = followDist.z;
				if ((followTarget is Player) &&
				(followTarget as Player).timeReversed > TIME_REVERSED)
				{
					followZ *= 1.8;
				}
				
				var targetPoint:ZlxPoint = ZlxPoint.addVector(
					new ZlxPoint(
						followTarget.x,
						followTarget.y,
						followTarget.z),
					new ZlxPoint(
						followDist.x,
						followDist.y, 
						followZ));
					
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
			
				
			//Update the "flash" special effect
			if(_fxFlashAlpha > 0.0)
			{
				_fxFlashAlpha -= FlxG.elapsed/_fxFlashDuration;
				if((_fxFlashAlpha <= 0) && (_fxFlashComplete != null))
					_fxFlashComplete();
			}
			
			//Update the "fade" special effect
			if((_fxFadeAlpha > 0.0) && (_fxFadeAlpha < 1.0))
			{
				_fxFadeAlpha += FlxG.elapsed/_fxFadeDuration;
				if(_fxFadeAlpha >= 1.0)
				{
					if(_fxFadeComplete != null)
						_fxFadeComplete();
						
					//_fxFadeAlpha = 0.0;
					
				}
			}
			
			//Update the "shake" special effect
			if(_fxShakeDuration > 0)
			{
				_fxShakeDuration -= FlxG.elapsed;
				if(_fxShakeDuration <= 0)
				{
					_fxShakeOffset.make();
					if(_fxShakeComplete != null)
						_fxShakeComplete();
				}
				else
				{
					if((_fxShakeDirection == SHAKE_BOTH_AXES) || (_fxShakeDirection == SHAKE_HORIZONTAL_ONLY))
						_fxShakeOffset.x = (FlxG.random()*_fxShakeIntensity*width*2-_fxShakeIntensity*width)*_zoom;
					if((_fxShakeDirection == SHAKE_BOTH_AXES) || (_fxShakeDirection == SHAKE_VERTICAL_ONLY))
						_fxShakeOffset.y = (FlxG.random()*_fxShakeIntensity*height*2-_fxShakeIntensity*height)*_zoom;
				}
			}
	
			
		
		}
		
		private function moveToward(point:ZlxPoint):void
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
					reachTargetCallback = null;
				}
			}
		}
		
		
		
		public function startScan(object:GameObject):void
		{
			var oldTarget:GameObject = followTarget;
			var oldFollowDist:ZlxPoint = followDist;
			followTarget = object;
			
			var xBuffer:int = 20;
			var desiredZ:Number = -(object.width * object.scale.x * focalLength) / (FlxG.width - xBuffer);
			followDist = new ZlxPoint(object.x, object.y - object.height * object.scale.y + 20, desiredZ);
			followSpeed.y = 150;
			deadDist = new ZlxPoint();
			
			reachTargetCallback = function():void 
			{ 
				init();
				followTarget = oldTarget; 
				followDist = oldFollowDist;
			}
		}
		
			public function idleScan(object:GameObject):void
		{
			var oldTarget:GameObject = followTarget;
			var oldFollowDist:ZlxPoint = followDist;
			followTarget = object;
			
			var xBuffer:int = 20;
			var desiredZ:Number = -(object.width * object.scale.x * focalLength) / (FlxG.width - xBuffer);
			followDist = new ZlxPoint(0, object.y - object.height * object.scale.y + 20, desiredZ);
			followSpeed.y = 100;
			deadDist = new ZlxPoint();
			
			reachTargetCallback = function():void 
			{ 
				init();
				followTarget = oldTarget; 
				followDist = oldFollowDist;
			}
		}
		
		public function endScan(object:GameObject, callback:Function = null):void
		{
			var oldTarget:GameObject = followTarget;
			var oldFollowDist:FlxPoint = followDist;
			followTarget = object;
			
			var xBuffer:int = 2;
			var desiredZ:Number = -(object.width * object.scale.x * focalLength) / (FlxG.width - xBuffer);
			followDist = new ZlxPoint(0, object.y - object.height * object.scale.y / 2, desiredZ);
			followSpeed.y = 100;
			deadDist = new ZlxPoint();
			
			reachTargetCallback = callback;
		}
		
		override public function fill(Color:uint,BlendAlpha:Boolean=true):void
		{
			// Never blend the alpha
			super.fill(Color, false);
		}
	}
	
}