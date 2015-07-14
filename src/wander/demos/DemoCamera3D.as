package wander.demos 
{
	import wander.Camera3D;
	import org.flixel.FlxG;
	
	/**
	 * Camera3D with demo functionality to control it using the keyboard
	 * @author zillix
	 */
	public class DemoCamera3D extends Camera3D 
	{
		public function DemoCamera3D(X:int, Y:int, Width:int, Height:int, Zoom:Number=0) 
		{
			super(X, Y, Width, Height, Zoom);
		}
		
		override public function update() : void
		{
			super.update();
				
			if (FlxG.keys.W)
			{
				followDist.y -= FlxG.elapsed * scrollSpeed.y;
			}
			
			if (FlxG.keys.S)
			{
				followDist.y += FlxG.elapsed * scrollSpeed.y;
			}
			
			if (FlxG.keys.A)
			{
				followDist.x -= FlxG.elapsed * scrollSpeed.x;
			}
			
			if (FlxG.keys.D)
			{
				followDist.x += FlxG.elapsed * scrollSpeed.x;
			}
			
			if (FlxG.keys.Q)
			{
				focalLength -= FlxG.elapsed * scrollSpeed.z;
			}
			
			if (FlxG.keys.E)
			{
				focalLength += FlxG.elapsed * scrollSpeed.z;
			}
		}
	}
}