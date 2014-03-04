package  
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
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.utils.*;
	import flash.utils.getDefinitionByName;
	import Materials.Ground;
	import Materials.Material;
	import Missions.Mission;
	import Missions.MissionItem;
	import Pigs.Pig;
	import Score.ScoreCounter;
	import StaticObjects.StaticObject;
	import Tools.bubble;
	import Tools.Bubble1;
	import Tools.Bubble2;
	import Tools.Hand;
	import Tools.MissionFailPanel;
	import Tools.MissionPassPanel;
	import Tools.Slingshot;
	import Utils.BirdContactFilter;
	import Utils.BirdContactListener;
	/**
	 * ...
	 * @author IJUST
	 */
	public class BirdWorld extends EventDispatcher
	{
		public static var m_iterations:int = 10;
		public static var m_timeStep:Number = 1.0/30.0;
		public static var world:b2World;
		public static var BirdWaitingArray:Array = [];
		public static var PigArray:Array = [];
		public static var MaterialArray:Array = [];
		public static var bodyArray:Array = [];
		public static var B2BodyArray:Array = [];
		public static var BubbleArray:Array = [];
		public static var CurrentBird:Bird;
		public static var BirdStage:BirdScene;//世界的显示列表
		public static var sling:Slingshot;
		public static var ground:Ground;
		public static var CurrentBirdState:String = KeyData.Bird_Current_Dead;
		public static var debug:Sprite;
		public static var HasJump:Boolean = false;
		public static var HasClicked:Boolean = false;//已经点击使小鸟反应
		public static var M_PassPanel:MissionPassPanel;
		public static var M_FailPanel:MissionFailPanel;
		public static var Score_Board:ScoreCounter;
		public static var AngryHand:Hand;
		public static var stag:Stage;
		public static var HasFail:Boolean = false;
		public static var HasPass:Boolean = false;
		public static var IsRunning:Boolean = false;
		public static var YesCan:Boolean = false;
		public static var inc:int = 1;
		
		public function BirdWorld()
		{
			
		}
		public static function AddAllObjs():void
		{
			for (var i:int = 0; i < Mission.CurrentMissionArray.length; i++)
			{
				var item:MissionItem = Mission.CurrentMissionArray[i] as MissionItem;//这里已经获得了单个产品的信息
				
				if (item.Type=="Tools.Slingshot")
				{
					sling = new Slingshot();
					sling.x = item.PositionX;
					sling.y = item.PositionY;
					BirdStage.sling.addChild(sling);
				}
				else
				{
					var BaseType:Class = getDefinitionByName(item.Type) as Class;
					var WorldRigid:BaseObject = new BaseType(new Point(item.PositionX, item.PositionY));//这里实例化了此物体,我靠旋转怎么搞
					WorldRigid.AngryAngle = item.Angle * Math.PI / 180;
					WorldRigid.rotation = item.Angle;
					
					//根据不同的类型添加数组  地面要单独拿出来
					if (item.Type=="Materials.Ground") 
					{
						BirdWorld.ground = WorldRigid as Ground;
						BirdStage.ground.addChild(WorldRigid);
					}
					else 
					{
						if (WorldRigid is Bird) 
						{
							BirdWaitingArray.push(WorldRigid);
							bodyArray.push(WorldRigid);
							BirdStage.bird.addChild(WorldRigid);
						}
						if (WorldRigid is Material || WorldRigid is StaticObject)
						{
							MaterialArray.push(WorldRigid);
							bodyArray.push(WorldRigid);
							BirdStage.mat.addChild(WorldRigid);
						}
						if (WorldRigid is Pig) 
						{
							PigArray.push(WorldRigid);
							bodyArray.push(WorldRigid);
							BirdStage.pig.addChild(WorldRigid);
						}
					}
					B2BodyArray.push(WorldRigid.AngryBody);
				}
			}
			AngryHand = new Hand();
			BirdStage.Hands.addChild(AngryHand);
			
			//当添加完了后就可以开始了
			BirdWorld.CurrentBirdState = KeyData.Bird_Current_Dead;
			BirdWorld.IsRunning = true;
			BirdWorld.HasFail = false;
			BirdWorld.HasPass = false;
		}
		
		public static function Bird_Jump_On_Slingshot():void
		{
			BirdWorld.YesCan = false;
			HasJump = true;
			//让小鸟跳上弹弓
			CurrentBird = BirdWaitingArray[0] as Bird;
			CurrentBird.BirdState = KeyData.Bird_State_On_Slingshot;
			CurrentBirdState = KeyData.Bird_State_On_Slingshot;
			//小鸟跳到弹弓上  这里并没有做效果  以后再说
			CurrentBird.x = sling.x;
			CurrentBird.y = sling.y;
			//弹弓获得小鸟
			sling.getBird(CurrentBird);
			//从地面上的鸟儿数组中去掉这货
			BirdWaitingArray.splice(0, 1);
		}
		
		public static function generateBubbles(BubbleBird:Bird):void 
		{
			//产生泡泡
			if (Math.random()<0.5)
			{
				var ball1:Bubble1 = new Bubble1();
				ball1.x = BubbleBird.x;
				ball1.y = BubbleBird.y;
				BirdStage.bubble.addChild(ball1);
				BubbleArray.push(ball1);
			}
			else 
			{
				var ball2:Bubble2 = new Bubble2();
				ball2.x = BubbleBird.x;
				ball2.y = BubbleBird.y;
				BirdStage.bubble.addChild(ball2);
				BubbleArray.push(ball2);
			}
		}
		
		public static function ClearBubble():void
		{
			for (var i:int = BubbleArray.length-1; i >=0 ; i--)
			{
				var bu:bubble = BubbleArray[i] as bubble;
				if (bu.parent)
				{
					bu.parent.removeChild(bu);
					BubbleArray.splice(i, 1);
				}
			}
		}
		
		public static function CheckAllPigsDead():Boolean 
		{
			var flag:Boolean = false;
			if (PigArray.length==0) 
			{
				flag = true;
			}
			else 
			{
				flag = false;
			}
			return flag;
		}
		
		public static function CheckAllIsStop():Boolean
		{
			var flag:Boolean = true;
			for (var i:int = 0; i < bodyArray.length; i++) 
			{
				var item:BaseObject = bodyArray[i] as BaseObject;
				if (item.AngryBody.GetLinearVelocity().Length()>0.2)
				{
					flag = false;
					break;
				}
			}
			return flag;
		}
		public static function removeDead():void
		{
			for (var i:int = 0; i < bodyArray.length; i++)
			{
				var item:BaseObject = bodyArray[i] as BaseObject;
				if (item.removeable)
				{
					setTimeout(DelayKill, 150,item);
					bodyArray.splice(i, 1);
				}
			}
		}
		public static function DelayKill():void
		{
			BirdWorld.destroyBody(arguments[0].AngryBody);
			BirdWorld.removeFromWorld(arguments[0]);
		}
		public static function update():void
		{
			AngryHand.x = BirdWorld.BirdStage.mouseX;
			AngryHand.y = BirdWorld.BirdStage.mouseY;
			if (!IsRunning)
			{
				return;
			}
			if (HasJump)
			{
				removeDead();
			}
			if (IsRunning)
			{
				BirdWorld.world.Step(m_timeStep, m_iterations);
				for (var i:int = 0; i < bodyArray.length; i++)
				{
					var item:BaseObject = bodyArray[i] as BaseObject;
					item.update();
				}
			}
			if (CurrentBirdState==KeyData.Bird_Current_Dead&&IsRunning&&!HasPass&&!HasFail) //如果小鸟已死 判断
			{
				if (CheckAllPigsDead())
				{
					//如果猪头都死了则过关
					HasPass = true;
					setTimeout(removeall, 2000);
					setTimeout(MissionPass, 4000);
				}
				else 
				{
					if (CheckAllIsStop())
					{
						if (BirdWaitingArray.length!=0) //如果还有鸟
						{
							if (!CurrentBird) 
							{
								Bird_Jump_On_Slingshot();
							}
						}
						else 
						{
							HasFail = true;
							setTimeout(removeall, 2000);
							setTimeout(MissionFailed, 4000);
						}
					}
				}
			}
		}
		
		public static function MissionFailed():void 
		{
			BirdWorld.CurrentBirdState = KeyData.Bird_Current_Dead;
			IsRunning = false;
			clearWorld();
			M_FailPanel = new MissionFailPanel();
			BirdStage.Count.addChild(M_FailPanel);
			M_FailPanel.x = KeyData.StageWidth / 2 - 220- BirdStage.x;
			M_FailPanel.y = KeyData.StageHeight / 2 - 90;
		}
		
		public static function MissionPass():void
		{
			BirdWorld.CurrentBirdState = KeyData.Bird_Current_Dead;
			IsRunning = false;
			clearWorld();
			M_PassPanel = new MissionPassPanel();
			BirdStage.Count.addChild(M_PassPanel);
			M_PassPanel.x = KeyData.StageWidth / 2 - 220 - BirdStage.x;
			M_PassPanel.y = KeyData.StageHeight / 2 - 90;
		}
		
		public static function destroyBody(desBody:b2Body):void 
		{
			for (var i:int = 0; i < B2BodyArray.length; i++)
			{
				var item:b2Body = B2BodyArray[i] as b2Body;
				if (desBody==item)
				{
					world.DestroyBody(desBody);
					B2BodyArray.splice(i, 1);
				}
			}
		}
		
		public static function removeFromWorld(obj:BaseObject):void 
		{
			if (obj.parent) 
			{
				obj.parent.removeChild(obj);
			}
			
			if (obj is Bird) 
			{
				if (obj == BirdWorld.CurrentBird) 
				{
					BirdWorld.removeCurrentBird();
				}
				else 
				{
					for (var k:int = 0; k < BirdWaitingArray.length; k++) 
					{
						var itemb:Bird = BirdWaitingArray[k] as Bird;
						if (obj==itemb)
						{
							BirdWaitingArray.splice(k, 1);
							break;
						}
					}
				}
			}
			if (obj is Pig) 
			{
				for (var i:int = 0; i < PigArray.length; i++) 
				{
					var item:Pig = PigArray[i] as Pig;
					if (obj==item) 
					{
						PigArray.splice(i, 1)
						break;
					}
				}
			}
			if (obj is Material) 
			{
				for (var j:int = 0; j < MaterialArray.length; j++) 
				{
					var item1:Material = MaterialArray[j] as Material;
					if (obj==item1) 
					{
						MaterialArray.splice(j,1);
						break;
					}
				}
			}
		}
		
		public static function GenerateWorld():void
		{
			//实例化刚体世界
			var AngryWorldAABB:b2AABB = new b2AABB();
			AngryWorldAABB.lowerBound.Set(-60.0,-60.0);
			AngryWorldAABB.upperBound.Set(100.0, 100.0);
			var AngryGravity:b2Vec2 = new b2Vec2(0.0, 8);
			var AngryAllowSleep:Boolean = true;
			//设置世界
			BirdWorld.world = new b2World(AngryWorldAABB, AngryGravity, AngryAllowSleep);
			//设置碰撞侦听
			BirdWorld.world.SetContactListener(new BirdContactListener());
			BirdWorld.world.SetContactFilter(new BirdContactFilter());
			
			//设置Debug
			//var dbgDraw:b2DebugDraw = new b2DebugDraw();
			//debug = BirdStage.debug_Draw;
			//dbgDraw.m_sprite = debug;
			//dbgDraw.m_drawScale = 30.0;
			//dbgDraw.m_fillAlpha = 0.3;
			//dbgDraw.m_lineThickness = 1.0;
			//dbgDraw.m_drawFlags = b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit;
			//world.SetDebugDraw(dbgDraw);
		}
		public static function removeCurrentBird():void
		{
			BirdWorld.destroyBody(CurrentBird.AngryBody);
			if (CurrentBird.parent) 
			{
				CurrentBird.parent.removeChild(CurrentBird);
			}
			CurrentBirdState = KeyData.Bird_Current_Dead;
			CurrentBird = null;
			
		}
		public static function setDebug():void 
		{
			
		}
		public static function removeall():void 
		{
			ClearBubble();
			
			for (var b:int = bodyArray.length-1; b >=0 ; b--)
			{
				var itemy:BaseObject = bodyArray[b] as BaseObject;
				if (itemy) 
				{
					bodyArray.splice(b, 1);
					BirdWorld.destroyBody(itemy.AngryBody);
					BirdWorld.removeFromWorld(itemy);
				}
				bodyArray.splice(b, 1);
			}
			
			if (sling&&sling.parent) 
			{
				sling.parent.removeChild(sling);
			}
		}
		public static function clearWorld():void
		{
			//ClearBubble();
			
			IsRunning = false;
			
			if (CurrentBird) 
			{
				removeCurrentBird();
			}
			
			
			
			if (world) 
			{
				for (var bb:b2Body = world.m_bodyList; bb; bb = bb.m_next)
				{
					try 
					{
						world.DestroyBody(bb);
					}
					catch (err:Error)
					{
						
					}
				}
			}
			if (AngryHand&&AngryHand.parent) 
			{
				AngryHand.parent.removeChild(AngryHand);
			}
			Mouse.show();
			BirdWaitingArray = [];
			bodyArray = [];
			PigArray = [];
			MaterialArray = [];
			B2BodyArray = [];
			BirdWorld.HasJump = false;
			BirdWorld.CurrentBirdState = KeyData.Bird_Current_Dead;
			
			
			
			
		}
		
		public static function removeStage():void 
		{
			if (ground) 
			{
				
				if (ground.AngryBody) 
				{
					try 
					{
						BirdWorld.world.DestroyBody(ground.AngryBody);
					}
					catch (err:Error)
					{
						
					}
				}
				
				if (ground.parent) 
				{
					ground.parent.removeChild(ground);
				}
				
			}
			
			if (world) 
			{
				BirdWorld.world = null;
			}
			
			
			if (BirdStage) 
			{
				if (BirdStage.parent) 
				{
					BirdStage.parent.removeChild(BirdStage);
				}
			}
		}
	}

}