package wander.demos
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import org.flixel.*;
	import wander.Camera3D;
	import wander.Climbable;
	import wander.Player;
	import wander.ZlxPoint;
	import wander.GameObject;
	
	import wander.utils.*;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Zlx3DDemo extends FlxGroup 
	{
		protected var _player:Player;
		protected var _background:FlxSprite;
		protected var _objects:FlxGroup;
		protected var _bounds:Rectangle;
		
		[Embed(source = "data/map.png")]	public var MapImage:Class;
		
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
			
			_player = new Player();
			_objects.add(_player);
			
			// Set up the 3D camera
			var camera:Camera3D = new Camera3D(0, 0, FlxG.width, FlxG.height)
			camera.scroll.x = -FlxG.width / 2;
			camera.scroll.y = -FlxG.height / 2;
			camera.followTarget = _player;
			camera.followDist = new ZlxPoint(0, -100, -camera.focalLength);
			FlxG.resetCameras(camera);
			
			loadMapImage(MapImage);
			
				var junk:GameObject;
		/*	for (var i:int = 0; i < 20; i++)
			{
				junk = new GameObject(Math.random() * 1000 - 500, 0, Math.random() * 10000 + 1000);
				junk.makeGraphic(Math.random() * 100 + 70, Math.random() * 100 + 50, 0xff00ff00);
				junk.setOffsets();
				objects.add(junk);
			}*/
			
		/*	junk = new GameObject(0, 0, 100);// 15000);
			junk.makeGraphic(1000, 5000, 0xffff0000);
			junk.setOffsets();
			junk.color = 0x44ffffff;
			objects.add(junk);
			*/
			/*
			arch = new GameObject(0, 0, 100);
			arch.loadGraphic(ArchSprite);
			arch.scale = new FlxPoint(10, 10);
			arch.setOffsets();
			objects.add(arch);
			
			
			var pass:GameObject = new GameObject(0, 0, 1000);
			pass.loadGraphic(PassSprite);
			pass.scale = new FlxPoint(100, 10);
			pass.setOffsets();
			objects.add(pass);*/
			
			// TODO(alex): Figure out if this actually gets used
			//FlxG.setupPerpsective(GroundSprite);
		}
	
		override public function update() : void
		{
			super.update();
			
			_objects.sort("z", DESCENDING);
			
			// TODO(alex)
			/*if (FlxG.keys.justPressed("C"))
			{
				camera.startScan(arch);
			}*/
			
			_player.resetTouchedObject();
			
			if (_player.isClimbing && (_player.touchedObject is Climbable))
			{
				//Zlx3DUtils.climbOverlap(_player, (_player.touchedObject as Climbable), FlxObject.separate);
			}
			else
			{
				GameObject.collide(_player, _objects, onPlayerTouchObject);
			}
		}
		
		private function onPlayerTouchObject(src:Player, hit:GameObject):void
		{
			src.setTouchedObject(hit);
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
		private static const JUNK:uint = 0x1EDA02; // 30,218,2 (green)
		private static const PILLAR:uint = 0x572F17; // 87 47 23 (brown)
		private static const CLIMBABLE:uint = 0x1B02DA; // 27 2 218 (blue)
		private function handleMapPixel(pixel:uint, column:uint, row:uint, width:uint, height:uint):void
		{
			if (pixel == WHITE)
			{
				return;
			}
			
			var xPos:int = MAP_SCALE * (column - width / 2);
			var zPos:int = MAP_SCALE * (height - row);
			var gameObject:GameObject;
			switch(pixel)
			{
				case JUNK:
					gameObject = new GameObject(xPos, 0, zPos);
					gameObject.makeGraphic(Math.random() * 100 + 70, Math.random() * 100 + 50, 0xff00ff00);
					gameObject.setOffsets();
					break;
					
				case PILLAR:
					gameObject = new GameObject(xPos, 0, zPos);
					gameObject.makeGraphic(1000, 5000, 0xffff0000);
					gameObject.setOffsets();
					break;
					
				case CLIMBABLE:
					gameObject = new Climbable(xPos, 0, zPos, _objects);
					gameObject.makeGraphic(200, 400, 0xff0000ff);
					gameObject.setOffsets();
					break;
			}
			
			if (gameObject != null)
			{
				_objects.add(gameObject);
			}
		}
		
		public function cleanUp() : void
		{
		}
		
	}
	
}