package  
{
	import Data.AngryEvent;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import Missions.Mission;
	import Score.ScoreCounter;
	import Tools.MissionPanel;
	import Tools.MissionPassPanel;
	import Tools.MissionFailPanel;
	import Data.KeyData;
	/**
	 * ...
	 * @author IJUST
	 */
	public class Main extends MovieClip
	{
		public var M_Panel:MissionPanel;
		public var birdscene:BirdScene
		public static var M_PassPanel:MissionPassPanel;
		public static var M_FailPanel:MissionFailPanel;
		public var Score_B:ScoreCounter;
		public function Main() 
		{
			AngryEvent.AngryBirdEvent.addEventListener(AngryEvent.MissionPass, MissionPass);
			AngryEvent.AngryBirdEvent.addEventListener(AngryEvent.NextMission, getNextMission);
			AngryEvent.AngryBirdEvent.addEventListener(AngryEvent.AllMissionsOver, AllMissionOver);
			AngryEvent.AngryBirdEvent.addEventListener(AngryEvent.MissionFailed, MissionFailed);
			AngryEvent.AngryBirdEvent.addEventListener(AngryEvent.AllDataLoaded, Loaded);
			
			startGame();//获得了参数后
		}
		private function MissionFailed(e:Event):void 
		{
			MissionStart();
		}
		private function Loaded(e:Event):void 
		{
			M_Panel = new MissionPanel();
			this.stage.addChild(M_Panel);
			M_Panel.x = this.stage.stageWidth / 2 - M_Panel.width / 2;
			M_Panel.y = this.stage.stageHeight / 2 - M_Panel.height / 2;
		}
		private function startGame():void 
		{
			//通过这一句来执行获得关卡的任务
			Mission.getMissionData();
		}
		private function MissionPass(e:Event):void
		{
			//过关
			removeEventListener(Event.ENTER_FRAME, update);
			Mission.CurrentMission += 1;
			if (Mission.CurrentMission>=Mission.MissionArray.length) 
			{
				AngryEvent.AngryBirdEvent.dispatchEvent(new Event(AngryEvent.AllMissionsOver));
			}
			else 
			{
				AngryEvent.AngryBirdEvent.dispatchEvent(new Event(AngryEvent.NextMission));
			}
		}
		private function AllMissionOver(e:Event):void 
		{
			BirdWorld.removeStage();
		}
		private function getNextMission(e:Event):void
		{	
			BirdWorld.removeStage();
			if (this.M_Panel) 
			{
				if (this.M_Panel.parent) 
				{
					this.M_Panel.parent.removeChild(M_Panel);
				}
			}
			Mission.getMission(Mission.CurrentMission);
			MissionStart();
		}
		private function MissionStart():void
		{
			if (this.hasEventListener(Event.ENTER_FRAME))
			{
				removeEventListener(Event.ENTER_FRAME, update);
			}
			
			if (BirdWorld.BirdStage&&BirdWorld.BirdStage.parent) 
			{
				BirdWorld.BirdStage.parent.removeChild(BirdWorld.BirdStage);
			}
			if (BirdWorld.Score_Board&&BirdWorld.Score_Board.parent) 
			{
				BirdWorld.Score_Board.parent.removeChild(BirdWorld.Score_Board);
			}
			ScoreCounter.Scores = 0;
			birdscene = new BirdScene();
			Score_B = new ScoreCounter();
			this.stage.addChild(birdscene);
			this.stage.addChild(Score_B);
			Score_B.x = this.stage.stageWidth - 200;
			BirdWorld.Score_Board = Score_B;
			BirdWorld.BirdStage = birdscene;//设定了这个场景也就是各个东西的显示容器
			BirdWorld.stag = this.stage;
			BirdWorld.GenerateWorld();//先初始化这个世界
			BirdWorld.AddAllObjs();//向世界里添加各种物体
			BirdWorld.BirdStage.addEventListener(MouseEvent.CLICK, clic);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, stagup);
			addEventListener(Event.ENTER_FRAME, update);
		}
		private function moveScene():void 
		{
			if (birdscene) 
			{
				birdscene.move(this.stage.mouseX);
			}
		}
		private function stagup(e:MouseEvent):void 
		{
			if (birdscene) 
			{
				BirdScene.IsDragging = false;
				BirdWorld.BirdStage.stopDrag();
			}
		}
		private function clic(e:MouseEvent):void
		{
			if (BirdWorld.CurrentBird&&BirdWorld.YesCan)
			{
				BirdWorld.CurrentBird.BirdClick();
				BirdWorld.YesCan = false;
			}
		}
		private function update(e:Event):void 
		{
			moveScene();
			BirdWorld.update();
		}
		
	}

}