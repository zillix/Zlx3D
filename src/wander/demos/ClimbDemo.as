package wander.demos
{
	import wander.Climbable;
	import wander.utils.*;
	import org.flixel.*;
	import wander.ZlxSprite;
	/**
	 * Demo class to show off the climbing functionality.
	 * Spawns a climbable wall, and some decorations.
	 * @author zillix
	 */
	public class ClimbDemo extends Zlx3DDemo
	{
		[Embed(source = "data/map.png")]	public var MapImage:Class;
		
		public function ClimbDemo()
		{
			super();
			loadMapImage(MapImage);
		}
		
		override public function update() : void
		{
			super.update();
			
			if (DemoClimbingPlayer(_player).isClimbing && 
				(_player.touchedObject is Climbable))
			{
				Z3D.climbOverlap(_player, (_player.touchedObject as Climbable), FlxObject.separate);
			}
		}
		
		override protected function initPlayer() : DemoPlayer
		{
			return new DemoClimbingPlayer();
		}
		
		private static const JUNK:uint = 0x1EDA02; // 30,218,2 (green)
		private static const PILLAR:uint = 0x572F17; // 87 47 23 (brown)
		private static const CLIMBABLE:uint = 0x1B02DA; // 27 2 218 (blue)
		override protected function handleMapPixelColor(color:uint, xPos:int, zPos:int) : ZlxSprite
		{
			var gameObject:ZlxSprite;
			switch(color)
			{

				case JUNK:
					gameObject = new ZlxSprite(xPos, 0, zPos);
					gameObject.makeGraphic(Math.random() * 100 + 70, Math.random() * 100 + 50, 0xff00ff00);
					gameObject.immovable = true;
					break;
					
				case PILLAR:
					gameObject = new ZlxSprite(xPos, 0, zPos);
					gameObject.makeGraphic(1000, 5000, 0xffff0000);
					gameObject.immovable = true;
					break;
					
				case CLIMBABLE:
					gameObject = new DemoClimbable(xPos, 0, zPos, _objects);
					break;
			}
			
			return gameObject;
		}
	}
	
}