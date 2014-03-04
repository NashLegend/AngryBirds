package StaticObjects 
{
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	import Box2D.Dynamics.Contacts.*;
	import Box2D.Dynamics.Joints.*;
	import Data.KeyData;
	import flash.geom.Point;
	/**
	 * ...
	 * @author ...
	 */
	public class StaticEightS extends StaticObject 
	{
		public function StaticEightS(po:Point) 
		{
			super(po);
		}
		override public function setAngryBody():void
		{
			this.AngryBodyDef = new b2BodyDef();
			this.AngryBodyDef.position.Set(Position.x / 30, Position.y / 30);
			
			this.AngryBoxDef = new b2PolygonDef();
			this.AngryBoxDef.vertexCount = 4;
			this.AngryBoxDef.vertices[0].Set(116/30, -50 / 30);
			this.AngryBoxDef.vertices[1].Set( 170 / 30, 40 / 30);
			this.AngryBoxDef.vertices[2].Set( 20 / 30, 3 / 30);
			this.AngryBoxDef.vertices[3].Set( 70 / 30, -50 / 30);
			
			
			
			var AnotherBoxDef:b2PolygonDef = new b2PolygonDef();
			AnotherBoxDef.vertexCount = 4;
			AnotherBoxDef.vertices[0].Set( 170 / 30, 40 / 30);
			AnotherBoxDef.vertices[1].Set( -180 / 30, 40 / 30);
			AnotherBoxDef.vertices[2].Set( -153 / 30, 3 / 30);
			AnotherBoxDef.vertices[3].Set( 20 / 30, 3 / 30);
			
			
			this.AngryBoxDef.density = KeyData.Density_1s;
			this.AngryBoxDef.friction = KeyData.Friction_1s;
			this.AngryBoxDef.restitution = KeyData.Restitution_1s;
			
			AnotherBoxDef.density = KeyData.Density_1s;
			AnotherBoxDef.friction = KeyData.Friction_1s;
			AnotherBoxDef.restitution = KeyData.Restitution_1s;
			
			AngryBodyDef.userData = this;
			AngryBody = BirdWorld.world.CreateBody(AngryBodyDef);
			AngryBody.CreateShape(AngryBoxDef);
			AngryBody.CreateShape(AnotherBoxDef)
			AngryBody.SetMassFromShapes();
			super.setAngryBody();
		}
		
	}

}