package wander.demos 
{
	import wander.*;
	import wander.utils.*;
	
	/**
	 * Example implementation of a player class that can climb.
	 * @author zillix
	 */
	
	import org.flixel.*;
	public class DemoClimbingPlayer extends DemoPlayer 
	{
		public static const AUTOGRAB_SPEED:Number = 100;
		public static const CLIMB_SPEED:int = 150;
		
		protected var _isClimbing:Boolean = false;
		
		public function DemoClimbingPlayer(X:int = 0, Y:int = 0, Z:int = 0)
		{
			super(X, Y, Z);
		}
		
		override public function resetTouchedObject():void
		{
			if (!_isClimbing)
			{
				_touchedObject = null;
			}
		}
		
		override public function setTouchedObject(obj:Sprite3D):void
		{
			if (!_isClimbing)
			{
				_touchedObject = obj;
			}
		}
		
		override public function update():void
		{
			// Start climbing
			if ((FlxG.keys.pressed(upKey) 
					||velocity.y > AUTOGRAB_SPEED) // If falling fast enough, grab onto anything possible.
				&& _touchedObject != null)
			{
				_isClimbing = true;
			}
			
			// Start falling if we aren't climbing
			if (!_isClimbing && y < 0)
			{
				acceleration.y = Z3DConfig.GRAVITY;
			}
			
			if (_isClimbing)
			{
				_jumped = false;
				acceleration.y = 0;
			}
			
			super.update();
		}
		
		override protected function onHitGround() : void
		{
			super.onHitGround();
			_isClimbing = false;
		}
		
		override protected function handleUpDown() : void
		{
			// If climbing, we can move in the Y axis with up/down.
			// Otherwise, we move in the Z axis.
			if (_isClimbing)
			{
				if (FlxG.keys.pressed(upKey))
				{
					velocity.y = -CLIMB_SPEED;
				}
				else if (FlxG.keys.pressed(downKey))
				{
					velocity.y = CLIMB_SPEED;
				}
				else
				{
					velocity.y = 0;
				}
			}
			// Can't move in the Z direction when off the ground and touching (but not climbing) something.
			else if (y == Z3DConfig.GROUND_HEIGHT || !_touchedObject) 
			{
				super.handleUpDown();
			}
		}
		
		override protected function handleJump() : void
		{
			if (FlxG.keys.justPressed(jumpKey))
			{
				if (!_jumped)
				{
					_jumped = true;
					_isClimbing = false;
					velocity.y = -DemoPlayer.JUMP_SPEED;
				}
			}
		}
		
		public function get isClimbing() : Boolean
		{
			return _isClimbing;
		}
	}
}