package wander 
{
	import flash.geom.Point;
	import wander.ZlxSprite;
	import org.flixel.*;
	
	
	/**
	 * TODO(alex)
	 * @author zillix
	 */
	
	public class TextBubble extends FlxGroup 
	{
		public var background:ZlxSprite;
		public var parent:ZlxSprite;
		public var parentOffsets:FlxPoint;
		public var text3D:Text3D;
		
		public function TextBubble(X:Number, Y:Number, Z:Number, txt:String, parent:ZlxSprite, parentObjectLayer:FlxGroup, parentTextLayer:FlxGroup)
		{
			super();
			parent = par;
			parentOffsets = new FlxPoint(X - parent.x, Y - parent.y, Z - parent.z);
			background = new ZlxSprite(X, Y, Z);
			background.makeGraphic(100, 50, 0xff999999);
			background.scales = false;
			
			text3D = new Text3D(X, Y, Z, 100, txt, true, false);
			
			parentLayer.add(background);
			parentTextLayer.add(text3D);
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