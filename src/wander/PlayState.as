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

	public class PlayState extends FlxState
	{
		private var _activeDemo:Zlx3DDemo;
		private var _demoText:FlxText;
		
		private var _demoList:Vector.<Class>;
		
		override public function create():void
		{
			FlxG.bgColor = 0xffffffff;
			
			_demoText = new FlxText(50, 30, 200,
				"1: Climbing");
			_demoText.setFormat(null, 8, 0x000000);
			add(_demoText);
			
			_demoList = Vector.<Class>(
				[
					ClimbDemo,
					TextDemo
				]
			);
			
			setDemo(0);
			
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
					remove(_activeDemo);
					_activeDemo.cleanUp();
				}
				_activeDemo = demo;
				add(_activeDemo);
			}
		}
	}
}