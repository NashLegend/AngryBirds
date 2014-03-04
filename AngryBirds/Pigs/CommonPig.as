package Pigs 
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
	public class CommonPig extends Pig 
	{
		
		public function CommonPig(po:Point)
		{
			this.Density = KeyData.Density_CommonPig;
			this.Friction = KeyData.Friction_CommonPig;
			this.Restitution = KeyData.Restitution_CommonPig;
			this.HP = KeyData.HP_CommonPig;
			super(po);
		}
		
		override public function setAngryBody():void 
		{
			
			this.AngryBodyDef = new b2BodyDef();
			this.AngryBodyDef.angularDamping = 6;
			AngryBodyDef.position.Set(Position.x/30, Position.y/30);
			
			
			this.AngryCircleDef = new b2CircleDef();
			this.AngryCircleDef.radius = this.width / 60;
			this.AngryCircleDef.density = KeyData.Density_CommonPig;
			this.AngryCircleDef.friction = KeyData.Friction_CommonPig;
			this.AngryCircleDef.restitution = KeyData.Restitution_CommonPig;
			AngryBodyDef.userData = this;
			
			
			AngryBody = BirdWorld.world.CreateBody(AngryBodyDef);
			AngryBody.CreateShape(AngryCircleDef);
			AngryBody.SetMassFromShapes();
			super.setAngryBody();
		}
		
	}

}