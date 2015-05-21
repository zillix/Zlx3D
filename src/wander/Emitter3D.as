package wander
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author 
	 */
	public class Emitter3D extends FlxEmitter{
	public var _ownLifespawn:Number = 0;
	
	public var life:Number = 0;
	public var z:Number;
		public function Emitter3D(X:Number = 0, Y:Number = 0, Z:Number = 0,Size:Number = 0)
		{
			super(X, Y, Size);
			z = Z;
		}
		
		public function beginEmit(Explode:Boolean = true, Lifespan:Number = 0, Frequency:Number = 0.1, Quantity:uint = 0, ownLifespawn:Number = 0):void
		{
			super.start(Explode, Lifespan, Frequency, Quantity);
			_ownLifespawn = ownLifespawn;
		}
		
		public override function update():void
		{
			super.update();
			_ownLifespawn -= FlxG.elapsed;
			if (_ownLifespawn <= 0)
			{
				on = false;
			}
			
			life += FlxG.elapsed;
			
			if (int( life) % 2 == 0)
			{
				var alive:Boolean = false;
				for each (var obj:FlxSprite in this.members)
				{
					if (obj.alive)
					{
						alive = true;
						break;
					}
				}
				
				if (!alive)
				{
					cleanup();
				}
			}
		}
		
		override public function emitParticle():void
		{
			var particle:Particle3D = recycle(FlxParticle) as Particle3D;
			if (!particle)
			{
				return;
			}
			
			particle.lifespan = lifespan;
			particle.elasticity = bounce;
			particle.reset3D(x - (particle.width>>1) + FlxG.random()*width, y - (particle.height>>1) + FlxG.random()*height, z);
			particle.visible = true;
			
			if(minParticleSpeed.x != maxParticleSpeed.x)
				particle.velocity.x = minParticleSpeed.x + FlxG.random()*(maxParticleSpeed.x-minParticleSpeed.x);
			else
				particle.velocity.x = minParticleSpeed.x;
			if(minParticleSpeed.y != maxParticleSpeed.y)
				particle.velocity.y = minParticleSpeed.y + FlxG.random()*(maxParticleSpeed.y-minParticleSpeed.y);
			else
				particle.velocity.y = minParticleSpeed.y;
			particle.acceleration.y = gravity;
			
			if(minRotation != maxRotation)
				particle.angularVelocity = minRotation + FlxG.random()*(maxRotation-minRotation);
			else
				particle.angularVelocity = minRotation;
			if(particle.angularVelocity != 0)
				particle.angle = FlxG.random()*360-180;
			
			particle.drag.x = particleDrag.x;
			particle.drag.y = particleDrag.y;
			particle.onEmit();
		}
		
		public function cleanup():void
		{
			kill();
		}

	}
		
	
}