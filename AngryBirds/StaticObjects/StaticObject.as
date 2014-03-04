package StaticObjects 
{
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	import Box2D.Dynamics.Contacts.*;
	import flash.geom.Point;
	/**
	 * ...
	 * @author IJUST
	 */
	public class StaticObject extends BaseObject 
	{
		
		public function StaticObject(po:Point) 
		{
			super(po);
		}
		override public function handleContact(HittedBody:BaseObject, ContactPoint:b2ContactPoint):void 
		{
			HittedBody.HP -= HittedBody.AngryBody.GetMass() * ContactPoint.velocity.Length() * 3;
			HittedBody.Harm = HittedBody.AngryBody.GetMass() * ContactPoint.velocity.Length() * 3 / HittedBody.AngryBody.GetMass();
			HittedBody.generateAshes();
			super.handleContact(HittedBody, ContactPoint);
		}
		
	}

}