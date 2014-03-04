package Birds 
{
	import Ashes.Ash;
	import Ashes.BlueFeather1;
	import Ashes.BlueFeather2;
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
	public class BlueBird extends Bird 
	{
		public function BlueBird(po:Point) 
		{
			super(po);
			this.name="blue"
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
				if (Math.random()<0.5) //确定类型
				{
					fea = new BlueFeather1(2);
				}
				else 
				{
					fea = new BlueFeather2(2);
				}
				fea.x = G_Point.x - Rad + Math.random() * Rad * 2;
				fea.y = G_Point.y - Rad + Math.random() * Rad * 2;//事实上不是半径
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
			AngryBodyDef.position.Set(Position.x/30, Position.y/30);
			
			this.AngryCircleDef = new b2CircleDef();
			this.AngryCircleDef.radius = this.width / 60;
			this.AngryCircleDef.density = KeyData.Density_BlueBird;
			this.AngryCircleDef.friction = 0.3;
			this.AngryCircleDef.restitution = 0.3;
			
			
			AngryBodyDef.userData = this;
			
			
			AngryBody = BirdWorld.world.CreateBody(AngryBodyDef);
			AngryBody.CreateShape(AngryCircleDef);
			AngryBody.SetMassFromShapes();
			super.setAngryBody();
		}
		override protected function AfterClick():void 
		{
			var VX:Number = this.AngryBody.GetLinearVelocity().x;
			var VY:Number = this.AngryBody.GetLinearVelocity().y;
			var VV:Number = this.AngryBody.GetLinearVelocity().Length();
			var VA:Number = Math.atan2(VY, VX) * 180 / Math.PI; 
			
			var VU:Number = VA - KeyData.TurnAngle;
			var VD:Number = VA + KeyData.TurnAngle;
			
			var VXU:Number = VV * Math.cos(VU*Math.PI/180);
			var VYU:Number = VV * Math.sin(VU * Math.PI / 180);
			var VSU:Number = Math.sqrt(VXU * VXU + VYU * VYU);
			
			var VXD:Number = VV * Math.cos(VD*Math.PI/180);
			var VYD:Number = VV * Math.sin(VD * Math.PI / 180);
			var VSD:Number = Math.sqrt(VXD*VXD+VYD*VYD);
			
			var BirdUpPoint:Point = new Point(this.x + VXU / VSU * 30, this.y + VYU / VSU * 30);
			var BirdDownPoint:Point = new Point(this.x + VXD / VSD * 30, this.y + VYD / VSD * 30);
			
			var blueup:BlueBird = new BlueBird(BirdUpPoint);
			blueup.rotation = this.rotation - KeyData.TurnAngle;
			blueup.BirdState = KeyData.Bird_State_On_Flying;
			BirdWorld.BirdStage.addChild(blueup);
			BirdWorld.BirdWaitingArray.push(blueup);
			BirdWorld.bodyArray.push(blueup);
			BirdWorld.B2BodyArray.push(blueup.AngryBody);
			blueup.AngryBody.SetLinearVelocity(new b2Vec2(VXU, VYU));
			blueup.BirdHasSling = true;
			blueup.CanBubble = true;
			blueup.AngryBody.WakeUp();
			//下鸟
			var bluedown:BlueBird = new BlueBird(BirdDownPoint);
			bluedown.rotation = this.rotation + KeyData.TurnAngle;
			bluedown.BirdState = KeyData.Bird_State_On_Flying;
			BirdWorld.BirdStage.addChild(bluedown);
			BirdWorld.BirdWaitingArray.push(bluedown);
			BirdWorld.bodyArray.push(bluedown);
			BirdWorld.B2BodyArray.push(bluedown.AngryBody);
			bluedown.AngryBody.SetLinearVelocity(new b2Vec2(VXD, VYD));
			bluedown.BirdHasSling = true;
			bluedown.CanBubble = true;
			bluedown.AngryBody.WakeUp();
			
			super.AfterClick();
		}
	}

}