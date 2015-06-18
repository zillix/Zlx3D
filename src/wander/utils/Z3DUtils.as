package wander.utils 
{
	import flash.geom.Rectangle;
	import org.flixel.*;
	import org.flixel.system.*;
	import wander.Camera3D;
	import wander.Climbable;
	import wander.GameObject;
	import wander.Tilemap3D;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Z3DUtils 
	{
		
		public static function climbOverlap(object1:FlxSprite = null, climbable:Climbable = null, NotifyCallback:Function = null, ProcessCallback:Function = null):Boolean
		{
			FlxQuadTree.divisions = FlxG.worldDivisions;
			var tilemap:Tilemap3D = climbable.tileMap;
			tilemap.x -= tilemap.offset.x;
			tilemap.y -= tilemap.offset.y;
			tilemap.last.x = tilemap.x;
			tilemap.last.y = tilemap.y;
			
			object1.x -= object1.offset.x;
			object1.y -= object1.offset.y;
			object1.last.x -= object1.offset.x;
			object1.last.y -= object1.offset.y;
			
			var saveScale:FlxPoint = object1.scale;
		//	object1.scale = new FlxPoint(.5, .5);
			//var quadTree:FlxQuadTree = new FlxQuadTree(tilemap.x - tilemap.width,tilemap.y - tilemap.height * 2,tilemap.width * 4,tilemap.height * 4);
			var result:Boolean = NotifyCallback(object1, tilemap);
			object1.scale = saveScale;
		//	quadTree.load(object1,tilemap,NotifyCallback,ProcessCallback);
		//	var result:Boolean = quadTree.execute();
			tilemap.x += tilemap.offset.x;
			tilemap.y += tilemap.offset.y;
			tilemap.last.x = tilemap.x;
			tilemap.last.y = tilemap.y;
			object1.x += object1.offset.x;
			object1.y += object1.offset.y;
			object1.last.x += object1.offset.x;
			object1.last.y += object1.offset.y;
			
			//quadTree.destroy();
			return result;
		}
		
		/*public static function climbOverlap2(object1:FlxSprite = null, climbable:Climbable = null):Boolean
		{
			if (climbable == null)
			{
				return false;
			}
			
			var tilemap:Tilemap3D = climbable.tileMap;
			tilemap.x -= tilemap.offset.x;
			tilemap.y -= tilemap.offset.y;
			tilemap.last.x = tilemap.x;
			tilemap.last.y = tilemap.y;
			
			
			object1.x -= object1.offset.x;
			object1.y -= object1.offset.y;
			object1.last.x -= object1.offset.x;
			object1.last.y -= object1.offset.y;
			
				var saveScale:FlxPoint = object1.scale;
			object1.scale = new FlxPoint(.5, .5);
			
			var result:Boolean = tilemap.overlapsWithCallback(object1);
		
			object1.scale = saveScale;
			
			tilemap.x += tilemap.offset.x;
			tilemap.y += tilemap.offset.y;
			tilemap.last.x = tilemap.x;
			tilemap.last.y = tilemap.y;
			object1.x += object1.offset.x;
			object1.y += object1.offset.y;
			object1.last.x += object1.offset.x;
			object1.last.y += object1.offset.y;
			
			//quadTree.destroy();
			return result;
		}*/
		
		public static function fitObjectInsideBounds(gameObject:GameObject, bounds:Rectangle):void
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