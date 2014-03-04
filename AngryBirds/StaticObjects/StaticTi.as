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
	 * @author IJUST
	 */
	public class StaticTi extends StaticObject 
	{
		
		public function StaticTi(po:Point) 
		{
			super(po);
			
		}
		override public function setAngryBody():void
		{
			this.AngryBodyDef = new b2BodyDef();
			this.AngryBodyDef.position.Set(Position.x / 30, Position.y / 30);
			this.AngryBoxDef = new b2PolygonDef();
			this.AngryBoxDef.vertexCount = 4;
			this.AngryBoxDef.vertices[0].Set(75/30, -25 / 30);
			this.AngryBoxDef.vertices[1].Set( 115 / 30, 20 / 30);
			this.AngryBoxDef.vertices[2].Set( -115 / 30, 20 / 30);
			this.AngryBoxDef.vertices[3].Set( -75 / 30, -25 / 30);
			this.AngryBoxDef.density = KeyData.Density_1s;
			this.AngryBoxDef.friction = KeyData.Friction_1s;
			this.AngryBoxDef.restitution = KeyData.Restitution_1s;
			AngryBodyDef.userData = this;
			AngryBody = BirdWorld.world.CreateBody(AngryBodyDef);
			AngryBody.CreateShape(AngryBoxDef);
			AngryBody.SetMassFromShapes();
			super.setAngryBody();
		}
		
		
	}

}