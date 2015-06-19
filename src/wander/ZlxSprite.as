package wander
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.flixel.*;
	import wander.utils.*;
	
	/**
	 * 3D implementation of FlxSprite.
	 * @author zillix
	 */
	public class ZlxSprite extends FlxSprite 
	{
		public var z:Number;
		public var depth:Number = 10;
		public static var Z_DIST_CHECK:int = 200;
		
		public var shadow:Boolean = false;
		public var annihilated:Boolean = false;
		
		public function ZlxSprite(X:Number = 0, Y:Number = 0, Z:Number = 0)
		{
			super(X, Y);
			
			// We need to reassign several variables to use the 3d versions
			last = new ZlxPoint(X, Y, Z);
			scale = new ZlxPoint(1, 1, 1);
			velocity = new ZlxPoint();
			acceleration = new ZlxPoint();
			offset = new ZlxPoint();
			drag = new ZlxPoint();
			maxVelocity = new ZlxPoint(10000,10000);
			
			z = Z;
			immovable = true;
			maxVelocity = new ZlxPoint(1000, 1000, 1000);
			
			setOffsets();
		}
		
		
		// This is important, must be called after the dimensions of the object
		// are established.
		// loadGraphic, loadRotatedGraphic and makeGraphic already use it automatically.
		public function setOffsets():void
		{
			offset.x = width / 2;
			offset.y = height;
			origin.x = width / 2;
			origin.y = height;
		}
		
		override public function loadGraphic(Graphic:Class,Animated:Boolean=false,Reverse:Boolean=false,Width:uint=0,Height:uint=0,Unique:Boolean=false):FlxSprite
		{
			var returnValue:FlxSprite = super.loadGraphic(Graphic, Animated, Reverse, Width, Height, Unique);
			setOffsets();
			return returnValue;
		}
		
		override public function loadRotatedGraphic(Graphic:Class, Rotations:uint=16, Frame:int=-1, AntiAliasing:Boolean=false, AutoBuffer:Boolean=false, Scale:Number = 1.0):FlxSprite
		{
			var returnValue:FlxSprite = super.loadRotatedGraphic(Graphic, Rotations, Frame, AntiAliasing, AutoBuffer, Scale);
			setOffsets();
			return returnValue;
		}
		
		override public function makeGraphic(Width:uint,Height:uint,Color:uint=0xffffffff,Unique:Boolean=false,Key:String=null):FlxSprite
		{
			var returnValue:FlxSprite = super.makeGraphic(Width, Height, Color, Unique, Key);
			setOffsets();
			return returnValue;
		}
		
		/**
		 * Called by game loop, updates then blits or renders current frame of animation to the screen.
		 * I completely reimplement this, since it needs a lot of custom code.
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
			
			var camera:Camera3D = Z3DUtils.camera;
			
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
			ZlxPoint(last).z = z;
			super.preUpdate();
		}
		
		override public function reset(X:Number,Y:Number):void
		{
			ZlxPoint(last).z = z;
			reset(X, Y);
		}
		
		// Currently this only determines if the object is in *front* of the camera, not truly onnscreen.
		override public function onScreen(Camera:FlxCamera=null):Boolean
		{
			if (Camera as Camera3D)
			{
				return (Camera as Camera3D).position.z < z + depth / 2;
			}
			
			return true;
		}
		
		override protected function updateMotion():void
		{
			super.updateMotion();
			var delta:Number;
			var velocityDelta:Number;
			
			velocityDelta = (
								FlxU.computeVelocity(
													ZlxPoint(velocity).z,
													ZlxPoint(acceleration).z,
													ZlxPoint(drag).z,
													ZlxPoint(maxVelocity).z
													)
									- ZlxPoint(velocity).z
							) / 2;
			ZlxPoint(velocity).z += velocityDelta;
			delta = ZlxPoint(velocity).z*FlxG.elapsed;
			ZlxPoint(velocity).z += velocityDelta;
			z += delta;
		}
		
		static public function collide(source:ZlxSprite=null, group:FlxGroup=null, NotifyCallback:Function=null):Boolean
		{
			return overlap(source, group, NotifyCallback, separateZ);
		}
		
		static public function overlap(source:ZlxSprite=null, group:FlxGroup=null, NotifyCallback:Function=null, ProcessCallback:Function =null):Boolean
		{
			for each (var obj:FlxBasic in group.members)
			{
				if (obj == source)
				{
					continue;
				}
				
				if (obj is ZlxSprite)
				{
					var object:ZlxSprite = obj as ZlxSprite;
					if (Math.abs(source.z - object.z) < Z_DIST_CHECK)
					{
						if (ProcessCallback(source, object))
						{
							if (NotifyCallback != null)
							{
								NotifyCallback(source, object);
							}
						
						
							return true;
						}
					}
				}
			}
			return false;
		}
		
		static public function shadowCollide(source:ZlxSprite=null, group:FlxGroup=null, NotifyCallback:Function=null):Boolean
		{
			for each (var obj:FlxBasic in group.members)
			{
				if (obj == source)
				{
					continue;
				}
				
				if (obj is ZlxSprite)
				{
					var object:ZlxSprite = obj as ZlxSprite;
					//if (Math.abs(source.z - object.z) < Z_DIST_CHECK)
					{
						if (collideZ(source, object))
						{
							NotifyCallback(source, object);
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
		static public function separateZ(Object1:ZlxSprite, Object2:ZlxSprite):Boolean
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

			var obj1Pos:ZlxPoint = new ZlxPoint(Object1.x - Object1.offset.x * Object1.scale.x, Object1.y - Object1.offset.y * Object1.scale.y, Object1.z - ZlxPoint(Object1.offset).z);
			var obj2Pos:ZlxPoint = new ZlxPoint(Object2.x - Object2.offset.x * Object2.scale.x, Object2.y - Object2.offset.y * Object2.scale.y, Object2.z - ZlxPoint(Object2.offset).z);
			
			//First, get the two object deltas
			var overlap:Number = 0;
			var obj1delta:Number = Object1.z - ZlxPoint(Object1.last).z;
			var obj2delta:Number = Object2.z - ZlxPoint(Object2.last).z;
			if(obj1delta != obj2delta)
			{
				//Check if the Z hulls actually overlap (y/z plane)
				var obj1deltaAbs:Number = (obj1delta > 0)?obj1delta:-obj1delta;
				var obj2deltaAbs:Number = (obj2delta > 0)?obj2delta:-obj2delta;
				var obj1rect:FlxRect = new FlxRect(obj1Pos.x,obj1Pos.z-((obj1delta > 0)?obj1delta:0),Object1.width * Object1.scale.x,Object1.depth * ZlxPoint(Object1.scale).z+obj1deltaAbs);
				var obj2rect:FlxRect = new FlxRect(obj2Pos.x,obj2Pos.z-((obj2delta > 0)?obj2delta:0),Object2.width * Object2.scale.x,Object2.depth * ZlxPoint(Object2.scale).z+obj2deltaAbs);
				
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
				var obj1v:Number = ZlxPoint(Object1.velocity).z;
				var obj2v:Number = ZlxPoint(Object2.velocity).z;
				
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
					ZlxPoint(Object1.velocity).z = average + obj1velocity * Object1.elasticity;
					ZlxPoint(Object2.velocity).z = average + obj2velocity * Object2.elasticity;
				}
				else if(!obj1immovable)
				{
					Object1.z = Object1.z - overlap;
					ZlxPoint(Object1.velocity).z = obj2v - obj1v*Object1.elasticity;
					//This is special case code that handles cases like horizontal moving platforms you can ride
					if(Object2.active && Object2.moves && (obj1delta > obj2delta))
						Object1.x += Object2.x - Object2.last.x;
				}
				else if(!obj2immovable)
				{
					Object2.z += overlap;
					ZlxPoint(Object2.velocity).z = obj1v - obj2v*Object2.elasticity;
					//This is special case code that handles cases like horizontal moving platforms you can ride
					if(Object1.active && Object1.moves && (obj1delta < obj2delta))
						Object2.x += Object1.x - Object1.last.x;
				}
				return true;
			}
			else
				return false;
		}
		
		static public function collideZ(Object1:ZlxSprite, Object2:ZlxSprite):Boolean
		{
			var obj1Pos:ZlxPoint = new ZlxPoint(Object1.x - Object1.offset.x, Object1.y - Object1.offset.y, Object1.z - ZlxPoint(Object1.offset).z);
			var obj2Pos:ZlxPoint = new ZlxPoint(Object2.x - Object2.offset.x, Object2.y - Object2.offset.y, Object2.z - ZlxPoint(Object2.offset).z);
			
			//First, get the two object deltas
			var overlap:Number = 0;
			{
				//Check if the Z hulls actually overlap (x/z plane)
				var obj1rect:FlxRect = new FlxRect(obj1Pos.x,obj1Pos.z,Object1.width * Object1.scale.x,Object1.depth * ZlxPoint(Object1.scale).z);
				var obj2rect:FlxRect = new FlxRect(obj2Pos.x,obj2Pos.z,Object2.width * Object2.scale.x,Object2.depth * ZlxPoint(Object2.scale).z);
				
				if((obj1rect.x + obj1rect.width > obj2rect.x) && (obj1rect.x < obj2rect.x + obj2rect.width) && (obj1rect.y + obj1rect.height > obj2rect.y) && (obj1rect.y < obj2rect.y + obj2rect.height))
				{
					overlap = 1;
					
					// Does not set any 'touching' flags on either object
				}
			}
			
			return overlap != 0;
		}
		
		public function get left():Number
		{
			return x - width / 2 * scale.x;; 
		}
		
		public function get right():Number
		{
			return x + width/ 2 * scale.x; 
		}
		
		public function get top():Number
		{
			return y - height * scale.y; 
		}
		
		public function get bottom():Number
		{
			return y ; 
		}
		
		public function moveTowards(point:ZlxPoint, speed:Number, threshold:Number):Boolean
		{
			var position:ZlxPoint = new ZlxPoint(x, y, z);
			if (position.x < point.x)
			{
				position.x = Math.min(point.x, position.x + FlxG.elapsed * speed);
			}
			if (position.x > point.x)
			{
				position.x = Math.max(point.x,position. x - FlxG.elapsed * speed);
			}
			
			if (position.y < point.y)
			{
				position.y = Math.min(point.y, position.y + FlxG.elapsed * speed);
			}
			if (position.y > point.y)
			{
				position.y = Math.max(point.y, position.y - FlxG.elapsed * speed);
			}
			
			if (position.z < point.z)
			{
				position.z = Math.min(point.z, position.z + FlxG.elapsed * speed);
			}
			if (position.z > point.z)
			{
				position.z = Math.max(point.z, position.z - FlxG.elapsed * speed);
			}
			
			x = position.x;
			y = position.y;
			z = position.z;
			
			if (FlxU.getDistance(point, position) < threshold)
			{
				return true;
			}
			
			return false;
		}
	}
	
}