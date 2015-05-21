package wander
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author zillix
	 */
	public class GameObject extends FlxSprite 
	{
		public var z:Number;
		public var depth:Number = 10;
		public static var Z_DIST_CHECK:int = 20;
		
		public function GameObject(X:Number = 0, Y:Number = 0, Z:Number = 0)
		{
			super(X, Y);
			z = Z;
			immovable = true;
			scale.z = 1;
		}
		
		
		
		public function setOffsets():void
		{
			offset.x = width / 2;
			offset.y = height;
			origin.y = height;
			origin.x = width / 2;
		}
		
		/**
		 * Called by game loop, updates then blits or renders current frame of animation to the screen
		 */
		override public function draw():void
		{
			if(_flickerTimer != 0)
			{
				_flicker = !_flicker;
				if(_flicker)
					return;
			}
			
			if(dirty)	//rarely 
				calcFrame();
			
			//var camera:FlxCamera = FlxG.camera;
			var camera:Camera3D = PlayState.camera;
			
			if (!onScreen(camera))
			{
				return;
			}
			
			var perspectiveScale:FlxPoint = new FlxPoint(1, 1);
			
			if (z > camera.position.z)
			{
				var zScale:Number = camera.focalLength / (z - camera.position.z);
				
				perspectiveScale.x = zScale;
				perspectiveScale.y = perspectiveScale.x;
				
				var dX:Number = zScale * (x - camera.position.x);
				_point.x = dX - int(camera.scroll.x*scrollFactor.x) - offset.x;
				
				var dY:Number = zScale * (y - camera.position.y);
				_point.y = dY - int(camera.scroll.y * scrollFactor.y) - offset.y;
				
				_point.x += (_point.x > 0)?0.0000001:-0.0000001;
				_point.y += (_point.y > 0)?0.0000001: -0.0000001;
			
				//Advanced render
				_matrix.identity();
				_matrix.translate(-origin.x,-origin.y);
				_matrix.scale(scale.x * perspectiveScale.x,scale.y * perspectiveScale.y);
				if((angle != 0) && (_bakedRotation <= 0))
					_matrix.rotate(angle * 0.017453293);
				_matrix.translate(_point.x+origin.x,_point.y+origin.y);
				camera.buffer.draw(framePixels,_matrix,null,blend,null,antialiasing);

				if(FlxG.visualDebug && !ignoreDrawDebug)
					drawDebug(camera);
			}
		}
		
		override public function preUpdate():void
		{
			last.z = z;
			super.preUpdate();
		}
		
		override public function reset(X:Number,Y:Number):void
		{
			last.z = z;
			reset(X, Y);
		}
		
		override public function onScreen(Camera:FlxCamera=null):Boolean
		{
			return true;
			
		/*	return  super.onScreen(Camera);
			
			
			var camera:Camera3D = PlayState.camera;
			getScreenXY(_point,camera);
			_point.x = _point.x - offset.x;
			_point.y = _point.y - offset.y;
			
			if (z < camera.z + camera.focalLength)
			{
				return false;
			}

			if(((angle == 0) || (_bakedRotation > 0)) && (scale.x == 1) && (scale.y == 1))
				return ((_point.x + frameWidth > 0) && (_point.x < Camera.width) && (_point.y + frameHeight > 0) && (_point.y < Camera.height));
			
			var halfWidth:Number = frameWidth/2;
			var halfHeight:Number = frameHeight/2;
			var absScaleX:Number = (scale.x>0)?scale.x:-scale.x;
			var absScaleY:Number = (scale.y>0)?scale.y:-scale.y;
			var radius:Number = Math.sqrt(halfWidth*halfWidth+halfHeight*halfHeight)*((absScaleX >= absScaleY)?absScaleX:absScaleY);
			_point.x += halfWidth;
			_point.y += halfHeight;
			return ((_point.x + radius > 0) && (_point.x - radius < Camera.width) && (_point.y + radius > 0) && (_point.y - radius < Camera.height));
	*/
		}
		
		override protected function updateMotion():void
		{
			super.updateMotion();
			var delta:Number;
			var velocityDelta:Number;

			velocityDelta = (FlxU.computeVelocity(velocity.z,acceleration.z,drag.z,maxVelocity.z) - velocity.z)/2;
			velocity.z += velocityDelta;
			delta = velocity.z*FlxG.elapsed;
			velocity.z += velocityDelta;
			z += delta;
		}
		
		static public function separate3D(Object1:FlxObject, Object2:FlxObject) : Boolean
		{
			var separatedX:Boolean = false; // separateX(Object1, Object2);
			var separatedY:Boolean = false; // separateY(Object1, Object2);
			var separatedZ:Boolean = false;
			if ((Object1 is GameObject) && (Object2 is GameObject))
			{
				separateZ(Object1 as GameObject, Object2 as GameObject);
			}
			return separatedX || separatedY || separatedZ;
			
		}
		
		static public function collide(source:GameObject=null, group:FlxGroup=null, NotifyCallback:Function=null):Boolean
		{
			return overlap(source, group, NotifyCallback, separateZ);
		}
		
		static public function overlap(source:GameObject=null, group:FlxGroup=null, NotifyCallback:Function=null, ProcessCallback:Function =null):Boolean
		{
			for each (var obj:FlxBasic in group.members)
			{
				if (obj == source)
				{
					continue;
				}
				
				if (obj is GameObject)
				{
					var object:GameObject = obj as GameObject;
					if (Math.abs(source.z - object.z) < Z_DIST_CHECK)
					{
						if (NotifyCallback != null)
						{
							NotifyCallback(source, object);
						}
						
						if (ProcessCallback(source, object))
						{
							return true;
						}
					}
				}
			}
			return false;
		}
		
		
		/**
		 * The Z-axis component of the object separation process.
		 * 
		 * @param	Object1 	Any <code>FlxObject</code>.
		 * @param	Object2		Any other <code>FlxObject</code>.
		 * 
		 * @return	Whether the objects in fact touched and were separated along the Z axis.
		 */
		static public function separateZ(Object1:GameObject, Object2:GameObject):Boolean
		{
			//can't separate two immovable objects
			var obj1immovable:Boolean = Object1.immovable;
			var obj2immovable:Boolean = Object2.immovable;
			if(obj1immovable && obj2immovable)
				return false;
			
			//If one of the objects is a tilemap, just pass it off.
			if(Object1 is FlxTilemap)
				return (Object1 as FlxTilemap).overlapsWithCallback(Object2,separateZ);
			if(Object2 is FlxTilemap)
				return (Object2 as FlxTilemap).overlapsWithCallback(Object1,separateZ,true);

			var obj1Pos:FlxPoint = new FlxPoint(Object1.x - Object1.offset.x, Object1.y - Object1.offset.y, Object1.z - Object1.offset.z);
			var obj2Pos:FlxPoint = new FlxPoint(Object2.x - Object2.offset.x, Object2.y - Object2.offset.y, Object2.z - Object2.offset.z);
			
			//First, get the two object deltas
			var overlap:Number = 0;
			var obj1delta:Number = Object1.z - Object1.last.z;
			var obj2delta:Number = Object2.z - Object2.last.z;
			if(obj1delta != obj2delta)
			{
				//Check if the Z hulls actually overlap (y/z plane)
				var obj1deltaAbs:Number = (obj1delta > 0)?obj1delta:-obj1delta;
				var obj2deltaAbs:Number = (obj2delta > 0)?obj2delta:-obj2delta;
				var obj1rect:FlxRect = new FlxRect(obj1Pos.x,obj1Pos.z-((obj1delta > 0)?obj1delta:0),Object1.width * Object1.scale.x,Object1.depth * Object1.scale.z+obj1deltaAbs);
				var obj2rect:FlxRect = new FlxRect(obj2Pos.x,obj2Pos.z-((obj2delta > 0)?obj2delta:0),Object2.width * Object2.scale.x,Object2.depth * Object2.scale.z+obj2deltaAbs);
				
				if((obj1rect.x + obj1rect.width > obj2rect.x) && (obj1rect.x < obj2rect.x + obj2rect.width) && (obj1rect.y + obj1rect.height > obj2rect.y) && (obj1rect.y < obj2rect.y + obj2rect.height))
				{
					var maxOverlap:Number = obj1deltaAbs + obj2deltaAbs + OVERLAP_BIAS;
					
					//If they did overlap (and can), figure out by how much and flip the corresponding flags
					if(obj1delta > obj2delta)
					{
						overlap = obj1Pos.z + Object1.depth - obj2Pos.z;
					
						if(overlap > maxOverlap)
							overlap = 0;
						else
						{
							Object1.touching |= DOWN;
							Object2.touching |= UP;
						}
					}
					else if(obj1delta < obj2delta)
					{
						overlap = obj1Pos.z - obj2Pos.z - Object2.depth;
						if(-overlap > maxOverlap)
							overlap = 0;
						else
						{
							Object1.touching |= UP;
							Object2.touching |= DOWN;
						}
					}
				}
			}
			
			//Then adjust their positions and velocities accordingly (if there was any overlap)
			if(overlap != 0)
			{
				var obj1v:Number = Object1.velocity.z;
				var obj2v:Number = Object2.velocity.z;
				
				if(!obj1immovable && !obj2immovable)
				{
					overlap *= 0.5;
					
					// todo(alex) offsets
					Object1.z = Object1.z - overlap;
					Object2.z += overlap;

					var obj1velocity:Number = Math.sqrt((obj2v * obj2v * Object2.mass)/Object1.mass) * ((obj2v > 0)?1:-1);
					var obj2velocity:Number = Math.sqrt((obj1v * obj1v * Object1.mass)/Object2.mass) * ((obj1v > 0)?1:-1);
					var average:Number = (obj1velocity + obj2velocity)*0.5;
					obj1velocity -= average;
					obj2velocity -= average;
					Object1.velocity.z = average + obj1velocity * Object1.elasticity;
					Object2.velocity.z = average + obj2velocity * Object2.elasticity;
				}
				else if(!obj1immovable)
				{
					Object1.z = Object1.z - overlap;
					Object1.velocity.z = obj2v - obj1v*Object1.elasticity;
					//This is special case code that handles cases like horizontal moving platforms you can ride
					if(Object2.active && Object2.moves && (obj1delta > obj2delta))
						Object1.x += Object2.x - Object2.last.x;
				}
				else if(!obj2immovable)
				{
					Object2.z += overlap;
					Object2.velocity.z = obj1v - obj2v*Object2.elasticity;
					//This is special case code that handles cases like horizontal moving platforms you can ride
					if(Object1.active && Object1.moves && (obj1delta < obj2delta))
						Object2.x += Object1.x - Object1.last.x;
				}
				return true;
			}
			else
				return false;
		}
	}
	
}