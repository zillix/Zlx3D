package wander.demos
{
	import wander.Climbable;
	import wander.utils.*;
	import org.flixel.*;
	/**
	 * ...
	 * @author ...
	 */
	public class ClimbDemo extends Zlx3DDemo
	{
		public function ClimbDemo()
		{
			
		}
		
		override public function update() : void
		{
			super.update();
			
			if (_player.isClimbing && (_player.touchedObject is Climbable))
			{
				Z3DUtils.climbOverlap(_player, (_player.touchedObject as Climbable), FlxObject.separate);
			}
		}
	}
	
}