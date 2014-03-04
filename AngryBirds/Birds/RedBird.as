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
	public class RedBird extends Bird
	{
		public function RedBird(po:Point)
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
					fea = new RedFeather1(2);
				}
				else
				{
					fea = new RedFeather2(2);
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
			//设置刚体定义
			this.AngryBodyDef = new b2BodyDef();
			this.AngryBodyDef.angularDamping = 3;
			this.AngryBodyDef.position.Set(Position.x / 30, Position.y / 30);
			this.AngryCircleDef = new b2CircleDef();
			this.AngryCircleDef.radius = this.width / 60;
			this.AngryCircleDef.density = KeyData.Density_RedBird;
			this.AngryCircleDef.friction = KeyData.Friction_RedBird;
			this.AngryCircleDef.restitution = KeyData.Restitution_RedBird;
			
			AngryBodyDef.userData = this;
			
			AngryBody = BirdWorld.world.CreateBody(AngryBodyDef);
			AngryBody.CreateShape(AngryCircleDef);
			AngryBody.SetMassFromShapes();
			super.setAngryBody();
		}
	
	}

}