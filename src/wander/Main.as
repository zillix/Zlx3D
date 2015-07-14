package wander
{
	import org.flixel.*;
	[SWF(width="450", height="450", backgroundColor="#123456")]
	[Frame(factoryClass="wander.Preloader")]
	public class Main extends FlxGame
	{
		public function Main():void
		{
			super(450, 450, PlayState, 1);
		}
	}
}