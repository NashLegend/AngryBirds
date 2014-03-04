package Materials 
{
	import Ashes.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	import Box2D.Dynamics.Contacts.*;
	import Data.KeyData;
	import flash.geom.Point;
	import Score.ScoreCounter;
	/**
	 * ...
	 * @author IJUST
	 */
	public class Stone extends Material 
	{
		public function Stone(po:Point)
		{
			super(po);
		}
		override public function generateAshes():void
		{
			if (HasGe)
			{
				return;
			}
			HasGe = true;
			var G_Point:Point = new Point(this.AngryBody.GetPosition().x * 30, this.AngryBody.GetPosition().y * 30);
			var NumFeather:int = 10;
			for (var i:int = 0; i < NumFeather; i++)
			{
				var fea:Ash;
				var ra = Math.random();
				if (ra <= 0.3) //确定类型
				{
					fea = new StoneAsh1(1.3);
				}
				else if (ra>0.3&&ra<=0.7) 
				{
					fea = new StoneAsh2(1.3);
				}
				else 
				{
					fea = new StoneAsh3(1.3);
				}
				fea.x = G_Point.x - this.width / 2 + Math.random() * this.width;
				fea.y = G_Point.y - this.height / 2 + Math.random() * this.height; //事实上不是半径
				fea.scal = 0.95;
				BirdWorld.BirdStage.ash.addChild(fea);
			}
			super.generateAshes();
		}
		override public function setAngryBody():void 
		{
			//设置刚体定义
			this.AngryBodyDef = new b2BodyDef();
			AngryBodyDef.position.Set(Position.x / 30, Position.y / 30);
			
			
			this.AngryBoxDef = new b2PolygonDef();
			this.AngryBoxDef.SetAsBox(this.width / 60, this.height / 60);
			this.AngryBoxDef.density = KeyData.Density_Stone;
			this.AngryBoxDef.friction = KeyData.Friction_Stone;
			this.AngryBoxDef.restitution = KeyData.Restitution_Stone;
			
			AngryBodyDef.userData = this;
			
			
			AngryBody = BirdWorld.world.CreateBody(AngryBodyDef);
			AngryBody.CreateShape(AngryBoxDef);
			AngryBody.SetMassFromShapes();
			
			super.setAngryBody();
			
			
		}
		override public function setShapeByHP():void 
		{
			if (this.HP>this.HP_origin*0.75&&this.HP<=this.HP_origin) //  0.75-1
			{
				gotoAndStop(1);
			}
			else if (this.HP>this.HP_origin*0.5&&this.HP<=this.HP_origin*0.75) //0.5-0.75
			{
				gotoAndStop(2);
			}
			else if (this.HP>this.HP_origin*0.25&&this.HP<=this.HP_origin*0.5) //0.25-0.50
			{
				gotoAndStop(3);
			}
			else if(this.HP>0&&this.HP<=this.HP_origin*0.25)//0.00-0.25
			{
				 gotoAndStop(4);
			}
			else //<=0
			{
				
				generateAshes();
				this.removeFromWorld();
			}
		}
		
		override public function handleContact(HittedBody:BaseObject, ContactPoint:b2ContactPoint):void 
		{
			//若碰撞的是地面，这里不作处理，全部交由地面类处理
			Harm = int(HittedBody.AngryBody.GetMass() * ContactPoint.velocity.Length());
			this.HP -= Harm;
			ScoreCounter.Scores += Harm;
			BirdWorld.Score_Board.ScoreBoard.text = ScoreCounter.Scores.toString();
			
			setShapeByHP();
			
			super.handleContact(HittedBody, ContactPoint);
		}
		
	}

}