package wander
{
	import wander.GameObject;
	
	/**
	 * ...
	 * @author zillix
	 */
	public class Arch extends GameObject 
	{
		[Embed(source = "../data/arch1.png")]	public var ArchSprite:Class;
		
		public function Arch(X:Number, Y:Number, Z:Number)
		{
			super(X, Y, Z);
			this.loadGraphic(ArchSprite);
			scale.x = 10;
			scale.y = 10;
			//this.makeGraphic(100, 100, 0xffffff00);
		}
	}
	
}