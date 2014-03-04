/**
 * VERSION: 11.36
 * DATE: 2010-04-27
 * AS3 (AS2 version is also available)
 * UPDATES AND DOCUMENTATION AT: http://www.TweenLite.com
 **/
package com.greensock {
	import com.greensock.core.*;
	import com.greensock.plugins.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	public class TweenLite extends TweenCore {
		
		/**
		 * @private
		 * Initializes the class, activates default plugins, and starts the root timelines. This should only 
		 * be called internally. It is technically public only so that other classes in the GreenSock Tweening 
		 * Platform can access it, but again, please avoid calling this method directly.
		 */
		public static function initClass():void {
			rootFrame = 0;
			rootTimeline = new SimpleTimeline(null);
			rootFramesTimeline = new SimpleTimeline(null);
			rootTimeline.cachedStartTime = getTimer() * 0.001;
			rootFramesTimeline.cachedStartTime = rootFrame;
			rootTimeline.autoRemoveChildren = true;
			rootFramesTimeline.autoRemoveChildren = true;
			_shape.addEventListener(Event.ENTER_FRAME, updateAll, false, 0, true);
			if (overwriteManager == null) {
				overwriteManager = {mode:1, enabled:false};
			}
		}
		
		/** @private **/
		public static const version:Number = 11.36;
		/** @private When plugins are activated, the class is added (named based on the special property) to this object so that we can quickly look it up in the initTweenVals() method.**/
		public static var plugins:Object = {}; 
		/** @private **/
		public static var fastEaseLookup:Dictionary = new Dictionary(false);
		/** @private For notifying plugins of significant events like when the tween finishes initializing, when it is disabled/enabled, and when it completes (some plugins need to take actions when those events occur) **/
		public static var onPluginEvent:Function;
		/** @private **/
		public static var killDelayedCallsTo:Function = TweenLite.killTweensOf;
		/** Provides an easy way to change the default easing equation.**/
		public static var defaultEase:Function = TweenLite.easeOut; 
		/** @private Makes it possible to integrate OverwriteManager for adding various overwriting capabilities. **/
		public static var overwriteManager:Object; 
		/** @private Gets updated on every frame. This syncs all the tweens and prevents drifting of the startTime that happens under heavy loads with most other engines.**/
		public static var rootFrame:Number; 
		/** @private All tweens get associated with a timeline. The rootTimeline is the default for all time-based tweens.**/
		public static var rootTimeline:SimpleTimeline; 
		/** @private All tweens get associated with a timeline. The rootFramesTimeline is the default for all frames-based tweens.**/
		public static var rootFramesTimeline:SimpleTimeline;
		/** @private Holds references to all our tween instances organized by target for quick lookups (for overwriting).**/
		public static var masterList:Dictionary = new Dictionary(false); 
		/** @private Drives all our ENTER_FRAME events.**/
		private static var _shape:Shape = new Shape(); 
		/** @private Lookup for all of the reserved "special property" keywords.**/
		protected static var _reservedProps:Object = {ease:1, delay:1, overwrite:1, onComplete:1, onCompleteParams:1, useFrames:1, runBackwards:1, startAt:1, onUpdate:1, onUpdateParams:1, roundProps:1, onStart:1, onStartParams:1, onInit:1, onInitParams:1, onReverseComplete:1, onReverseCompleteParams:1, onRepeat:1, onRepeatParams:1, proxiedEase:1, easeParams:1, yoyo:1, onCompleteListener:1, onUpdateListener:1, onStartListener:1, onReverseCompleteListener:1, onRepeatListener:1, orientToBezier:1, timeScale:1, immediateRender:1, repeat:1, repeatDelay:1, timeline:1, data:1, paused:1};
		
		
		/** Target object whose properties this tween affects. This can be ANY object, not just a DisplayObject. **/
		public var target:Object; 
		/** @private Lookup object for PropTween objects. For example, if this tween is handling the "x" and "y" properties of the target, the propTweenLookup object will have an "x" and "y" property, each pointing to the associated PropTween object. This can be very helpful for speeding up overwriting. This is a public variable, but should almost never be used directly. **/
		public var propTweenLookup:Object; 
		/** @private result of _ease(this.currentTime, 0, 1, this.duration). Usually between 0 and 1, but not always (like with Elastic.easeOut, it could shoot past 1 or 0). **/
		public var ratio:Number = 0;
		/** @private First PropTween instance - all of which are stored in a linked list for speed. Traverse them using nextNode and prevNode. Typically you should NOT use this property (it is made public for speed and file size purposes). **/
		public var cachedPT1:PropTween; 
		
		/** @private Easing method to use which determines how the values animate over time. Examples are Elastic.easeOut and Strong.easeIn. Many are found in the fl.motion.easing package or com.greensock.easing. **/
		protected var _ease:Function;
		/** @private 0 = NONE, 1 = ALL, 2 = AUTO 3 = CONCURRENT, 4 = ALL_AFTER **/
		protected var _overwrite:uint;
		/** @private When other tweens overwrite properties in this tween, the properties get added to this object. Remember, sometimes properties are overwritten BEFORE the tween inits, like when two tweens start at the same time, the later one overwrites the previous one. **/
		protected var _overwrittenProps:Object; 
		/** @private If this tween has any TweenPlugins, we set this to true - it helps speed things up in onComplete **/
		protected var _hasPlugins:Boolean; 
		/** @private If this tween has any TweenPlugins that need to be notified of a change in the "enabled" status, this will be true. (speeds things up in the enabled setter) **/
		protected var _notifyPluginsOfEnabled:Boolean;
		
		
		/**
		 * Constructor
		 *  
		 * @param target Target object whose properties this tween affects. This can be ANY object, not just a DisplayObject. 
		 * @param duration Duration in seconds (or in frames if the tween's timing mode is frames-based)
		 * @param vars An object containing the end values of the properties you're tweening. For example, to tween to x=100, y=100, you could pass {x:100, y:100}. It can also contain special properties like "onComplete", "ease", "delay", etc.
		 */
		public function TweenLite(target:Object, duration:Number, vars:Object) {
			super(duration, vars);
			this.target = target;
			if (this.target is TweenCore && this.vars.timeScale) { //if timeScale is in the vars object and the target is a TweenCore, this tween's timeScale must be adjusted (in TweenCore's constructor, it was set to whatever the vars.timeScale was)
				this.cachedTimeScale = 1;
			}
			propTweenLookup = {};
			_ease = defaultEase; //temporarily - we'll check the vars object for an ease property in the init() method. We set it to the default initially for speed purposes.
			
			//handle overwriting (if necessary) on tweens of the same object and add the tween to the Dictionary for future reference. Also remember to accommodate TweenLiteVars and TweenMaxVars
			_overwrite = (!(Number(vars.overwrite) > -1) || (!overwriteManager.enabled && vars.overwrite > 1)) ? overwriteManager.mode : int(vars.overwrite);
			var a:Array = masterList[target];
			if (!a) {
				masterList[target] = [this];
			} else { 
				if (_overwrite == 1) { //overwrite all other existing tweens of the same object (ALL mode)
					for each (var sibling:TweenLite in a) {
						if (!sibling.gc) {
							sibling.setEnabled(false, false);
						}
					}
					masterList[target] = [this];
				} else {
					a[a.length] = this;
				}
			}
			
			if (this.active || this.vars.immediateRender) {
				renderTime(0, false, true);
			}
		}
		
		/**
		 * @private
		 * Initializes the property tweens, determining their start values and amount of change. 
		 * Also triggers overwriting if necessary and sets the _hasUpdate variable.
		 */
		protected function init():void {
			if (this.vars.onInit) {
				this.vars.onInit.apply(null, this.vars.onInitParams);
			}
			var p:String, i:int, plugin:*, prioritize:Boolean, siblings:Array;
			if (typeof(this.vars.ease) == "function") {
				_ease = this.vars.ease;
			}
			if (this.vars.easeParams) {
				this.vars.proxiedEase = _ease;
				_ease = easeProxy;
			}
			this.cachedPT1 = null;
			this.propTweenLookup = {};
			for (p in this.vars) {
				if (p in _reservedProps && !(p == "timeScale" && this.target is TweenCore)) { 
					//ignore
				} else if (p in plugins && (plugin = new (plugins[p] as Class)()).onInitTween(this.target, this.vars[p], this)) {
					this.cachedPT1 = new PropTween(plugin, 
												    "changeFactor", 
												    0, 
												    1, 
												    (plugin.overwriteProps.length == 1) ? plugin.overwriteProps[0] : "_MULTIPLE_",
												    true,
												    this.cachedPT1);
					
					if (this.cachedPT1.name == "_MULTIPLE_") {
						i = plugin.overwriteProps.length;
						while (--i > -1) {
							this.propTweenLookup[plugin.overwriteProps[i]] = this.cachedPT1;
						}
					} else {
						this.propTweenLookup[this.cachedPT1.name] = this.cachedPT1;
					}
					if (plugin.priority) {
						this.cachedPT1.priority = plugin.priority;
						prioritize = true;
					}
					if (plugin.onDisable || plugin.onEnable) {
						_notifyPluginsOfEnabled = true;
					}
					_hasPlugins = true;
					
				} else {
					this.cachedPT1 = new PropTween(this.target, 
												    p, 
												    Number(this.target[p]), 
												    (typeof(this.vars[p]) == "number") ? Number(this.vars[p]) - this.target[p] : Number(this.vars[p]),
												    p,
												    false,
												    this.cachedPT1);
					this.propTweenLookup[p] = this.cachedPT1;
				}
				
			}
			if (prioritize) {
				onPluginEvent("onInit", this); //reorders the linked list in order of priority. Uses a static TweenPlugin method in order to minimize file size in TweenLite
			}
			if (this.vars.runBackwards) {
				var pt:PropTween = this.cachedPT1;
				while (pt) {
					pt.start += pt.change;
					pt.change = -pt.change;
					pt = pt.nextNode;
				}
			}
			_hasUpdate = Boolean(this.vars.onUpdate != null);
			if (_overwrittenProps) { //another tween may have tried to overwrite properties of this tween before init() was called (like if two tweens start at the same time, the one created second will run first)
				killVars(_overwrittenProps);
				if (this.cachedPT1 == null) { //if all tweening properties have been overwritten, kill the tween.
					this.setEnabled(false, false);
				}
			}
			if (_overwrite > 1 && this.cachedPT1 && (siblings = masterList[this.target]) && siblings.length > 1) {
				if (overwriteManager.manageOverwrites(this, this.propTweenLookup, siblings, _overwrite)) {
					//one of the plugins had activeDisable set to true, so properties may have changed when it was disabled meaning we need to re-init()
					init();
				}
			}
			this.initted = true;
		}
		
		/** @private **/
		override public function renderTime(time:Number, suppressEvents:Boolean=false, force:Boolean=false):void {
			var isComplete:Boolean, prevTime:Number = this.cachedTime;
			if (time >= this.cachedDuration) {
				this.cachedTotalTime = this.cachedTime = this.cachedDuration;
				this.ratio = 1;
				isComplete = true;
				if (this.cachedDuration == 0) { //zero-duration tweens are tricky because we must discern the momentum/direction of time in order to determine whether the starting values should be rendered or the ending values. If the "playhead" of its timeline goes past the zero-duration tween in the forward direction or lands directly on it, the end values should be rendered, but if the timeline's "playhead" moves past it in the backward direction (from a postitive time to a negative time), the starting values must be rendered.
					if ((time == 0 || _rawPrevTime < 0) && _rawPrevTime != time) {
						force = true;
					}		
					_rawPrevTime = time;
				}
				
			} else if (time <= 0) {
				this.cachedTotalTime = this.cachedTime = this.ratio = 0;
				if (time < 0) {
					this.active = false;
					if (this.cachedDuration == 0) { //zero-duration tweens are tricky because we must discern the momentum/direction of time in order to determine whether the starting values should be rendered or the ending values. If the "playhead" of its timeline goes past the zero-duration tween in the forward direction or lands directly on it, the end values should be rendered, but if the timeline's "playhead" moves past it in the backward direction (from a postitive time to a negative time), the starting values must be rendered.
						if (_rawPrevTime > 0) {
							force = true;
							isComplete = true;
						}
						_rawPrevTime = time;
					}
				}
				if (this.cachedReversed && prevTime != 0) {
					isComplete = true;
				}
				
			} else {
				this.cachedTotalTime = this.cachedTime = time;
				this.ratio = _ease(time, 0, 1, this.cachedDuration);
			}			
			
			if (this.cachedTime == prevTime && !force) {
				return;
			} else if (!this.initted) {
				init();
				if (!isComplete && this.cachedTime) { //_ease is initially set to defaultEase, so now that init() has run, _ease is set properly and we need to recalculate the ratio. Overall this is faster than using conditional logic earlier in the method to avoid having to set ratio twice because we only init() once but renderTime() gets called VERY frequently.
					this.ratio = _ease(this.cachedTime, 0, 1, this.cachedDuration);
				}
			}
			if (!this.active && !this.cachedPaused) {
				this.active = true;  //so that if the user renders a tween (as opposed to the timeline rendering it), the timeline is forced to re-render and align it with the proper time/frame on the next rendering cycle. Maybe the tween already finished but the user manually re-renders it as halfway done.
			}
			if (prevTime == 0 && this.vars.onStart && this.cachedTime != 0 && !suppressEvents) {
				this.vars.onStart.apply(null, this.vars.onStartParams);
			}
			
			var pt:PropTween = this.cachedPT1;
			while (pt) {
				pt.target[pt.property] = pt.start + (this.ratio * pt.change);
				pt = pt.nextNode;
			}
			if (_hasUpdate && !suppressEvents) {
				this.vars.onUpdate.apply(null, this.vars.onUpdateParams);
			}
			if (isComplete) {
				if (_hasPlugins && this.cachedPT1) {
					onPluginEvent("onComplete", this);
				}
				complete(true, suppressEvents);
			}
		}
		
		/**
		 * Allows particular properties of the tween to be killed. For example, if a tween is affecting 
		 * the "x", "y", and "alpha" properties and you want to kill just the "x" and "y" parts of the 
		 * tween, you'd do <code>myTween.killVars({x:true, y:true});</code>
		 * 
		 * @param vars An object containing a corresponding property for each one that should be killed. The values don't really matter. For example, to kill the x and y property tweens, do <code>myTween.killVars({x:true, y:true});</code>
		 * @param permanent If true, the properties specified in the vars object will be permanently disallowed in the tween. Typically the only time false might be used is while the tween is in the process of initting and a plugin needs to make sure tweens of a particular property (or set of properties) is killed. 
		 * @return Boolean value indicating whether or not properties may have changed on the target when any of the vars were disabled. For example, when a motionBlur (plugin) is disabled, it swaps out a BitmapData for the target and may alter the alpha. We need to know this in order to determine whether or not a new tween that is overwriting this one should be re-initted() with the changed properties. 
		 */
		public function killVars(vars:Object, permanent:Boolean=true):Boolean {
			if (_overwrittenProps == null) {
				_overwrittenProps = {};
			}
			var p:String, pt:PropTween, changed:Boolean;
			for (p in vars) {
				if (p in propTweenLookup) {
					pt = propTweenLookup[p];
					if (pt.isPlugin && pt.name == "_MULTIPLE_") {
						pt.target.killProps(vars);
						if (pt.target.overwriteProps.length == 0) {
							pt.name = "";
						}
					}
					if (pt.name != "_MULTIPLE_") {
						//remove PropTween (do it inline to improve speed and keep file size low)
						if (pt.nextNode) {
							pt.nextNode.prevNode = pt.prevNode;
						}
						if (pt.prevNode) {
							pt.prevNode.nextNode = pt.nextNode;
						} else if (this.cachedPT1 == pt) {
							this.cachedPT1 = pt.nextNode;
						}
						if (pt.isPlugin && pt.target.onDisable) {
							pt.target.onDisable(); //some plugins need to be notified so they can perform cleanup tasks first
							if (pt.target.activeDisable) {
								changed = true;
							}
						}
						delete propTweenLookup[p];
					}
				}
				if (permanent && vars != _overwrittenProps) {
					_overwrittenProps[p] = 1;
				}
			}
			return changed;
		}
		
		/** @inheritDoc **/
		override public function invalidate():void {
			if (_notifyPluginsOfEnabled && this.cachedPT1) {
				onPluginEvent("onDisable", this);
			}
			this.cachedPT1 = null;
			_overwrittenProps = null;
			_hasUpdate = this.initted = this.active = _notifyPluginsOfEnabled = false;
			this.propTweenLookup = {};
		}
		
		/** @private **/	
		override public function setEnabled(enabled:Boolean, ignoreTimeline:Boolean=false):Boolean {
			if (enabled) {
				var a:Array = TweenLite.masterList[this.target];
				if (!a) {
					TweenLite.masterList[this.target] = [this];
				} else {
					a[a.length] = this;
				}
			}
			super.setEnabled(enabled, ignoreTimeline);
			if (_notifyPluginsOfEnabled && this.cachedPT1) {
				return onPluginEvent(((enabled) ? "onEnable" : "onDisable"), this);
			}
			return false;
		}
		
		
//---- STATIC FUNCTIONS -----------------------------------------------------------------------------------
		
		/**
		 * Static method for creating a TweenLite instance. This can be more intuitive for some developers 
		 * and shields them from potential garbage collection issues that could arise when assigning a
		 * tween instance to a variable that persists. The following lines of code produce exactly 
		 * the same result: <br /><br /><code>
		 * 
		 * var myTween:TweenLite = new TweenLite(mc, 1, {x:100}); <br />
		 * TweenLite.to(mc, 1, {x:100}); <br />
		 * var myTween:TweenLite = TweenLite.to(mc, 1, {x:100});</code>
		 * 
		 * @param target Target object whose properties this tween affects. This can be ANY object, not just a DisplayObject. 
		 * @param duration Duration in seconds (or in frames if the tween's timing mode is frames-based)
		 * @param vars An object containing the end values of the properties you're tweening. For example, to tween to x=100, y=100, you could pass {x:100, y:100}. It can also contain special properties like "onComplete", "ease", "delay", etc.
		 * @return TweenLite instance
		 */
		public static function to(target:Object, duration:Number, vars:Object):TweenLite {
			return new TweenLite(target, duration, vars);
		}
		
		/**
		 * Static method for creating a TweenLite instance that tweens in the opposite direction
		 * compared to a TweenLite.to() tween. In other words, you define the START values in the 
		 * vars object instead of the end values, and the tween will use the current values as 
		 * the end values. This can be very useful for animating things into place on the stage
		 * because you can build them in their end positions and do some simple TweenLite.from()
		 * calls to animate them into place. <b>NOTE:</b> By default, <code>immediateRender</code>
		 * is <code>true</code> in from() tweens, meaning that they immediately render their starting state 
		 * regardless of any delay that is specified. You can override this behavior by passing 
		 * <code>immediateRender:false</code> in the <code>vars</code> object so that it will wait to 
		 * render until the tween actually begins (often the desired behavior when inserting into timelines). 
		 * To illustrate the default behavior, the following code will immediately set the <code>alpha</code> of <code>mc</code> 
		 * to 0 and then wait 2 seconds before tweening the <code>alpha</code> back to 1 over the course 
		 * of 1.5 seconds:<br /><br /><code>
		 * 
		 * TweenLite.from(mc, 1.5, {alpha:0, delay:2});</code>
		 * 
		 * @param target Target object whose properties this tween affects. This can be ANY object, not just a DisplayObject. 
		 * @param duration Duration in seconds (or in frames if the tween's timing mode is frames-based)
		 * @param vars An object containing the start values of the properties you're tweening. For example, to tween from x=100, y=100, you could pass {x:100, y:100}. It can also contain special properties like "onComplete", "ease", "delay", etc.
		 * @return TweenLite instance
		 */
		public static function from(target:Object, duration:Number, vars:Object):TweenLite {
			vars.runBackwards = true;
			if (!("immediateRender" in vars)) {
				vars.immediateRender = true;
			}
			return new TweenLite(target, duration, vars);
		}
		
		/**
		 * Provides a simple way to call a function after a set amount of time (or frames). You can
		 * optionally pass any number of parameters to the function too. For example:<br /><br /><code>
		 * 
		 * TweenLite.delayedCall(1, myFunction, ["param1", 2]); <br />
		 * function myFunction(param1:String, param2:Number):void { <br />
		 *     trace("called myFunction and passed params: " + param1 + ", " + param2); <br />
		 * } </code>
		 * 
		 * @param delay Delay in seconds (or frames if useFrames is true) before the function should be called
		 * @param onComplete Function to call
		 * @param onCompleteParams An Array of parameters to pass the function.
		 * @param useFrames If the delay should be measured in frames instead of seconds, set useFrames to true (default is false)
		 * @return TweenLite instance
		 */
		public static function delayedCall(delay:Number, onComplete:Function, onCompleteParams:Array=null, useFrames:Boolean=false):TweenLite {
			return new TweenLite(onComplete, 0, {delay:delay, onComplete:onComplete, onCompleteParams:onCompleteParams, immediateRender:false, useFrames:useFrames, overwrite:0});
		}
		
		/**
		 * @private
		 * Updates the rootTimeline and rootFramesTimeline and collects garbage every 60 frames.
		 * 
		 * @param e ENTER_FRAME Event
		 */
		 protected static function updateAll(e:Event = null):void {
			rootTimeline.renderTime(((getTimer() * 0.001) - rootTimeline.cachedStartTime) * rootTimeline.cachedTimeScale, false, false);
			rootFrame++;
			rootFramesTimeline.renderTime((rootFrame - rootFramesTimeline.cachedStartTime) * rootFramesTimeline.cachedTimeScale, false, false);
			
			if (!(rootFrame % 60)) { //garbage collect every 60 frames...
				var ml:Dictionary = masterList, tgt:Object, a:Array, i:int;
				for (tgt in ml) {
					a = ml[tgt];
					i = a.length;
					while (--i > -1) {
						if (TweenLite(a[i]).gc) {
							a.splice(i, 1);
						}
					}
					if (a.length == 0) {
						delete ml[tgt];
					}
				}
			}
			
		}
		
		
		/**
		 * Kills all the tweens (or certain tweening properties) of a particular object, optionally completing them first.
		 * If, for example, you want to kill all tweens of the "mc" object, you'd do:<br /><br /><code>
		 * 
		 * TweenLite.killTweensOf(mc);<br /><br /></code>
		 * 
		 * But if you only want to kill all the "alpha" and "x" portions of mc's tweens, you'd do:<br /><br /><code>
		 * 
		 * TweenLite.killTweensOf(mc, false, {alpha:true, x:true});<br /><br /></code>
		 * 
		 * <code>killTweensOf()</code> affects tweens that haven't begun yet too. If, for example, 
		 * a tween of object "mc" has a delay of 5 seconds and <code>TweenLite.killTweensOf(mc)</code> is called
		 * 2 seconds after the tween was created, it will still be killed even though it hasn't started yet. <br /><br />
		 * 
		 * @param target Object whose tweens should be immediately killed
		 * @param complete Indicates whether or not the tweens should be forced to completion before being killed.
		 * @param vars An object defining which tweening properties should be killed (null causes all properties to be killed). For example, if you only want to kill "alpha" and "x" tweens of object "mc", you'd do <code>myTimeline.killTweensOf(mc, true, {alpha:true, x:true})</code>. If there are no tweening properties remaining in a tween after the indicated properties are killed, the entire tween is killed, meaning any onComplete, onUpdate, onStart, etc. won't fire.
		 */
		public static function killTweensOf(target:Object, complete:Boolean=false, vars:Object=null):void {
			if (target in masterList) {
				var a:Array = masterList[target];
				var i:int = a.length;
				var tween:TweenLite;
				while (--i > -1) {
					tween = a[i];
					if (!tween.gc) {
						if (complete) {
							tween.complete(false, false);
						}
						if (vars != null) {
							tween.killVars(vars);
						}
						if (vars == null || (tween.cachedPT1 == null && tween.initted)) {
							tween.setEnabled(false, false);
						}
					}
				}
				if (vars == null) {
					delete masterList[target];
				}
			}
		}
		
		/**
		 * @private
		 * Default easing equation
		 * 
		 * @param t time
		 * @param b start (must always be 0)
		 * @param c change (must always be 1)
		 * @param d duration
		 * @return Eased value
		 */
		protected static function easeOut(t:Number, b:Number, c:Number, d:Number):Number {
			return 1 - (t = 1 - (t / d)) * t;
		}
			
		/**
		 * @private
		 * Only used for easing equations that accept extra parameters (like Elastic.easeOut and Back.easeOut).
		 * Basically, it acts as a proxy. To utilize it, pass an Array of extra parameters via the vars object's
		 * "easeParams" special property
		 *  
		 * @param t time
		 * @param b start
		 * @param c change
		 * @param d duration
		 * @return Eased value
		 */
		protected function easeProxy(t:Number, b:Number, c:Number, d:Number):Number { 
			return this.vars.proxiedEase.apply(null, arguments.concat(this.vars.easeParams));
		}
		
		
	}
	
}