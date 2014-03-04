package Birds 
{
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
	public class Bird extends BaseObject
	{
		public var BirdState:String = KeyData.Bird_State_On_Ground;//默认值为鸟儿在地上
		public var BirdHasSling:Boolean = false;
		public var CanBubble:Boolean = false;
		public var HasStartTimer:Boolean = false;
		public var CanAsh:Boolean = true;
		public function Bird(po:Point) 
		{
			super(po);
			this.name = "bird";
			this.mouseEnabled = false;
		}
		protected function block():void 
		{
			this.CanAsh = true;
		}
		override public function setAngryBody():void 
		{
			super.setAngryBody();
			this.AngryBody.PutToSleep();//停止模拟  只有当放到弹弓上发射出去之后才开始模拟
		}
		
		public function BirdClick():void 
		{
			if (this.BirdState==KeyData.Bird_State_On_Flying&&BirdWorld.HasClicked==false)
			{
				AfterClick();
			}
		}
		
		protected function AfterClick():void
		{
			BirdWorld.HasClicked = true;
			BirdWorld.YesCan = false;
		}
		
		override public function handleContact(HittedBody:BaseObject, ContactPoint:b2ContactPoint):void 
		{
			if (!this.BirdHasSling)
			{
				return;
			}
			if (!HasStartTimer)
			{
				HasStartTimer = true;
				setTimeout(KillBirdDelay, 10000);
			}
			this.CanBubble = false;
			this.Harm = HittedBody.AngryBody.GetMass() * ContactPoint.velocity.Length() * KeyData.Harm_Coefficient_Bird_To_Pig;
			this.HP -= this.Harm;
			
			this.Harm = this.Harm / this.AngryBody.GetMass();
			this.BirdState = KeyData.Bird_State_On_HitObjects;
			//BirdWorld.CurrentBirdState = KeyData.Bird_State_On_HitObjects;
			super.handleContact(HittedBody, ContactPoint);
			generateAshes();
		}
		
		override public function update():void
		{
			super.update();
			if (this.x<-300||this.x>KeyData.Bird_Die_Distance)
			{
				removeFromWorld();
			}
			if (this.BirdState==KeyData.Bird_State_On_HitObjects) 
			{
				if (this.AngryBody.IsFrozen()==true) 
				{
					removeFromWorld();
				}
				if (Math.abs(this.AngryBody.GetLinearVelocity().Length())<KeyData.Bird_Die_Speed) 
				{
					setTimeout(SpeedCheck, 1000);
				}
			}
			if (this.BirdState == KeyData.Bird_State_On_Flying) 
			{
				if (this.AngryBody.IsFrozen()) 
				{
					removeFromWorld();
				}
			}
			if (CanBubble)
			{
				BirdWorld.generateBubbles(this);
			}
		}
		protected function KillBirdDelay():void 
		{
			removeFromWorld();
		}
		protected function SpeedCheck():void 
		{
			if (Math.abs(this.AngryBody.GetLinearVelocity().Length())<KeyData.Bird_Die_Speed) 
			{
				removeFromWorld();
			}
		}
		
	}

}