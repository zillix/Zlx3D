package wander.demos
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import org.flixel.*;
	import wander.Camera3D;
	import wander.Climbable;
	import wander.Point3D;
	import wander.Sprite3D;
	
	import wander.demos.*;
	import wander.utils.*;
	
	/**
	 * Minimum impelmentation of a demo.
	 * Each demo child class will show off some Zlx3D functionality.
	 * @author zillix
	 */
	public class Zlx3DDemo extends FlxGroup 
	{
		protected var _player:DemoPlayer;
		protected var _background:FlxSprite;
		protected var _objects:FlxGroup;
		protected var _bounds:Rectangle;
		
		public function Zlx3DDemo()
		{
			FlxG.bgColor = 0x00000000;
			
			// Set up a static background. 
			// This is just a non-moving rectangle that fills half of the screen.
			_background = new FlxSprite(-FlxG.width / 2, 0);
			_background.makeGraphic(FlxG.width, FlxG.height, 0xffffffff);
			add(_background)
			
			_objects = new FlxGroup();
			add(_objects);
			
			_player = initPlayer();
			_objects.add(_player);
			
			// Set up the 3D camera
			var camera:Camera3D = new DemoCamera3D(0, 0, FlxG.width, FlxG.height)
			camera.scroll.x = -FlxG.width / 2;
			camera.scroll.y = -FlxG.height / 2;
			camera.followTarget = _player;
			camera.followDist = new Point3D(0, -FlxG.height / 5, -camera.focalLength);
			FlxG.resetCameras(camera);
			
			setupHUD();
		}
	
		override public function update() : void
		{
			super.update();
			
			_objects.sort("z", DESCENDING);
		}
		
		protected function initPlayer() : DemoPlayer
		{
			return new DemoPlayer();
		}
		
		public function loadMapImage(mapImage:Class):void
		{
			var bitmapData:BitmapData = FlxG.addBitmap(mapImage);
			var column:uint;
			var pixel:uint;
			var bitmapWidth:uint = bitmapData.width;
			var bitmapHeight:uint = bitmapData.height;
			var row:uint = bitmapHeight - 1;
			
			
			_bounds = new Rectangle( -bitmapWidth / 2 * MAP_SCALE, 0, bitmapWidth * MAP_SCALE, bitmapHeight * MAP_SCALE);
			while(row >= 0)
			{
				column = 0;
				while(column < bitmapWidth)
				{
					//Decide if this pixel/tile is solid (1) or not (0)
					pixel = bitmapData.getPixel(column, row);
					
					handleMapPixel(pixel, column, row, bitmapWidth, bitmapHeight);
					
					column++;
				}
				if (row == 0)
				{
					break;
				}
				else
				{
					row--;
				}
			
			}
		}
		
		private static const MAP_SCALE:int = 100;
		private static const WHITE:uint = 0xffffff;
		private function handleMapPixel(pixel:uint, column:uint, row:uint, width:uint, height:uint):void
		{
			if (pixel == WHITE)
			{
				return;
			}
			
			// Assume the map lies in the X/Z plane
			var xPos:int = MAP_SCALE * (column - width / 2);
			var zPos:int = MAP_SCALE * (height - row);
			var gameObject:FlxObject;
			
			gameObject = handleMapPixelColor(pixel, xPos, zPos);
			
			if (gameObject != null)
			{
				_objects.add(gameObject);
			}
		}
		
		// To be overridden by child demo classes
		protected function handleMapPixelColor(color:uint, xPos:int, zPos:int) : FlxObject
		{
			return null;
		}
		
		public function cleanUp() : void
		{
		}
		
		private function setupHUD() : void 
		{
			var instructions:FlxText = new FlxText(FlxG.width / 2 - 180,
												-FlxG.height / 2 + 10,
												200,
												getInstructionsText());
			instructions.setFormat(null, 12, 0xfffffffff);
			instructions.shadow = 0xff000000;
			add(instructions);
		}
		
		protected function getInstructionsText() : String
		{
			return "WASD: Pan camera" +
			"\nQ/E: Adjust focal length" +
			"\nARROWS: Move player" +
			"\nSPACE: Jump player";
		}
		
	}
	
}