package wander.demos 
{
	import wander.Tilemap3D;
	
	/**
	 * ...
	 * @author ...
	 */
	public class DemoTilemap3D extends Tilemap3D 
	{
		public static var tilemapsVisible:Boolean = false;
		
		public function DemoTilemap3D() 
		{
			super();
			
		}
		
		override public function update() : void
		{
			visible = tilemapsVisible;
			
			super.update();
		}
		
	}

}