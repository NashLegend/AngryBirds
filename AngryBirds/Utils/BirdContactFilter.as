package Utils 
{
	import Birds.Bird;
	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Dynamics.b2ContactFilter;
	
	/**
	 * ...
	 * @author ...
	 */
	public class BirdContactFilter extends b2ContactFilter 
	{
		
		public function BirdContactFilter() 
		{
			
		}
		override public function ShouldCollide(shape1:b2Shape, shape2:b2Shape):Boolean 
		{
			
			if ((shape1.GetBody().GetUserData() is Bird) && (shape2.GetBody().GetUserData() is Bird)) 
			{
				return false;
			}
			return true;
		}
		
	}

}