package wander
{
	import flash.media.Camera;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author zillix
	 */
	public class Particle3D extends GameObject 
	{
		// I've reimplemented the FlxParticle code, since it is more straightforward than reimplementing the 3D code in GameObject.
		public var lifespan:Number;
		public var friction:Number;
		public var scales:Boolean = true;
		
		public static var BLOOD:uint = 0xffff00000;
		public static var GENERIC:uint = 0xff888888;
		public static var SAND:uint = 0xffF0E68C;
		public static var YELLOW:uint = 0xffFfff00;
		
		public function Particle3D(c:uint = 0xffff0000)
		{
			super();
			makeGraphic(8, 8, c);
			
			lifespan = 0;
			friction = 500;
		}
		
		override public function update():void
		{
			if (y > PlayState.GROUND_HEIGHT)
			{
				kill();
			}
			
			//lifespan behavior
			if(lifespan <= 0)
				return;
			lifespan -= FlxG.elapsed;
			if(lifespan <= 0)
				kill();
			
			//simpler bounce/spin behavior for now
			if(touching)
			{
				if(angularVelocity != 0)
					angularVelocity = -angularVelocity;
			}
			if(acceleration.y > 0) //special behavior for particles with gravity
			{
				if(touching & FLOOR)
				{
					drag.x = friction;
					
					if(!(wasTouching & FLOOR))
					{
						if(velocity.y < -elasticity*10)
						{
							if(angularVelocity != 0)
								angularVelocity *= -elasticity;
						}
						else
						{
							velocity.y = 0;
							angularVelocity = 0;
						}
					}
				}
				else
					drag.x = 0;
			}
		}
		
		public function onEmit():void
		{
		}
		
		
		
		
		public function reset3D(X:Number,Y:Number,Z:Number):void
		{
			z = Z;
			ZlxPoint(velocity).z = 0;
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