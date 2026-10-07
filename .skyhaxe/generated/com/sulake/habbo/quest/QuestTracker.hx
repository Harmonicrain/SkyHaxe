package com.sulake.habbo.quest
;
    import com.sulake.core.runtime.IDisposable;
    import flash.geom.Point;
    import com.sulake.habbo.communication.messages.incoming.quest.QuestMessageData;
    import com.sulake.core.window.IWindowContainer;
    import flash.utils.Timer;
    import flash.events.TimerEvent;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.communication.messages.outgoing.quest.OpenQuestTrackerMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.quest.StartCampaignMessageComposer;
    import com.sulake.core.window.components.IDesktopWindow;
    import com.sulake.core.window.components.IFrameWindow;

     class QuestTracker implements IDisposable 
    {
        static inline final _Str_5976= 0;
        static inline final _Str_26462= 1;
        static inline final _Str_10202= 2;
        static inline final _Str_12853= 3;
        static inline final _Str_12878= 4;
        static inline final _Str_14692= 5;
        static inline final _Str_12665= 6;
        static final _Str_14164:Array<ASAny> = [-2, -3, -2, 0, 2, 3, 2, 0, 2, 1, 0, 1];
        static final _Str_13085:Array<ASAny> = [1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 4];
        static inline final _Str_16918= 6;
        static inline final _Str_16162= 4;
        static inline final _Str_11367= 2;
        static inline final _Str_14887= 200;
        static final _Str_6593:Array<ASAny> = ["a", "b", "c", "d"];
        static inline final _Str_15461= 10000;
        static inline final _Str_17632= 0;
        static inline final _Str_11814= -1;
        static final _Str_16086:Point = new Point(10, 87);
        static inline final _Str_17513= 162;
        static inline final _Str_18252= 0.01;
        static inline final _Str_16329:Float = 100;
        static inline final _Str_16069= 1000;
        static inline final QUEST_TRACKER= "quest_tracker";
        static inline final _Str_16708= 10;

        var _questEngine:HabboQuestEngine;
        var _questInTracker:QuestMessageData;
        var _window:IWindowContainer;
        var _startQuestTimer:Timer;
        var _progressBar:ProgressBar;
        var _trackerAnimationStatus:Int = 0;
        var _nudgeIndex:Int = 0;
        var _remainingWait:Int = 0;
        var _successFrame:Int = -1;
        var _msecsUntilPrompt:Int = -1;
        var _promptFrame:Int = -1;
        var _msecsUntilNextPromptFrame:Int = 0;
        var _remainingPromptSequenceRepeats:Int = 0;
        var _promptWithNudge:Bool = false;
        var _getNextQuestWhenCompletionAnimationFinishes:Bool = false;
        var _forcedCloseRequested:Bool = false;

        public function new(k:HabboQuestEngine)
        {
            this._questEngine = k;
        }

        public function dispose()
        {
            if (this._questEngine != null)
            {
                this._questEngine.toolbar.extensionView.detachExtension(QUEST_TRACKER);
            }
            this._questEngine = null;
            this._questInTracker = null;
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            if (this._startQuestTimer != null)
            {
                this._startQuestTimer.stop();
                this._startQuestTimer = null;
            }
            if (this._progressBar != null)
            {
                this._progressBar.dispose();
                this._progressBar = null;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._questEngine == null;
        }

        public function _Str_5657(k:QuestMessageData, _arg_2:Bool)
        {
            if (this._window != null)
            {
                this._Str_19847();
                this._questInTracker = k;
                this._nudgeIndex = 0;
                this._Str_19788();
                this._successFrame = 0;
                this._trackerAnimationStatus = _Str_12853;
                this._getNextQuestWhenCompletionAnimationFinishes = (!_arg_2);
            }
        }

        public function _Str_5242()
        {
            this._questInTracker = null;
            if (this._window != null)
            {
                this._Str_19847();
                this._progressBar.refresh(0, 100, -1, 0);
                this._trackerAnimationStatus = _Str_10202;
            }
        }

        public function onRoomEnter()
        {
            var _local_3 = 0;
            var k:ASAny = (this._questEngine.getInteger("new.identity", 0) > 0);
            if (!k)
            {
                return;
            }
            var _local_2= this.getDefaultCampaign();
            if ((((this._startQuestTimer == null) && ASCompat.toBool(k)) && (!(_local_2 == ""))))
            {
                _local_3 = this._questEngine.getInteger("questing.startQuestDelayInSeconds", 30);
                this._startQuestTimer = new Timer((_local_3 * 1000), 1);
                this._startQuestTimer.addEventListener(TimerEvent.TIMER, (this.onStartQuestTimer : ASAny));
                this._startQuestTimer.start();
                Logger.log([("Initialized start quest timer with period: " + Std.string(_local_3))]);
            }
        }

        public function onRoomExit()
        {
            if (((!(this._window == null)) && this._window.visible))
            {
                this._window.findChildByName("more_info_txt").visible = false;
                this._window.findChildByName("more_info_region").visible = false;
            }
        }

        public function _Str_4750(k:QuestMessageData)
        {
            if (this._startQuestTimer != null)
            {
                this._startQuestTimer.stop();
            }
            var _local_2= ((this._window != null) && this._window.visible);
            if (k._Str_3935 > 0)
            {
                if (_local_2)
                {
                    this._Str_11225(false);
                }
                return;
            }
            this._questInTracker = k;
            this._Str_25660();
            this._Str_19788();
            this._Str_23346();
            this._Str_11225(true);
            this._Str_18279();
            if (_local_2)
            {
                if (this._trackerAnimationStatus == _Str_10202)
                {
                    this._trackerAnimationStatus = _Str_26462;
                }
                this._Str_11768(this._msecsUntilPrompt, _Str_16162, false);
            }
            else
            {
                this._window.x = this._Str_20107();
                this._trackerAnimationStatus = _Str_26462;
                this._Str_11768(_Str_17632, _Str_11367, false);
            }
        }

        function _Str_23346()
        {
            if (!this._questEngine._Str_17760(this._questInTracker))
            {
                return;
            }
            var k = 0;
            while (k < _Str_6593.length)
            {
                this._questEngine._Str_22546(this._window, this._questInTracker, _Str_6593[k]);
                k++;
            }
        }

        function _Str_25660()
        {
            if (this._window != null)
            {
                return;
            }
            this._window = cast(this._questEngine.getXmlWindow("QuestTracker"), IWindowContainer);
            this._window.findChildByName("more_info_region").procedure = this._Str_16870;
            this._Str_18279();
            this._progressBar = new ProgressBar(this._questEngine, cast(this._window.findChildByName("content_cont"), IWindowContainer), _Str_17513, "quests.tracker.progress", false, _Str_16086);
        }

        function _Str_18279()
        {
            var k= 1;
            while (k <= _Str_16918)
            {
                this._Str_21947(k).visible = false;
                k++;
            }
        }

        function _Str_22074()
        {
            var k = 0;
            while (k < _Str_6593.length)
            {
                this._Str_21535(_Str_6593[k]).visible = false;
                k++;
            }
        }

        function _Str_21947(k:Int):IWindow
        {
            return this._window.findChildByName(("success_pic_" + Std.string(k)));
        }

        function _Str_21535(k:String):IWindow
        {
            return this._window.findChildByName(("prompt_pic_" + k));
        }

        function _Str_19788()
        {
            this._questEngine.localization.registerParameter("quests.tracker.caption", "quest_name", this._questEngine.getQuestName(this._questInTracker));
            this._window.findChildByName("desc_txt").caption = this._questEngine._Str_20120(this._questInTracker);
            this._window.findChildByName("more_info_txt").visible = this._questEngine._Str_6927;
            this._window.findChildByName("more_info_region").visible = this._questEngine._Str_6927;
            var k= Std.int(Math.fceil(((100 * this._questInTracker._Str_22915) / this._questInTracker._Str_22975)));
            this._progressBar.refresh(k, 100, this._questInTracker.id, 0);
            this._questEngine._Str_19955(this._window, this._questInTracker);
        }

        function _Str_16870(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                this._questEngine._Str_3398._Str_11417._Str_5386(this._questInTracker);
            }
        }

        public function _Str_24904()
        {
            if (this._trackerAnimationStatus == _Str_5976)
            {
                this._Str_11225(false);
                this._forcedCloseRequested = false;
            }
            else
            {
                this._forcedCloseRequested = true;
            }
        }

        public function update(k:UInt)
        {
            var _local_2 = 0;
            var _local_3 = 0;
            var _local_4 = 0;
            if (this._window == null)
            {
                return;
            }
            this._progressBar.updateView();
            switch (this._trackerAnimationStatus)
            {
                case _Str_26462:
                    _local_2 = this._Str_14043();
                    _local_3 = (this._window.x - _local_2);
                    if (_local_3 > 0)
                    {
                        _local_4 = Std.int(Math.max(1, Math.fround(((_local_3 * k) * _Str_18252))));
                        this._window.x = (this._window.x - _local_4);
                    }
                    else
                    {
                        this._trackerAnimationStatus = _Str_5976;
                        this._window.x = _local_2;
                    }
                    return;
                case _Str_10202:
                    _local_2 = this._Str_20107();
                    _local_3 = (this._window.width - this._window.x);
                    if (_local_3 > 0)
                    {
                        _local_4 = Std.int(Math.max(1, Math.fround(((k * _Str_16329) / _local_3))));
                        this._window.x = (this._window.x + _local_4);
                    }
                    else
                    {
                        this._trackerAnimationStatus = _Str_5976;
                        this._window.x = _local_2;
                        this._Str_11225(false);
                    }
                    return;
                case _Str_12853:
                    this._Str_18279();
                    this._Str_21947(ASCompat.toInt(_Str_13085[this._successFrame])).visible = true;
                    this._successFrame++;
                    if (this._successFrame >= _Str_13085.length)
                    {
                        this._trackerAnimationStatus = _Str_14692;
                        this._remainingWait = _Str_16069;
                    }
                    return;
                case _Str_12665:
                    this._Str_17891(false);
                    this._Str_22074();
                    this._msecsUntilNextPromptFrame = ASCompat.toInt(this._msecsUntilNextPromptFrame - k);
                    this._Str_21535(_Str_6593[this._promptFrame]).visible = true;
                    if (this._msecsUntilNextPromptFrame < 0)
                    {
                        this._msecsUntilNextPromptFrame = _Str_14887;
                        this._promptFrame++;
                        if (this._promptFrame >= _Str_6593.length)
                        {
                            this._promptFrame = 0;
                            this._remainingPromptSequenceRepeats--;
                            if (this._remainingPromptSequenceRepeats < 1)
                            {
                                this._Str_11768(_Str_15461, _Str_11367, true);
                                this._trackerAnimationStatus = _Str_5976;
                            }
                        }
                    }
                    return;
                case _Str_12878:
                    if (this._nudgeIndex >= (_Str_14164.length - 1))
                    {
                        this._window.x = this._Str_14043();
                        this._trackerAnimationStatus = _Str_5976;
                        this._Str_11768(_Str_15461, _Str_11367, false);
                    }
                    else
                    {
                        this._window.x = ASCompat.toInt(this._Str_14043() + _Str_14164[this._nudgeIndex]);
                        this._nudgeIndex++;
                    }
                    return;
                case _Str_14692:
                    this._remainingWait = ASCompat.toInt(this._remainingWait - k);
                    if (this._remainingWait < 0)
                    {
                        this._trackerAnimationStatus = _Str_5976;
                        if ((this._getNextQuestWhenCompletionAnimationFinishes && (!this._forcedCloseRequested)))
                        {
                            this._questEngine.send(new OpenQuestTrackerMessageComposer());
                        }
                        else
                        {
                            this._Str_11225(false);
                            this._forcedCloseRequested = false;
                        }
                    }
                    return;
                case _Str_5976:
                    if (this._msecsUntilPrompt != _Str_11814)
                    {
                        this._msecsUntilPrompt = ASCompat.toInt(this._msecsUntilPrompt - k);
                        if (this._msecsUntilPrompt < 0)
                        {
                            this._msecsUntilPrompt = _Str_11814;
                            if (((!(this._questInTracker == null)) && this._questEngine._Str_17760(this._questInTracker)))
                            {
                                if (this._promptWithNudge)
                                {
                                    this._Str_25843();
                                }
                                else
                                {
                                    this._trackerAnimationStatus = _Str_12665;
                                    this._promptFrame = 0;
                                    this._msecsUntilNextPromptFrame = _Str_14887;
                                }
                            }
                        }
                    }
                    return;
            }
        }

        function _Str_14043():Int
        {
            return 0;
        }

        function _Str_20107():Int
        {
            return this._window.width + _Str_16708;
        }

        public function isVisible():Bool
        {
            return (this._window != null) && this._window.visible;
        }

        function onStartQuestTimer(k:TimerEvent)
        {
            if (this.hasBlockingWindow())
            {
                Logger.log(["Quest start blocked. Waiting some more"]);
                this._startQuestTimer.reset();
                this._startQuestTimer.start();
            }
            else
            {
                this._questEngine._Str_3398._Str_11417._Str_19749 = this._questEngine.getBoolean("questing.showDetailsForNextQuest");
                this._questEngine.send(new StartCampaignMessageComposer(this.getDefaultCampaign()));
            }
        }

        function getDefaultCampaign():String
        {
            var k= this._questEngine.getProperty("questing.defaultCampaign");
            return (k == null) ? "" : k;
        }

        function hasBlockingWindow():Bool
        {
            var _local_2:IDesktopWindow = null;
            var k = 0;
            while (k <= 2)
            {
                _local_2 = this._questEngine.windowManager.getDesktop(k);
                if (((!(_local_2 == null)) && this.hasBlockingWindowInLayer(_local_2)))
                {
                    return true;
                }
                k++;
            }
            return false;
        }

        function hasBlockingWindowInLayer(k:IWindowContainer):Bool
        {
            var _local_2 = 0;
            var _local_3:IWindow = null;
            while (_local_2 < k.numChildren)
            {
                _local_3 = k.getChildAt(_local_2);
                if (((!(_local_3 == null)) && _local_3.visible))
                {
                    if (Std.downcast(_local_3 , IFrameWindow) != null)
                    {
                        if (((!(_local_3.name == "mod_start_panel")) && (!(_local_3.name == "_frame"))))
                        {
                            return true;
                        }
                    }
                    else
                    {
                        if (_local_3.name == "welcome_screen")
                        {
                            return true;
                        }
                    }
                }
                _local_2++;
            }
            return false;
        }

        function _Str_17891(k:Bool)
        {
            this._window.findChildByName("quest_pic_bitmap").visible = k;
        }

        function _Str_19847()
        {
            this._Str_11768(_Str_11814, 0, false);
        }

        function _Str_11768(k:Int, _arg_2:Int, _arg_3:Bool)
        {
            this._Str_17891(true);
            this._Str_22074();
            this._msecsUntilPrompt = k;
            this._remainingPromptSequenceRepeats = _arg_2;
            this._promptWithNudge = _arg_3;
        }

        function _Str_25843()
        {
            this._nudgeIndex = 0;
            this._trackerAnimationStatus = _Str_12878;
        }

        function _Str_11225(k:Bool)
        {
            this._window.visible = k;
            if (!k)
            {
                this._questEngine.toolbar.extensionView.detachExtension(QUEST_TRACKER);
            }
            else
            {
                this._questEngine.toolbar.extensionView.attachExtension(QUEST_TRACKER, this._window);
            }
        }
    }

