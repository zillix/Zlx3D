package wander
{
	import flash.geom.Matrix;
	import org.flixel.*;
	
	import org.flixel.system.FlxTile;
	import org.flixel.system.FlxTilemapBuffer;
	
	import wander.utils.*;
	
	/**
	 * A tilemap that supports scaled renderering based on z distance.
	 * It is expected to be a rectangular plane that exists along the X/Y axes.
	 * @author zillix
	 */
	public class Tilemap3D extends FlxTilemap 
	{
		public var z:Number = 0;
		public var offset:FlxPoint;
		public var origin:FlxPoint;
		public function Tilemap3D()
		{
			super();
			offset = new FlxPoint();
			origin = new FlxPoint();
		}
		
		override public function draw():void
		{
			if(_flickerTimer != 0)
			{
				_flicker = !_flicker;
				if(_flicker)
					return;
			}
			
			var camera:Camera3D = Z3D.camera;
			
			var perspectiveScale:FlxPoint = new FlxPoint(1, 1);
			if (z > camera.position.z)
			{
				var zScale:Number = camera.focalLength / (z - camera.position.z);
				
				var buffer:FlxTilemapBuffer;
				if (_buffers[0] == null)
				{
					// Using a ZlxTilemapBuffer here, so it doesn't crop the rows or columns if they are too big to fit on the camera
					_buffers[0] = new ZlxTilemapBuffer(_tileWidth, _tileHeight, widthInTiles, heightInTiles, camera, false);
				}
				
				buffer = _buffers[0] as FlxTilemapBuffer;
				
				var dX:Number = zScale * (x - camera.position.x) - offset.x;
				var dY:Number = zScale * (y - camera.position.y) - offset.y ;
				if(!buffer.dirty)
				{
					_point.x = dX - int(camera.scroll.x*scrollFactor.x) + buffer.x ; //copied from getScreenXY()
				
					_point.y = dY - int(camera.scroll.y*scrollFactor.y) + buffer.y ;
					buffer.dirty = (_point.x > 0) || (_point.y > 0) || (_point.x + buffer.width < camera.width) || (_point.y + buffer.height < camera.height);
				}
				if(buffer.dirty)
				{
					drawTilemap(buffer,camera);
					buffer.dirty = false;
				}
				_flashPoint.x = dX - int(camera.scroll.x*scrollFactor.x) + buffer.x; //copied from getScreenXY()
				_flashPoint.y = dY - int(camera.scroll.y*scrollFactor.y) + buffer.y;
				_flashPoint.x += (_flashPoint.x > 0)?0.0000001:-0.0000001;
				_flashPoint.y += (_flashPoint.y > 0)?0.0000001:-0.0000001;
				
				var matrix:Matrix = new Matrix();
				matrix.translate( -origin.x, -origin.y);
				matrix.scale(zScale, zScale);
				matrix.translate(_flashPoint.x + origin.x, _flashPoint.y + origin.y);
				camera.buffer.draw(buffer.pixels, matrix);
			}
		}
	}
	
}