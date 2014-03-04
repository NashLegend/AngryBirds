package Materials 
{
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	import Box2D.Dynamics.Contacts.*;
	import Data.KeyData;
	import flash.geom.Point;
	/**
	 * ...
	 * @author IJUST
	 */
	public class Ground extends Material
	{
		public function Ground(po:Point)
		{
			super(po);
		}
		override public function setAngryBody():void
		{
			this.AngryBodyDef = new b2BodyDef();
			AngryBodyDef.position.Set(Position.x / 30, Position.y / 30);
			
			this.AngryBoxDef = new b2PolygonDef();
			this.AngryBoxDef.SetAsBox(this.width / 60 , this.height / 60);
			this.AngryBoxDef.density = 0;
			this.AngryBoxDef.friction = KeyData.Friction_Ground;
			this.AngryBoxDef.restitution = KeyData.Restitution_Ground;
			
			AngryBodyDef.userData = this;
			
			AngryBody = BirdWorld.world.CreateBody(AngryBodyDef);
			AngryBody.CreateShape(AngryBoxDef);
			AngryBody.SetMassFromShapes();
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