package wander.demos 
{
	import wander.*;
	import wander.utils.*;
	
	/**
	 * Example implementation of a player class that can climb.
	 * @author zillix
	 */
	
	import org.flixel.*;
	public class DemoPlayer extends Sprite3D 
	{
		protected var upKey:String = "UP";
		protected var downKey:String = "DOWN";
		protected var leftKey:String = "LEFT";
		protected var rightKey:String = "RIGHT";
		protected var jumpKey:String = "SPACE";
		
		private static const WALK_SPEED:int = 190;
		protected static const JUMP_SPEED:int = 400;
		public static const HEIGHT:int = 50;
		
		protected var _touchedObject:Sprite3D;
		
		protected var _jumped:Boolean = false;
		
		
		public function DemoPlayer(X:int = 0, Y:int = 0, Z:int = 0)
		{
			super(X, Y, Z);
			makeGraphic(HEIGHT, HEIGHT, 0xff888888);
		
			acceleration.y = Z3DConfig.GRAVITY;
		}
		
		public function resetTouchedObject():void
		{
			_touchedObject = null;
		}
		
		public function setTouchedObject(obj:Sprite3D):void
		{
			_touchedObject = obj;
		}
		
		override public function update():void
		{
			super.update();
			
			// If falling and we hit the ground
			if (velocity.y > 0
					&& y + velocity.y * FlxG.elapsed > Z3DConfig.GROUND_HEIGHT)
			{
				onHitGround();
			}
			
			handleInput();
		}
		
		protected function onHitGround() : void
		{
			_jumped = false;
			acceleration.y = 0;
			velocity.y = 0;
			y = Z3DConfig.GROUND_HEIGHT;
		}
		
		protected function handleInput() : void
		{
			handleLeftRight();
			handleUpDown();
			handleJump();
		}
		
		protected function handleLeftRight() : void
		{
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
		}
		
		protected function handleUpDown() : void
		{
			// Z axis movement
			if (FlxG.keys.pressed(upKey))
			{
				Point3D(velocity).z = WALK_SPEED;
			}
			else if (FlxG.keys.pressed(downKey))
			{
				Point3D(velocity).z = -WALK_SPEED;
			}
			else
			{
				Point3D(velocity).z = 0;
			}
		}
		
		protected function handleJump() : void
		{
			if (FlxG.keys.justPressed(jumpKey))
			{
				if (!_jumped)
				{
					_jumped = true;
					velocity.y = -JUMP_SPEED;
					acceleration.y = Z3DConfig.GRAVITY;
				}
			}
		}
		
		public function get touchedObject() : Sprite3D
		{
			return _touchedObject;
		}
	}
}