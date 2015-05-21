package wander
{
	import flash.media.Camera;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author zillix
	 */
	public class Particle3D extends FlxParticle 
	{
		public var z:Number = 0;
		
		public static var BLOOD:uint = 0xffff00000;
		public static var GENERIC:uint = 0xff888888;
		public static var SAND:uint = 0xffF0E68C;
		public static var YELLOW:uint = 0xffFfff00;
		
		public function Particle3D(c:uint = 0xffff0000)
		{
			super();
			makeGraphic(8, 8, c);
		}
		public var scales:Boolean = true;
		
		override public function update():void
		{
			if (y > PlayState.GROUND_HEIGHT)
			{
				kill();
			}
		}
		
		override public function draw():void
		{
			if(_flickerTimer != 0)
			{
				_flicker = !_flicker;
				if(_flicker)
					return;
			}
			
			if(dirty)	//rarely 
				calcFrame();
			
			//var camera:FlxCamera = FlxG.camera;
			var camera:Camera3D = PlayState.camera;
			
			if (!onScreen(camera) || !visible)
			{
				return;
			}
			
			var perspectiveScale:FlxPoint = new FlxPoint(1, 1);
			
			if (z > camera.position.z)
			{
				var zScale:Number = camera.focalLength / (z - camera.position.z);
				
				if (scales)
				{
					perspectiveScale.x = zScale;
					perspectiveScale.y = perspectiveScale.x;
				}
				
				var dX:Number = zScale * (x - camera.position.x);
				_point.x = dX - int(camera.scroll.x*scrollFactor.x) - offset.x;
				
				var dY:Number = zScale * (y - camera.position.y);
				_point.y = dY - int(camera.scroll.y * scrollFactor.y) - offset.y;
				
				_point.x += (_point.x > 0)?0.0000001:-0.0000001;
				_point.y += (_point.y > 0)?0.0000001: -0.0000001;
			
				//Advanced render
				_matrix.identity();
				_matrix.translate(-origin.x,-origin.y);
				_matrix.scale(scale.x * perspectiveScale.x,scale.y * perspectiveScale.y);
				if((angle != 0) && (_bakedRotation <= 0))
					_matrix.rotate(angle * 0.017453293);
				_matrix.translate(_point.x+origin.x,_point.y+origin.y);
				camera.buffer.draw(framePixels,_matrix,null,blend,null,antialiasing);

				if(FlxG.visualDebug && !ignoreDrawDebug)
					drawDebug(camera);
			}
		}
		
		override protected function updateMotion():void
		{
			super.updateMotion();
			var delta:Number;
			var velocityDelta:Number;

			velocityDelta = (FlxU.computeVelocity(velocity.z,acceleration.z,drag.z,maxVelocity.z) - velocity.z)/2;
			velocity.z += velocityDelta;
			delta = velocity.z*FlxG.elapsed;
			velocity.z += velocityDelta;
			z += delta;
		}
		
		public function reset3D(X:Number,Y:Number,Z:Number):void
		{
			z = Z;
			velocity.z = 0;
			super.reset(X, Y);
		}
		
		
		public override function onScreen(camera:FlxCamera = null):Boolean
		{
			var cam3D:Camera3D = camera as Camera3D;
			if (!(camera is Camera3D))
			{
				return false;
			}
			
			return z > cam3D.position.z;
			
		}
		
	}
	
}