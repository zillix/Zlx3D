package wander
{
	import flash.geom.Point;
	import org.flixel.*;
	import wander.utils.ZMath;
	/**
	 * Implementation of the FlxCamera.
	 * Supports Z values, and several of the FlxCamera utilities in 3D (shake, etc).
	 * Also contains functionality to follow a target through 3D space.
	 * @author zillix
	 */
	public class Camera3D extends FlxCamera 
	{
		public var focalLength:int = 200;
		public var fieldOfView:int;
		public var ratio:Number;
		public var z:Number;
		
		public var viewHeight:Number;
		public var viewWidth:Number;
		
		public var position:Point3D;
		
		// Used for following an object.
		public var followDist:Point3D;
		public var followTarget:Sprite3D;
		public var followSpeed:Point3D;
		
		public var scrollSpeed:Point3D;
		
		// Used to pull the camera back when the follow target moves towards the camera.
		protected var _followTimeReversed:Number = 0;
		public static const PULL_BACK_REVERSE_TIME:Number = 0.5;
		public static const PULL_BACK_REVERSE_VALUE:Number = 1.8;
		
		// Dimensions where the camera won't try to follow the player.
		public var deadDist:Point3D;
		
		// Called when the camera reaches the target.
		public var reachTargetCallback:Function;
		
		public function Camera3D(X:int,Y:int,Width:int,Height:int,Zoom:Number=0)
		{
			init();
		
			position = new Point3D();
			ratio = FlxG.height / FlxG.width;
			z = 0;
			
			super(X, Y, Width, Height, Zoom);
			
			viewHeight = FlxG.height;
			viewWidth = ratio * viewHeight;
		}
		
		public function init():void
		{
			scrollSpeed = new Point3D(150, 100, 100);
			followSpeed = new Point3D(300, 300, 500);
			deadDist = new Point3D(50, 0, 100);
		}
		
		public override function update():void
		{
			if (followTarget != null)
			{
				if (Point3D(followTarget.velocity).z < 0)
				{
					_followTimeReversed += FlxG.elapsed;
				}
				else
				{
					_followTimeReversed = 0;
				}
				
				// If the follow target has been reversing for enough time,
				//		pull back the camera for a better view.
				var followZ:Number = followDist.z;
				if (_followTimeReversed > PULL_BACK_REVERSE_TIME)
				{
					followZ *= PULL_BACK_REVERSE_VALUE;
				}
				
				var targetPoint:Point3D = Point3D.addVector(
					new Point3D(
						followTarget.x,
						followTarget.y,
						followTarget.z),
					new Point3D(
						followDist.x,
						followDist.y, 
						followZ));
					
				moveToward(targetPoint);
					
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
		
		private function moveToward(point:Point3D):void
		{
			if (Math.abs(position.x - point.x) > deadDist.x)
			{
				if (position.x < point.x)
				{
					position.x = Math.min(point.x - deadDist.x, position.x + FlxG.elapsed * followSpeed.x);
				}
				if (position.x > point.x)
				{
					position.x = Math.max(point.x + deadDist.x,position. x - FlxG.elapsed * followSpeed.x);
				}
			}
			
			if (Math.abs(position.y - point.y) > deadDist.y)
			{
				if (position.y < point.y)
				{
					position.y = Math.min(point.y - deadDist.y, position.y + FlxG.elapsed * followSpeed.y);
				}
				if (position.y > point.y)
				{
					position.y = Math.max(point.y + deadDist.y, position.y - FlxG.elapsed * followSpeed.y);
				}
			}
			
			
			if (Math.abs(position.z - point.z) > deadDist.z)
			{
				if (position.z < point.z)
				{
					position.z = Math.min(point.z - deadDist.z, position.z + FlxG.elapsed * followSpeed.z);
				}
				if (position.z > point.z)
				{
					position.z = Math.max(point.z + deadDist.z, position.z - FlxG.elapsed * followSpeed.z);
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
		
		override public function fill(Color:uint,BlendAlpha:Boolean=true):void
		{
			// Never blend the alpha
			super.fill(Color, false);
		}
	}
	
}