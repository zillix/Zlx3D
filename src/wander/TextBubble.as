package wander 
{
	import flash.geom.Point;
	import wander.GameObject;
	import org.flixel.*;
	
	
	/**
	 * ...
	 * @author zillix
	 */
	
	public class TextBubble extends Animation3D 
	{
		public var background:GameObject;
		public var parent:GameObject;
		public var parentOffsets:FlxPoint;
		public var text3D:Text3D;
		
		public function TextBubble(X:Number = 0, Y:Number = 0, Z:Number = 0, txt:String = "", par:GameObject = null)
		{
			super();
			parent = par;
			parentOffsets = new FlxPoint(X - parent.x, Y - parent.y, Z - parent.z);
			background = new GameObject(X, Y, Z);
			background.makeGraphic(100, 50, 0xff999999);
			background.scales = false;
			
			text3D = new Text3D(X, Y, Z, 100, txt, true, false);
			
			PlayState.instance.objects.add(background);
			
			PlayState.instance.texts.add(text3D);
		}
		
		public override function update():void
		{
			super.update();
			if (parent)
			{
				background.moveTowards(new FlxPoint(parent.x - parentOffsets.x, parent.y - parentOffsets.y, parent.z - parentOffsets.z), 100, 1);
			}
			
			if (background.alive == false)
			{
				alive = false;
			}
		}
		
		public function cleanUp():void
		{
			background.alive = false;
		}
		
	}
	
}