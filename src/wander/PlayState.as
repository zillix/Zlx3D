package wander
{
	import adobe.utils.CustomActions;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.ui.Mouse;
	import org.flixel.*;
	import flash.utils.ByteArray;
	import org.flixel.system.*;

	public class PlayState extends FlxState
	{
		public var player:Player;
		
		public static var instance:PlayState;
		public var background:FlxSprite;
		
		public var obstacle:GameObject;
		
		public var objects:FlxGroup;
		
		public static var GROUND_HEIGHT:int = 0;
		public static const GRAVITY:int = 1000;
		
		
		
		public var bounds:Rectangle = new Rectangle();
		
		[Embed(source = "../data/arch1.png")]	public var ArchSprite:Class;
		[Embed(source = "../data/pass.png")]	public var PassSprite:Class;
		[Embed(source = "../data/ground.png")]	public var GroundSprite:Class;
		[Embed(source = "../data/map.png")]	public var MapImage:Class;
		[Embed(source="../data/vaso_nivavy3.mp3")] protected  var Song1:Class;
		
		
		public var arch:GameObject;
		
		override public function create():void
		{
			instance = this;
			background = new FlxSprite(-FlxG.width / 2, 0);
			background.makeGraphic(FlxG.width, FlxG.height, 0xffffffff);
			add(background);
			//FlxG.playMusic(Song1);
			
			FlxG.bgColor = 0x00000000;
			
			objects = new FlxGroup();
			add(objects);
		
			player = new Player();
		
			FlxG.resetCameras(new Camera3D(0, 0, FlxG.width, FlxG.height));
			camera.scroll.x = -FlxG.width / 2;
			camera.scroll.y = -FlxG.height / 2;
			camera.followTarget = player;
			camera.followDist = new ZlxPoint(0, -100, -camera.focalLength);
			
			super.create();
			objects.add(player);
			
			var junk:GameObject;
		/*	for (var i:int = 0; i < 20; i++)
			{
				junk = new GameObject(Math.random() * 1000 - 500, 0, Math.random() * 10000 + 1000);
				junk.makeGraphic(Math.random() * 100 + 70, Math.random() * 100 + 50, 0xff00ff00);
				junk.setOffsets();
				objects.add(junk);
			}*/
			
			loadMapImage(MapImage);
			
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
		
		override public function update():void
		{
			super.update();	
			
			objects.sort("z", DESCENDING);
			
			if (FlxG.keys.justPressed("C"))
			{
				camera.startScan(arch);
			}
			
			player.resetTouchedObject();
			
			if (player.isClimbing && (player.touchedObject is Climbable))
			{
				climbOverlap(player, (player.touchedObject as Climbable), FlxObject.separate);
			}
			else
			{
				GameObject.collide(player, objects, touchObject);
			}
		}
		
		public static function climbOverlap(object1:FlxSprite = null, climbable:Climbable = null, NotifyCallback:Function = null, ProcessCallback:Function = null):Boolean
		{
			FlxQuadTree.divisions = FlxG.worldDivisions;
			var tilemap:Tilemap3D = climbable.tileMap;
			tilemap.x -= tilemap.offset.x;
			tilemap.y -= tilemap.offset.y;
			tilemap.last.x = tilemap.x;
			tilemap.last.y = tilemap.y;
			
			object1.x -= object1.offset.x;
			object1.y -= object1.offset.y;
			object1.last.x -= object1.offset.x;
			object1.last.y -= object1.offset.y;
			
			var saveScale:FlxPoint = object1.scale;
		//	object1.scale = new FlxPoint(.5, .5);
			//var quadTree:FlxQuadTree = new FlxQuadTree(tilemap.x - tilemap.width,tilemap.y - tilemap.height * 2,tilemap.width * 4,tilemap.height * 4);
			var result:Boolean = NotifyCallback(object1, tilemap);
			object1.scale = saveScale;
		//	quadTree.load(object1,tilemap,NotifyCallback,ProcessCallback);
		//	var result:Boolean = quadTree.execute();
			tilemap.x += tilemap.offset.x;
			tilemap.y += tilemap.offset.y;
			tilemap.last.x = tilemap.x;
			tilemap.last.y = tilemap.y;
			object1.x += object1.offset.x;
			object1.y += object1.offset.y;
			object1.last.x += object1.offset.x;
			object1.last.y += object1.offset.y;
			
			//quadTree.destroy();
			return result;
		}
		
		public static function climbOverlap2(object1:FlxSprite = null, climbable:Climbable = null):Boolean
		{
			if (climbable == null)
			{
				return false;
			}
			
			var tilemap:Tilemap3D = climbable.tileMap;
			tilemap.x -= tilemap.offset.x;
			tilemap.y -= tilemap.offset.y;
			tilemap.last.x = tilemap.x;
			tilemap.last.y = tilemap.y;
			
			
			object1.x -= object1.offset.x;
			object1.y -= object1.offset.y;
			object1.last.x -= object1.offset.x;
			object1.last.y -= object1.offset.y;
			
				var saveScale:FlxPoint = object1.scale;
			object1.scale = new FlxPoint(.5, .5);
			
			var result:Boolean = tilemap.overlapsWithCallback(object1);
		
			object1.scale = saveScale;
			
			tilemap.x += tilemap.offset.x;
			tilemap.y += tilemap.offset.y;
			tilemap.last.x = tilemap.x;
			tilemap.last.y = tilemap.y;
			object1.x += object1.offset.x;
			object1.y += object1.offset.y;
			object1.last.x += object1.offset.x;
			object1.last.y += object1.offset.y;
			
			//quadTree.destroy();
			return result;
		}
		
		public function loadMapImage(mapImage:Class):void
		{
			var bitmapData:BitmapData = FlxG.addBitmap(mapImage);
			var column:uint;
			var pixel:uint;
			var bitmapWidth:uint = bitmapData.width;
			var bitmapHeight:uint = bitmapData.height;
			var row:uint = bitmapHeight - 1;
			
			
			bounds = new Rectangle( -bitmapWidth / 2 * MAP_SCALE, 0, bitmapWidth * MAP_SCALE, bitmapHeight * MAP_SCALE);
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
					gameObject = new Climbable(xPos, 0, zPos);
					gameObject.makeGraphic(200, 400, 0xff0000ff);
					gameObject.setOffsets();
					break;
			}
			
			if (gameObject != null)
			{
				objects.add(gameObject);
			}
		}
		
		public static function rbgToHex(r:int, g:int, b:int):Number
		{
			return r << 16 | g << 8 | b;
		}
		
		public function touchObject(src:Player, hit:GameObject):void
		{
			player.setTouchedObject(hit);
		}
			
		
		public function cleanGroup(gr:FlxGroup):void 
		{
			if (gr != null && gr.members.length > 0)
			for (var i:int = gr.members.length - 1; i >= 0; i--)
			{
				var obj:FlxObject = gr.members[i] as FlxObject;
				if (obj && !obj.alive)
				gr.members.splice(i,1);
			}
		}
		
		public static function get camera():Camera3D
		{
			return FlxG.camera as Camera3D;
		}
		
		public function fitBounds(gameObject:GameObject):void
		{
			var direction:int = 0;
			if (gameObject.x < bounds.x)
			{
				direction = 1;
				gameObject.x = bounds.x;
			}
			if (gameObject.x > bounds.x + bounds.width)
			{
				direction = -1;
				gameObject.x = bounds.x + bounds.width;
			}
			
			if (gameObject.z < bounds.y)
			{
				direction = gameObject.facing == FlxObject.LEFT ? 1 : -1;
				gameObject.z = bounds.y;
			}
			if (gameObject.z > bounds.y + bounds.height)
			{
				direction = gameObject.facing == FlxObject.LEFT ? 1 : -1;
				gameObject.z = bounds.y + bounds.height;
			}
		}
	}
}