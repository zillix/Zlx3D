package wander
{
	
	/**
	 * ...
	 * @author zillix
	 */
	
	import org.flixel.*;
	public class Player extends ZlxSprite 
	{
		private static const WALK_SPEED:int = 190;
		private static const JUMP_SPEED:int = 400;
		
		
		public static const HEIGHT:int = 50;
		
		public static const AUTOGRAB_SPEED:Number = 100;
		
		
		public static const CLIMB_SPEED:int = 150;
		
		// TODO(alex): Move climbing functionalty to GameObject
		public var touchedObject:Object;
		public var isClimbing:Boolean = false;
		
		public var timeReversed:Number = 0;
		
		private var _jumped:Boolean = false;
		
		
		public function Player(X:int = 0, Y:int = 0, Z:int = 0)
		{
			super(X, Y, Z);
			makeGraphic(HEIGHT, HEIGHT, 0xffffff00);
			immovable = false;
		}
		
		public function resetTouchedObject():void
		{
			if (!isClimbing)
			{
				touchedObject = null;
			}
		}
		
		public function setTouchedObject(obj:ZlxSprite):void
		{
			if (!isClimbing)
			{
				touchedObject = obj;
			}
		}
		
		public override function update():void
		{
			// TODO(alex): This should be tracked by the camera
			if (ZlxPoint(velocity).z < 0)
			{
				timeReversed += FlxG.elapsed;
			}
			else
			{
				timeReversed = 0;
			}
			
			super.update();
			
			if ((velocity.y > AUTOGRAB_SPEED || FlxG.keys.UP) && touchedObject != null) // && couldClimb)
			{
				isClimbing = true;
			}
			
			
			if (velocity.y > 0
				&& y + velocity.y * FlxG.elapsed > Zlx3DConfig.GROUND_HEIGHT)
			{
				isClimbing = false;
				_jumped = false;
				acceleration.y = 0;
				velocity.y = 0;
				y = Zlx3DConfig.GROUND_HEIGHT;
			}
			if (!isClimbing && y < 0)
			{
				acceleration.y = Zlx3DConfig.GRAVITY;
			}
			
			if (isClimbing)
			{
				_jumped = false;
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
			else if ((y == Zlx3DConfig.GROUND_HEIGHT || (//!couldClimb && 
				!touchedObject)))
			{
				if (FlxG.keys.UP)
				{
					ZlxPoint(velocity).z = WALK_SPEED;
				}
				else if (FlxG.keys.DOWN)
				{
					ZlxPoint(velocity).z = -WALK_SPEED;
				}
				else
				{
					ZlxPoint(velocity).z = 0;
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
			
			if (FlxG.keys.justPressed("SPACE"))
			{
				if (!_jumped)
				{
					_jumped = true;
					isClimbing = false;
					velocity.y = -JUMP_SPEED;
				}
			}
		}
	}
	
}