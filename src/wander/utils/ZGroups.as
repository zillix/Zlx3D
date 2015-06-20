package wander.utils 
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	/**
	 * Various FlxGroup utilities I use in other projects.
	 * @author zillix
	 */
	public class ZGroups
	{
		public static function killGroup(gr:FlxGroup):void 
		{
			if (gr != null && gr.members.length > 0)
			for each(var obj:FlxObject in gr.members)
			{
				obj.kill();
			}
		}
		
		public static function cleanGroup(gr:FlxGroup):void 
		{
			if (gr != null && gr.members.length > 0)
			{
				for (var i:int = gr.members.length - 1; i >= 0; i--)
				{
					var obj:FlxObject = gr.members[i] as FlxObject;
					if (obj && !obj.alive)
					{
						gr.members.splice(i, 1);
					}
				}
			}
		}
		
	}

}