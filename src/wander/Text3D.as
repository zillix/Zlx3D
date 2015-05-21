package wander
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author zillix
	 */
	public class Text3D extends FlxText
	{
		public var z:Number = 0;
		public var scales:Boolean = true;
		public function Text3D(X:Number, Y:Number, Z:Number, Width:uint, Text:String=null, EmbeddedFont:Boolean=true, scale:Boolean = true)
		{
			super(X, Y, Width, Text, EmbeddedFont);
			scales = scale;
			z = Z;
			setOffsets();
		}
		
		public function setOffsets():void
		{
			offset.x = width / 2;
			offset.y = height;
			origin.y = height;
			origin.x = width / 2;
		}
		
		public override function update():void
		{
			/*var camera:Camera3D = PlayState.camera;
			if (z > camera.position.z)
			{
				//var zScale:Number = 1;
				var zScale:Number = camera.focalLength / (z - camera.position.z);
				
				var dX:Number = zScale * (x - camera.position.x);
				var point:FlxPoint = new FlxPoint();
				point.x = dX - int(camera.scroll.x*scrollFactor.x) - offset.x;
				
				var dY:Number = zScale * (y - camera.position.y);
				point.y = dY - int(camera.scroll.y * scrollFactor.y) - offset.y;
				
				point.x += (_point.x > 0)?0.0000001:-0.0000001;
				point.y += (_point.y > 0)?0.0000001: -0.0000001;
			}*/
			
			super.update();
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
			
			//var camera:FlxCamera = FlxG.camera;
			var camera:Camera3D = PlayState.camera;
			
			if (!onScreen(camera))
			{
				return;
			}
			
			var perspectiveScale:FlxPoint = new FlxPoint(1, 1);
			
			if (z > camera.position.z)
			{
				var zScale:Number = camera.focalLength / (z - camera.position.z);
				
				if (scales)
				{
					perspectiveScale.x = zScale;
					perspectiveScale.y = perspectiveScale.x;
				}
				
				var dX:Number = zScale * (x - camera.position.x);
				_point.x = dX - int(camera.scroll.x*scrollFactor.x) - offset.x;
				
				var dY:Number = zScale * (y - camera.position.y);
				_point.y = dY - int(camera.scroll.y * scrollFactor.y) - offset.y;
				
				_point.x += (_point.x > 0)?0.0000001:-0.0000001;
				_point.y += (_point.y > 0)?0.0000001: -0.0000001;
			
				//Advanced render
				_matrix.identity();
				_matrix.translate(-origin.x,-origin.y);
				_matrix.scale(scale.x * perspectiveScale.x,scale.y * perspectiveScale.y);
				if((angle != 0) && (_bakedRotation <= 0))
					_matrix.rotate(angle * 0.017453293);
				_matrix.translate(_point.x+origin.x,_point.y+origin.y);
				camera.buffer.draw(framePixels,_matrix,null,blend,null,antialiasing);

				if(FlxG.visualDebug && !ignoreDrawDebug)
					drawDebug(camera);
			}
		}
		
		override public function onScreen(Camera:FlxCamera=null):Boolean
		{
			if (Camera as Camera3D)
			{
				return (Camera as Camera3D).position.z < z;
			}
			
			return true;
			
		/*	return  super.onScreen(Camera);
			
			
			var camera:Camera3D = PlayState.camera;
			getScreenXY(_point,camera);
			_point.x = _point.x - offset.x;
			_point.y = _point.y - offset.y;
			
			if (z < camera.z + camera.focalLength)
			{
				return false;
			}

			if(((angle == 0) || (_bakedRotation > 0)) && (scale.x == 1) && (scale.y == 1))
				return ((_point.x + frameWidth > 0) && (_point.x < Camera.width) && (_point.y + frameHeight > 0) && (_point.y < Camera.height));
			
			var halfWidth:Number = frameWidth/2;
			var halfHeight:Number = frameHeight/2;
			var absScaleX:Number = (scale.x>0)?scale.x:-scale.x;
			var absScaleY:Number = (scale.y>0)?scale.y:-scale.y;
			var radius:Number = Math.sqrt(halfWidth*halfWidth+halfHeight*halfHeight)*((absScaleX >= absScaleY)?absScaleX:absScaleY);
			_point.x += halfWidth;
			_point.y += halfHeight;
			return ((_point.x + radius > 0) && (_point.x - radius < Camera.width) && (_point.y + radius > 0) && (_point.y - radius < Camera.height));
	*/
		}
		
		
		
	}
	
}