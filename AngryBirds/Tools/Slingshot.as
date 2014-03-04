package Tools 
{
	import Birds.Bird;
	import Box2D.Common.Math.b2Vec2;
	import Data.KeyData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.utils.*;
	/**
	 * ...
	 * @author IJUST
	 */
	public class Slingshot extends MovieClip
	{
		public var SlingPoint:Point;//弹性力的原点
		public var Slingb2Vec:b2Vec2;//弹性力的世界矢量位置
		public var BirdPoint:Point;//鸟的点位置
		public var Birdb2Vec:b2Vec2;//鸟的世界矢量位置
		public var BirdToSlingPoint:Point;//鸟指向弹弓的相对坐标
		public var BirdToSlingb2Vec:b2Vec2;//鸟指向弹弓的矢量
		public var SlingBird:Bird;
		
		//皮条  
		//public var FrontStrap:Strap;
		//public var BackStrap:Strap;
		
		public function Slingshot()
		{
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE,removeedFromStage)
		}
		public function addedToStage(e:Event):void
		{
			SlingPoint = this.localToGlobal(new Point());//获得自己的舞台坐标
		}
		public function removeedFromStage(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, removeedFromStage);
		}
		public function getBird(bir:Bird):void
		{
			SlingBird = bir;
			SlingBird.addEventListener(MouseEvent.MOUSE_DOWN, md);
			SlingBird.AngryBody.SetXForm(new b2Vec2(SlingBird.x/30,SlingBird.y/30), SlingBird.rotation);
			SlingBird.AngryBody.PutToSleep();
			BirdWorld.stag.addEventListener(MouseEvent.MOUSE_DOWN, Down_Get_Force);
			BirdWorld.stag.addEventListener(MouseEvent.MOUSE_UP, Release_Get_Impulse);
		}
		public function md(e:MouseEvent):void 
		{
			BirdScene.CanDragBirds = true;
			BirdScene.CanDragScene = false;
		}
		public function Down_Get_Force(e:MouseEvent):void
		{
			if (BirdScene.CanDragBirds) 
			{
				getDrag();
			}
		}
		public function Release_Get_Impulse(e:MouseEvent):void
		{
			if (!BirdScene.CanDragBirds)
			{
				return;
			}
			BirdWorld.ClearBubble();
			SlingBird.CanBubble = true;
			releaseDrag();
			SlingBird.AngryBody.WakeUp();
			BirdPoint = SlingBird.Position;
			Birdb2Vec = getb2VecFromPoint(BirdPoint);
			BirdToSlingPoint = new Point(SlingPoint.x - BirdPoint.x, SlingPoint.y - BirdPoint.y);
			BirdToSlingb2Vec = getb2VecFromPoint(BirdToSlingPoint);
			BirdToSlingb2Vec.Multiply(KeyData.B2Vec_To_Impulse*SlingBird.AngryBody.GetMass());
			SlingBird.AngryBody.ApplyImpulse(BirdToSlingb2Vec, SlingBird.AngryBody.GetWorldCenter());
			SlingBird.BirdHasSling = true;
			BirdWorld.HasClicked=false
			SlingBird.BirdState = KeyData.Bird_State_On_Flying;//已经发射
			BirdWorld.CurrentBirdState = KeyData.Bird_State_On_Flying;
			BirdScene.CanDragBirds = false;
			BirdScene.CanDragScene = true;
			setTimeout(click, 100);
		}
		public function click():void 
		{
			BirdWorld.YesCan = true;
		}
		private function getb2VecFromPoint(po:Point):b2Vec2 
		{
			var b2v:b2Vec2 = new b2Vec2(po.x / 30, po.y / 30);
			return b2v;
		}
		
		private function getDrag():void 
		{
			addEventListener(Event.ENTER_FRAME, stopBirdOut);
		}
		
		private function releaseDrag():void
		{
			BirdWorld.stag.removeEventListener(MouseEvent.MOUSE_DOWN, Down_Get_Force);
			BirdWorld.stag.removeEventListener(MouseEvent.MOUSE_UP, Release_Get_Impulse);
			SlingBird.removeEventListener(MouseEvent.MOUSE_DOWN, md);
			removeEventListener(Event.ENTER_FRAME, stopBirdOut);
		}
		
		private function stopBirdOut(e:Event):void
		{
			var mouseP:Point = new Point(SlingBird.x + SlingBird.mouseX, SlingBird.y + SlingBird.mouseY);
			if (Point.distance(mouseP,this.SlingPoint)<=KeyData.SlingLength)
			{
				SlingBird.x = SlingBird.parent.mouseX;
				SlingBird.y = SlingBird.parent.mouseY;
			}
			else 
			{
				var ratio:Number = Point.distance(mouseP, this.SlingPoint) / KeyData.SlingLength;
				SlingBird.x = (mouseP.x - SlingPoint.x) / ratio + SlingPoint.x;
				SlingBird.y = (mouseP.y - SlingPoint.y) / ratio + SlingPoint.y;//大约就是这个样子吧
			}
			
			var b2V:b2Vec2 = new b2Vec2(SlingBird.x/30,SlingBird.y/30);
			SlingBird.AngryBody.SetXForm(b2V, SlingBird.rotation*180/Math.PI);//角度应该乘以180/PI
		}
		
	}

}