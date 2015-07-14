package wander.demos
{
	import wander.Climbable;
	import wander.Tilemap3D;
	import wander.utils.*;
	import org.flixel.*;
	import wander.Sprite3D;
	/**
	 * Demo class to show off the climbing functionality.
	 * Spawns a climbable wall, and some decorations.
	 * @author zillix
	 */
	public class ClimbDemo extends Zlx3DDemo
	{
		[Embed(source = "data/climbDemoMap.png")]	public var MapImage:Class;
		
		[Embed(source = "data/bigarch.png")]	public var BigArchSprite:Class;
		[Embed(source = "data/climbMapBigArch.png")]	public var BigArchClimbMap:Class;
	
		[Embed(source = "data/butte.png")]	public var ButteSprite:Class;
		[Embed(source = "data/climbMapButte.png")]	public var ButteClimbMap:Class;
	
		[Embed(source = "data/gigolem.png")]	public var GigolemSprite:Class;
		[Embed(source = "data/climbMapGigolem.png")]	public var GigolemClimbMap:Class;
		
		[Embed(source = "data/shrine.png")]	public var ShrineSprite:Class;
		[Embed(source = "data/climbMapShrine.png")]	public var ShrineClimbMap:Class;
	
		[Embed(source = "data/sillyRock.png")]	public var SillyRockSprite:Class;
		[Embed(source = "data/climbMapSillyRock.png")]	public var SillyRockClimbMap:Class;
	
		
		public function ClimbDemo()
		{
			super();
			loadMapImage(MapImage);
		}
		
		override public function update() : void
		{
			super.update();
			
				
			_player.resetTouchedObject();
			
			// NOTE(alex):
			// I would normally use ZlxSprite.collide here.
			// However, we don't want to collide a grounded player
			// with a part of a climbable object blocked by a climbmap,
			// such as in the gap between an arch.
			Sprite3D.overlap(_player, _objects, onPlayerTouchObject, separateClimbZ);
			
			
			if (DemoClimbingPlayer(_player).isClimbing && 
				(_player.touchedObject is Climbable))
			{
				Z3D.climbOverlap(_player, (_player.touchedObject as Climbable).unclimbableMap, FlxObject.separate);
			}
			
			if (FlxG.keys.justPressed("Z"))
			{
				DemoTilemap3D.tilemapsVisible = !DemoTilemap3D.tilemapsVisible;
			}
		}
		
		private function separateClimbZ(Object1:Sprite3D, Object2:Sprite3D):Boolean
		{
				if (Object1 is DemoPlayer
					&& Object2 is Climbable)
				{
					var climbable:Climbable = Object2 as Climbable;
					// If a grounded player touches a climbable
					// doesn't touch part of the climbable region
					// (such as a gap between the arch),
					// we don't want to z-collide that player.
					if (!Z3D.climbOverlap(Object1, 
											climbable.climbableMap,
											function(object1 : Sprite3D, tileMap : Tilemap3D):Boolean {
												return tileMap.overlaps(object1);
											}
										)
						)
					{
						return false;
					}
				}
				
				return Sprite3D.separateZ(Object1, Object2);
		}
		
		override protected function initPlayer() : DemoPlayer
		{
			return new DemoClimbingPlayer();
		}
		
		private function onPlayerTouchObject(src:DemoPlayer, hit:Sprite3D):void
		{
			if (hit is Climbable)
			{
				if (!Z3D.climbOverlap(src, (hit as Climbable).unclimbableMap, FlxObject.separate))
				{
					src.setTouchedObject(hit);
				}
			}
		}
		
		private static const SILLY_ROCK:uint = 0x1EDA02; // 30,218,2 (green)
		private static const GIGOLEM:uint = 0x572F17; // 87 47 23 (brown)
		private static const BUTTE:uint = 0x1B02DA; // 27 2 218 (blue)
		private static const SHRINE:uint = 0x4DFDFC; // 77 253 252 (cyan)
		private static const ARCH:uint = 0xDA0205; // 218 2 5 (red)
		override protected function handleMapPixelColor(color:uint, xPos:int, zPos:int) : FlxObject
		{
			var climbMapClass:Class;
			var spriteClass:Class;
			var scale:int = 20;
			switch(color)
			{

				case SILLY_ROCK:
					climbMapClass = SillyRockClimbMap;
					spriteClass = SillyRockSprite;
					break;
					
				case GIGOLEM:
					climbMapClass = GigolemClimbMap;
					spriteClass = GigolemSprite;
					break;
					
				case BUTTE:
					climbMapClass = ButteClimbMap;
					spriteClass = ButteSprite;
					break;
					
				case ARCH:
					climbMapClass = BigArchClimbMap;
					spriteClass = BigArchSprite;
					break;
					
				case SHRINE:
					climbMapClass = ShrineClimbMap;
					spriteClass = ShrineSprite;
					break;
			}
			
			if (climbMapClass == null || spriteClass == null)
			{
				return null;
			}
			
			return new DemoClimbable(xPos, 0, zPos, _objects, spriteClass, climbMapClass);
		}
		
		override protected function getInstructionsText() : String
		{
			return super.getInstructionsText() +
			"\nZ: Toggle climb maps" +
			"\nUP: Start climbing";
			
		}
	}
	
}