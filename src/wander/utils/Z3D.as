package wander.utils 
{
	import flash.geom.Rectangle;
	import org.flixel.*;
	import org.flixel.system.*;
	import wander.Camera3D;
	import wander.Climbable;
	import wander.Sprite3D;
	import wander.Tilemap3D;
	
	/**
	 * Various 3D utility functions needed by Zlx3D.
	 * @author zillix
	 */
	public class Z3D 
	{
		
		public static function climbOverlap(object1:FlxSprite = null, climbable:Climbable = null, NotifyCallback:Function = null, ProcessCallback:Function = null):Boolean
		{
			var tilemap:Tilemap3D = climbable.climbMap;
			tilemap.x -= tilemap.offset.x;
			tilemap.y -= tilemap.offset.y;
			tilemap.last.x = tilemap.x;
			tilemap.last.y = tilemap.y;
			
			object1.x -= object1.offset.x;
			object1.y -= object1.offset.y;
			object1.last.x -= object1.offset.x;
			object1.last.y -= object1.offset.y;
			
			var saveScale:FlxPoint = object1.scale;
			var result:Boolean = NotifyCallback(object1, tilemap);
			object1.scale = saveScale;
			tilemap.x += tilemap.offset.x;
			tilemap.y += tilemap.offset.y;
			tilemap.last.x = tilemap.x;
			tilemap.last.y = tilemap.y;
			object1.x += object1.offset.x;
			object1.y += object1.offset.y;
			object1.last.x += object1.offset.x;
			object1.last.y += object1.offset.y;
			
			return result;
		}
		
		public static function fitObjectInsideBounds(gameObject:Sprite3D, bounds:Rectangle):void
		{
			var direction:int = 0;
			if (gameObject.x < bounds.x)
			{
				direction = 1;
				gameObject.x = bounds.x;
			}
			if (gameObject.x > bounds.x + bounds.width)
			{
				direction = -1;
				gameObject.x = bounds.x + bounds.width;
			}
			
			if (gameObject.z < bounds.y)
			{
				direction = gameObject.facing == FlxObject.LEFT ? 1 : -1;
				gameObject.z = bounds.y;
			}
			if (gameObject.z > bounds.y + bounds.height)
			{
				direction = gameObject.facing == FlxObject.LEFT ? 1 : -1;
				gameObject.z = bounds.y + bounds.height;
			}
		}
		
		
		
		public static function get camera():Camera3D
		{
			return FlxG.camera as Camera3D;
		}
		
	}

}