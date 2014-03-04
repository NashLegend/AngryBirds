package Utils 
{
	import Box2D.Common.Math.b2Vec2;
	import flash.geom.Point;
	/**
	 * ...
	 * @author IJUST
	 */
	public class Math 
	{
		
		public function Math()
		{
			
		}
		
		public static function getWorldb2Vec(po:Point):b2Vec2 
		{
			//把点转化为世界坐标  应该接收的是point
			var WorldPosition:b2Vec2 = new b2Vec2();
			return WorldPosition;
		}
		public static function getWorldPoint(b2V:b2Vec2):Point 
		{
			var po = new Point();
			return po;
		}
		public static function getLocalb2Vec(po:Point):b2Vec2 
		{
			var WorldPosition:b2Vec2 = new b2Vec2();
			return WorldPosition;
		}
		public static function getLocalPoint(b2V:b2Vec2):Point 
		{
			var po = new Point();
			return po;
		}
		
	}

}