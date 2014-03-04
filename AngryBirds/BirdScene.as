package  
{
	import Birds.Bird;
	import Data.KeyData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import com.greensock.*;
	import flash.system.System;
	import flash.ui.Mouse;
	/**
	 * ...
	 * 用来显示各种显示对象的容器
	 * @author IJUST
	 */
	public class BirdScene extends MovieClip
	{
		public var debug_Draw:Sprite;
		public var ground:Sprite = new Sprite();
		public var bird:Sprite = new Sprite();
		public var pig:Sprite = new Sprite();
		public var sling:Sprite = new Sprite();
		public var mat:Sprite = new Sprite();
		public var bubble:Sprite = new Sprite();
		public var ash:Sprite = new Sprite();
		public var Count:Sprite = new Sprite();
		public var Hands:Sprite = new Sprite();
		public static var CanDragScene:Boolean = true;
		public static var CanDragBirds:Boolean = false;
		public static var IsDragging:Boolean = false;
		public function BirdScene() 
		{
			debug_Draw = new Sprite();
			addChild(sling);
			addChild(ground);
			addChild(debug_Draw);
			addChild(mat);
			addChild(pig);
			addChild(bubble);
			addChild(bird);
			addChild(ash);
			addChild(Count);
			addChild(Hands);
			addEventListener(MouseEvent.MOUSE_DOWN, dragScene);
			addEventListener(MouseEvent.MOUSE_UP, dropScene);
			Mouse.hide();
		}

		public function move(sx:Number):void
		{
			if (IsDragging||BirdWorld.HasPass||BirdWorld.HasFail)
			{
				return;
			}
			if (sx<KeyData.StageWidth*0.3) 
			{
				TweenLite.to(this, 0.75, {x:0});
			}
			if (sx>KeyData.StageWidth*0.7) 
			{
				TweenLite.to(this, 0.75, {x:KeyData.StageWidth-KeyData.BirdSceneWidth});
			}
		}
		
		private function dragScene(e:MouseEvent):void
		{
			BirdWorld.AngryHand.gotoAndStop(2);
			if (BirdWorld.HasPass||BirdWorld.HasFail)
			{
				return;
			}
			if (BirdWorld.CurrentBird) 
			{
				if (BirdWorld.AngryHand.hitTestObject(BirdWorld.CurrentBird)) 
				{
					BirdScene.CanDragBirds = true;
					BirdScene.CanDragScene = false;
				}
				else 
				{
					//this.startDrag(false, new Rectangle(0, 0, KeyData.StageWidth - KeyData.BirdSceneWidth, 0));
					IsDragging = true;
				}
			}
			else 
			{
				//this.startDrag(false, new Rectangle(0, 0, KeyData.StageWidth - KeyData.BirdSceneWidth, 0));
				IsDragging = true;
			}
		}
		private function dropScene(e:MouseEvent):void 
		{
			BirdWorld.AngryHand.gotoAndStop(1);
			IsDragging = false;
			//this.stopDrag();
		}
		
	}

}