package wander 
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import org.flixel.FlxCamera;
	import org.flixel.system.FlxTilemapBuffer;
	import org.flixel.FlxU;
	
	/**
	 * Overrides the constructor of the default FlxTilemapBuffer.
	 * It normally crops the input rows and columns to fit within the camera,
	 * which is not a useful function when we can have large, distance-scaled objects.
	 * @author zillix
	 */
	public class ZlxTilemapBuffer extends FlxTilemapBuffer 
	{
		
		public function ZlxTilemapBuffer(TileWidth:Number, TileHeight:Number, WidthInTiles:uint, HeightInTiles:uint, Camera:FlxCamera=null, CapTiles:Boolean = true) 
		{
			super(TileWidth, TileHeight, WidthInTiles, HeightInTiles, Camera);
			
			// By default, FlxTilemapBuffer crops the tiles if the map would be too big to fit on the camera.
			// We don't want that behavior!
			
			columns = WidthInTiles;
			rows = HeightInTiles;
			if (CapTiles)
			{
				// This is the default behavior of FlxTilemapBuffer
				columns = Math.min(FlxU.ceil(Camera.width/TileWidth)+1, columns);
				rows = Math.min(FlxU.ceil(Camera.height / TileHeight) + 1, rows);
			}
			
			// Need to recreate these with the correct size
			_pixels = new BitmapData(columns*TileWidth,rows*TileHeight,true,0);
			width = _pixels.width;
			height = _pixels.height;			
			_flashRect = new Rectangle(0,0,width,height);
			dirty = true;
		}
		
	}

}