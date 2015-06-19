package wander
{
	import org.flixel.FlxPoint;
	import wander.ZlxObject;
	
	/**
	 * ...
	 * @author zillix
	 */
	public class Plane extends ZlxObject 
	{
		public var rotation:FlxPoint;
		
		public function Plane(X:Number = 0, Y:Number = 0, Z:Number = 0)
		{
			super(X, Y, Z);
			rotation = new FlxPoint();
		}
		
		override public function draw():void
		{
			if(_flickerTimer != 0)
			{
				_flicker = !_flicker;
				if(_flicker)
					return;
			}
			
			if(dirty)	//rarely 
				calcFrame();
			
			var camera:Camera3D = PlayState.camera;
			
			if (!onScreen(camera))
			{
				return;
			}
			
			if (z <= camera.position.z)
			{
				visible = false;
			}
			else 
			{
				visible = true;
				var zScale:Number = camera.focalLength / (z - camera.position.z);
				
				scale.x = zScale;
				scale.y = scale.x;
				
				_point.x = zScale * (x - camera.position.x) - int(camera.scroll.x*scrollFactor.x) - offset.x;
				
				var dY:Number = zScale * (y - camera.position.y);
				
				_point.y = -dY -camera.scroll.y * scrollFactor.y - offset.y;
				_point.x += (_point.x > 0)?0.0000001:-0.0000001;
				_point.y += (_point.y > 0)?0.0000001: -0.0000001;
			}
			
			if(((angle == 0) || (_bakedRotation > 0)) && (scale.x == 1) && (scale.y == 1) && (blend == null))
			{	//Simple render
				_flashPoint.x = _point.x;
				_flashPoint.y = _point.y;
				camera.buffer.copyPixels(framePixels,_flashRect,_flashPoint,null,null,true);
			}
			else
			{	//Advanced render
				_matrix.identity();
				_matrix.translate(-origin.x,-origin.y);
				_matrix.scale(scale.x,scale.y);
				if((angle != 0) && (_bakedRotation <= 0))
					_matrix.rotate(angle * 0.017453293);
				_matrix.translate(_point.x+origin.x,_point.y+origin.y);
				camera.buffer.draw(framePixels,_matrix,null,blend,null,antialiasing);
			}
			if(FlxG.visualDebug && !ignoreDrawDebug)
				drawDebug(camera);
		}
	}
	
}