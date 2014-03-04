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
	public class LittlePig extends Pig 
	{
		
		public function LittlePig(po:Point) 
		{
			this.Density = KeyData.Density_LittlePig;
			this.Friction = KeyData.Friction_LittlePig;
			this.Restitution = KeyData.Restitution_LittlePig;
			this.HP = KeyData.HP_LittlePig;
			super(po);
		}
		
		override public function setAngryBody():void 
		{
			
			this.AngryBodyDef = new b2BodyDef();
			this.AngryBodyDef.angularDamping = 6;
			AngryBodyDef.position.Set(Position.x/30, Position.y/30);
			
			
			this.AngryCircleDef = new b2CircleDef();
			this.AngryCircleDef.radius = this.width / 60;
			this.AngryCircleDef.density = KeyData.Density_LittlePig;
			this.AngryCircleDef.friction = KeyData.Friction_LittlePig;
			this.AngryCircleDef.restitution = KeyData.Restitution_LittlePig;
			AngryBodyDef.userData = this;
			
			
			AngryBody = BirdWorld.world.CreateBody(AngryBodyDef);
			AngryBody.CreateShape(AngryCircleDef);
			AngryBody.SetMassFromShapes();
			super.setAngryBody();
		}
		
	}

}