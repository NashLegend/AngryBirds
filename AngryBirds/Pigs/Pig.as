package Pigs
{
	import Birds.Bird;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	import Box2D.Dynamics.Contacts.*;
	import Box2D.Dynamics.Joints.*;
	import Data.KeyData;
	import flash.geom.Point;
	import Score.ScoreCounter;
	/**
	 * ...
	 * @author IJUST
	 */
	public class Pig extends BaseObject
	{
		
		public function Pig(po:Point)
		{
			this.mouseEnabled = false;
			super(po)
		}
		
		override public function setAngryBody():void 
		{
			super.setAngryBody();
		}
		
		override public function handleContact(HittedBody:BaseObject, ContactPoint:b2ContactPoint):void 
		{
			//若碰撞的是地面，这里不作处理，全部交由地面类处理
			if (HittedBody is Bird) 
			{
				Harm= HittedBody.AngryBody.GetMass() * ContactPoint.velocity.Length() * KeyData.Harm_Coefficient_Bird_To_Pig;
			}
			else 
			{
				Harm= HittedBody.AngryBody.GetMass() * ContactPoint.velocity.Length();
			}
			this.HP -= Harm;
			ScoreCounter.Scores += Harm * 5;
			BirdWorld.Score_Board.ScoreBoard.text = ScoreCounter.Scores.toString();
			if (this.HP>this.HP_origin*0.66&&this.HP<=this.HP_origin) //  0.75-1
			{
				gotoAndStop(1);
			}
			else if (this.HP>this.HP_origin*0.33&&this.HP<=this.HP_origin*0.66) //0.5-0.75
			{
				gotoAndStop(2);
			}
			else if (this.HP>0&&this.HP<=this.HP_origin*0.33) //0.25-0.50
			{
				gotoAndStop(3);
			}
			else //<=0
			{
				this.removeFromWorld();
			}
			super.handleContact(HittedBody, ContactPoint);
		}
		override public function update():void 
		{
			if (this.x>KeyData.Bird_Die_Distance||this.x<-100) 
			{
				removeFromWorld();
			}
			if (this.x>KeyData.Bird_Die_Distance&&this.AngryBody.GetLinearVelocity().Length()<1) 
			{
				removeFromWorld();
			}
			super.update();
		}
		override public function removeFromWorld():void 
		{
			ScoreCounter.Scores += 5000;
			BirdWorld.Score_Board.ScoreBoard.text = ScoreCounter.Scores.toString();
			super.removeFromWorld();
		}
		
		
		
	}

}