package Birds 
{
	import Ashes.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	import Box2D.Dynamics.Contacts.*;
	import Data.KeyData;
	import flash.geom.Point;
	import flash.utils.*;
	/**
	 * ...
	 * @author IJUST
	 */
	public class YellowBird extends Bird 
	{
		
		public function YellowBird(po:Point)
		{
			super(po);
		}
		override public function generateAshes():void
		{
			if (this.Harm<KeyData.Bird_Harm_Feather||!this.CanAsh)
			{
				return;
			}
			var G_Point:Point = new Point(this.AngryBody.GetPosition().x * 30, this.AngryBody.GetPosition().y * 30);
			var NumFeather:int = this.Harm / KeyData.Bird_Harm_To_Feathers;
			NumFeather = (NumFeather < KeyData.FeatherMax)?NumFeather:KeyData.FeatherMax;
			NumFeather = (NumFeather > 2)?NumFeather:2;
			var Rad:Number = this.width/2;
			for (var i:int = 0; i < NumFeather; i++)
			{
				var fea:Ash;
				if (Math.random() < 0.5) //确定类型
				{
					fea = new YellowFeather1(2);
				}
				else
				{
					fea = new YellowFeather2(2);
				}
				fea.x = G_Point.x - Rad + Math.random() * Rad * 2;
				fea.y = G_Point.y - Rad + Math.random() * Rad * 2; //事实上不是半径
				BirdWorld.BirdStage.ash.addChild(fea);
			}
			
			this.CanAsh = false;
			
			setTimeout(block, 500);
		}
		override public function setAngryBody():void 
		{
			this.AngryBodyDef = new b2BodyDef();
			this.AngryBodyDef.position.Set(Position.x / 30, Position.y / 30);
			this.AngryBoxDef = new b2PolygonDef();
			this.AngryBoxDef.vertexCount = 3;
			this.AngryBoxDef.vertices[0].Set(0, -23 / 30);
			this.AngryBoxDef.vertices[1].Set( 30 / 30, 20 / 30);
			this.AngryBoxDef.vertices[2].Set(-26 / 30, 20 / 30);
			this.AngryBoxDef.density = KeyData.Density_YellowBird;
			this.AngryBoxDef.friction = KeyData.Friction_YellowBird;
			this.AngryBoxDef.restitution = KeyData.Restitution_YellowBird;
			AngryBodyDef.userData = this;
			AngryBody = BirdWorld.world.CreateBody(AngryBodyDef);
			AngryBody.CreateShape(AngryBoxDef);
			AngryBody.SetMassFromShapes();
			super.setAngryBody();
		}
		override protected function AfterClick():void 
		{
			AngryBody.SetLinearVelocity(new b2Vec2(this.AngryBody.GetLinearVelocity().x*KeyData.SpeedUp,this.AngryBody.GetLinearVelocity().y*KeyData.SpeedUp));
			super.AfterClick();
		}
		
	}

}