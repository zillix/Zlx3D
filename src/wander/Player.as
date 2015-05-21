package wander
{
	
	/**
	 * ...
	 * @author zillix
	 */
	
	import org.flixel.*;
	public class Player extends GameObject 
	{
		private static var WALK_SPEED:int = 300;
		private static const JUMP_SPEED:int = 20;
		private static const GRAVITY:int = 1000;
		public var GROUND_HEIGHT:int = 0;
		
		public static const HEIGHT:int = 50;
		
		public static const CLIMB_SPEED:int = 150;
		
		public var touchedObject:Object;
		public var isClimbing:Boolean = false;
		
		public function Player(X:int = 0, Y:int = 0, Z:int = 0)
		{
			super(X, Y, Z);
			makeGraphic(HEIGHT, HEIGHT, 0xffffff00);
			setOffsets();
			immovable = false;
			//acceleration.y = GRAVITY;
		}
		
		public function resetTouchedObject():void
		{
			if (!isClimbing)
			{
				touchedObject = null;
			}
		}
		
		public function setTouchedObject(obj:GameObject):void
		{
			if (!isClimbing)
			{
				touchedObject = obj;
			}
		}
		
		public override function update():void
		{
			super.update();
			
			if (FlxG.keys.justPressed("SPACE") && touchedObject != null)
			{
				isClimbing = !isClimbing;
				//WALK_SPEED *= 2;
			}
			
			
			
			
			if (velocity.y > 0
				&& y + velocity.y * FlxG.elapsed > GROUND_HEIGHT)
			{
				acceleration.y = 0;
				velocity.y = 0;
				y = GROUND_HEIGHT;
			}
			if (!isClimbing && y < 0)
			{
				acceleration.y = GRAVITY;
			}
			
			if (isClimbing)
			{
				acceleration.y = 0;
			}
			
			
			/*if (y < 0)
			{
				y = 0;
				velocity.y = 0;
			}*/
			
			if (FlxG.keys.LEFT)
			{
				velocity.x = -WALK_SPEED;
			}
			else if (FlxG.keys.RIGHT)
			{
				velocity.x = WALK_SPEED;
			}
			else
			{
				velocity.x = 0;
			}
			
			if (isClimbing)
			{
				if (FlxG.keys.UP)
				{
					velocity.y = -CLIMB_SPEED;
				}
				else if (FlxG.keys.DOWN)
				{
					velocity.y = CLIMB_SPEED;
				}
				else
				{
					velocity.y = 0;
				}
			}
			else
			{
				if (FlxG.keys.UP)
				{
					velocity.z = WALK_SPEED;
				}
				else if (FlxG.keys.DOWN)
				{
					velocity.z = -WALK_SPEED;
				}
				else
				{
					velocity.z = 0;
				}
			}
			
			if (FlxG.keys.Q)
			{
				velocity.y = -CLIMB_SPEED;
			}
			else if (FlxG.keys.E)
			{
				velocity.y = CLIMB_SPEED;
			}
			else
			{
				//velocity.y = 0;
			}
			
		/*	if (FlxG.keys.SPACE && velocity.y == 0)
			{
				velocity.y = -JUMP_SPEED;
			}*/
		}
	}
	
}