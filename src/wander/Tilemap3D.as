package wander
{
	import flash.geom.Matrix;
	import org.flixel.*;
	
	import org.flixel.system.FlxTile;
	import org.flixel.system.FlxTilemapBuffer;
	
	import wander.utils.*;
	
	/**
	 * ...
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
			
			var camera:Camera3D = Z3DUtils.camera;
			
			var perspectiveScale:FlxPoint = new FlxPoint(1, 1);
			if (z > camera.position.z)
			{
				var zScale:Number = camera.focalLength / (z - camera.position.z);
				
				var buffer:FlxTilemapBuffer;
				if(_buffers[0] == null)
					_buffers[0] = new FlxTilemapBuffer(_tileWidth, _tileHeight, widthInTiles, heightInTiles, camera); // TODO(alex): Do I need this? , false);
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
				//buffer.draw(camera,_flashPoint);
				//_VISIBLECOUNT++;
			}
		}
		
		/*override protected function drawTilemap(Buffer:FlxTilemapBuffer,Camera:FlxCamera):void
		{
			Buffer.fill();
			
			var zScale:Number = camera.focalLength / (z - camera.position.z);
				
			//Copy tile images into the tile buffer
			_point.x = int(Camera.scroll.x*scrollFactor.x) - x; //modified from getScreenXY()
			_point.y = int(Camera.scroll.y*scrollFactor.y) - y;
			var screenXInTiles:int = (_point.x + ((_point.x > 0)?0.0000001:-0.0000001))/_tileWidth;
			var screenYInTiles:int = (_point.y + ((_point.y > 0)?0.0000001:-0.0000001))/_tileHeight;
			var screenRows:uint = Buffer.rows;
			var screenColumns:uint = Buffer.columns;
			
			//Bound the upper left corner
			if(screenXInTiles < 0)
				screenXInTiles = 0;
			if(screenXInTiles > widthInTiles-screenColumns)
				screenXInTiles = widthInTiles-screenColumns;
			if(screenYInTiles < 0)
				screenYInTiles = 0;
			if(screenYInTiles > heightInTiles-screenRows)
				screenYInTiles = heightInTiles-screenRows;
			
			var rowIndex:int = screenYInTiles*widthInTiles+screenXInTiles;
			_flashPoint.y = 0;
			var row:uint = 0;
			var column:uint;
			var columnIndex:uint;
			var tile:FlxTile;
			var debugTile:BitmapData;
			while(row < screenRows)
			{
				columnIndex = rowIndex;
				column = 0;
				_flashPoint.x = 0;
				while(column < screenColumns)
				{
					_flashRect = _rects[columnIndex] as Rectangle;
					if(_flashRect != null)
					{
						Buffer.pixels.copyPixels(_tiles,_flashRect,_flashPoint,null,null,true);
						if(FlxG.visualDebug && !ignoreDrawDebug)
						{
							tile = _tileObjects[_data[columnIndex]];
							if(tile != null)
							{
								if(tile.allowCollisions <= NONE)
									debugTile = _debugTileNotSolid; //blue
								else if(tile.allowCollisions != ANY)
									debugTile = _debugTilePartial; //pink
								else
									debugTile = _debugTileSolid; //green
								Buffer.pixels.copyPixels(debugTile,_debugRect,_flashPoint,null,null,true);
							}
						}
					}
					_flashPoint.x += _tileWidth;
					column++;
					columnIndex++;
				}
				rowIndex += widthInTiles;
				_flashPoint.y += _tileHeight;
				row++;
			}
			Buffer.x = screenXInTiles*_tileWidth;
			Buffer.y = screenYInTiles*_tileHeight;
		}*/
	}
	
}