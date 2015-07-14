package wander
{
	import adobe.utils.CustomActions;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import org.flixel.*;
	import flash.utils.ByteArray;
	import org.flixel.system.*;
	import wander.demos.Zlx3DDemo;
	import wander.demos.ClimbDemo;
	import wander.demos.TextDemo;
	import wander.demos.BasicDemo;
	
	/**
	 * Simple harness that loads and runs various demos, depending on the key pressed.
	 * 
	 * @author zillix
	 */

	public class PlayState extends FlxState
	{
		private var _activeDemo:Zlx3DDemo;
		private var _demoText:FlxText;
		
		private var _demoList:Vector.<Class>;
		private var _demoLayer:FlxGroup;
		
		override public function create():void
		{
			FlxG.bgColor = 0xffffffff;
			
			_demoLayer = new FlxGroup();
			
			_demoList = Vector.<Class>(
				[
					BasicDemo,
					ClimbDemo,
					TextDemo
				]
			);
			
			
			add(_demoLayer);
			setDemo(1);
			
			_demoText = new FlxText(-220, -220, 200,
				"1: Basic 3D" +
				"\n2: Climbing" +
				"\n3: Text");
			_demoText.setFormat(null, 16, 0xfffffffff);
			_demoText.shadow = 0xff000000;
		
			add(_demoText);
			
			
		}
		
		override public function update():void
		{
			_activeDemo.update();
			
			if (FlxG.keys.justPressed("ONE"))
			{
				setDemo(0);
			}
			else if (FlxG.keys.justPressed("TWO"))
			{
				setDemo(1);
			}
			else if (FlxG.keys.justPressed("THREE"))
			{
				setDemo(2);
			}
			else if (FlxG.keys.justPressed("FOUR"))
			{
				setDemo(3);
			}
			else if (FlxG.keys.justPressed("FIVE"))
			{
				setDemo(4);
			}
		}
		
		private function setDemo(index:int) : void
		{
			if (index < 0 || index >= _demoList.length)
			{
				return;
			}
			
			var demoClass:Class = _demoList[index];
			var demo:Zlx3DDemo = new demoClass() as Zlx3DDemo;
			
			if (demo != null)
			{
				if (_activeDemo != null)
				{
					_demoLayer.remove(_activeDemo);
					_activeDemo.cleanUp();
				}
				_activeDemo = demo;
				_demoLayer.add(_activeDemo);
			}
		}
	}
}