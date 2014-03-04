package Utils 
{
	import Box2D.Collision.*;
    import Box2D.Dynamics.*;
	/**
	 * ...
	 * @author IJUST
	 */
	public class BirdContactListener extends b2ContactListener
	{
		
		public function BirdContactListener() 
		{
			
		}
		
		override public function Add(BirdPoint:b2ContactPoint):void
		{
			var AngryBody1:BaseObject = BirdPoint.shape1.GetBody().GetUserData() as BaseObject;
			var AngryBody2:BaseObject = BirdPoint.shape2.GetBody().GetUserData() as BaseObject;
			
			if (AngryBody1&&AngryBody2) 
			{
				AngryBody1.handleContact(AngryBody2, BirdPoint);
				AngryBody2.handleContact(AngryBody1, BirdPoint);
			}
			else if (AngryBody1) 
			{
				AngryBody1.handleNoContact(BirdPoint);
			}
			else if (AngryBody2) 
			{
				AngryBody2.handleNoContact(BirdPoint);
			}
		}
		
		
		
	}

}