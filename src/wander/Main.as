package wander
{
	import org.flixel.*;
	[SWF(width="300", height="300", backgroundColor="#123456")]
	[Frame(factoryClass="wander.Preloader")]
	public class Main extends FlxGame
	{
		public function Main():void
		{
			super(300, 300, PlayState, 1);
		}
	}
}