package wander
{
	import org.flixel.system.FlxPreloader;
	public class Preloader extends FlxPreloader
	{
		public function Preloader():void
		{
			className = "wander.Main";
			super();
		}
	}
}