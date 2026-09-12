package com.sulake.habbo.quest
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.widgets.IBadgeImageWidget;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.window.widgets.ICountdownWidget;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class AchievementResolutionProgressView implements IDisposable 
    {
        static inline final ACHIEVED_LEFT= "achieved_left";
        static inline final ACHIEVED_MID= "achieved_mid";
        static inline final ACHIEVED_RIGHT= "achieved_right";

        var _progressSteps:Int = 0;
        var _controller:AchievementsResolutionController;
        var _window:IFrameWindow;
        var _stuffId:Int = 0;
        var _achievementId:Int = 0;
        var _badgeCode:String;

        public function new(k:AchievementsResolutionController)
        {
            this._controller = k;
        }

        public function dispose()
        {
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
            this._controller = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._controller == null;
        }

        public var achievementId(get,never):Int;
public function  get_achievementId():Int
        {
            return this._achievementId;
        }

        public var stuffId(get,never):Int;
public function  get_stuffId():Int
        {
            return this._stuffId;
        }

        public var visible(get,never):Bool;
public function  get_visible():Bool
        {
            if (this._window == null)
            {
                return false;
            }
            return this._window.visible;
        }

        public function show(k:Int, _arg_2:Int, _arg_3:String, _arg_4:Int, _arg_5:Int, _arg_6:Int)
        {
            if (this._window == null)
            {
                this.createWindow();
            }
            if (_arg_2 != this._achievementId)
            {
                this._Str_10233();
                this._window.center();
            }
            this._stuffId = k;
            this._achievementId = _arg_2;
            this._badgeCode = _arg_3;
            this._Str_11199(_arg_4, _arg_5);
            this._Str_5605(this._badgeCode);
            this._Str_24386();
            this._Str_23834(_arg_6);
            this._window.visible = true;
        }

        function _Str_11199(k:Int, _arg_2:Int)
        {
            var _local_3= Math.min(1, (k / _arg_2));
            if (_local_3 > 0)
            {
                this._window.setVisibleChildren(true, [ACHIEVED_LEFT, ACHIEVED_MID]);
                this._window.findChildByName(ACHIEVED_RIGHT).visible = (_local_3 == 1);
            }
            this._window.findChildByName(ACHIEVED_MID).width = Std.int(this._progressSteps * _local_3);
            this._controller.questEngine.localization.registerParameter("resolution.progress.progress", "progress", Std.string(k));
            this._controller.questEngine.localization.registerParameter("resolution.progress.progress", "total", Std.string(_arg_2));
        }

        function _Str_5605(k:String)
        {
            var _local_2= Std.downcast(this._window.findChildByName("achievement_badge") , IWidgetWindow);
            var _local_3= Std.downcast(_local_2.widget , IBadgeImageWidget);
            cast(cast(_local_2.rootWindow, IWindowContainer).findChildByName("bitmap"), IStaticBitmapWrapperWindow).assetUri = "common_loading_icon";
            _local_3.badgeId = k;
            _local_2.visible = true;
        }

        function _Str_24386()
        {
            this._window.findChildByName("achievement.name").caption = this._controller.questEngine.localization.getBadgeName(this._badgeCode);
            this._window.findChildByName("achievement.desc").caption = this._controller.questEngine.localization.getBadgeDesc(this._badgeCode);
        }

        function _Str_23834(k:Int)
        {
            var _local_2= cast(this._window.findChildByName("time_left_widget"), IWidgetWindow);
            var _local_3= cast(_local_2.widget, ICountdownWidget);
            _local_3.seconds = k;
            _local_3.running = true;
        }

        function createWindow()
        {
            this._window = cast(this._controller.questEngine.getXmlWindow("AchievementResolutionProgress"), IFrameWindow);
            this._window.findChildByTag("close").procedure = this.onWindowClose;
            this._window.findChildByName("reset_button").procedure = this._Str_25050;
            this._progressSteps = this._window.findChildByName(ACHIEVED_MID).width;
        }

        function _Str_10233()
        {
            this._window.center();
            this._window.setVisibleChildren(false, [ACHIEVED_LEFT, ACHIEVED_MID, ACHIEVED_RIGHT]);
        }

        public function close()
        {
            if (this._window != null)
            {
                this._window.visible = false;
            }
        }

        function onWindowClose(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                this.close();
            }
        }

        function _Str_25050(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                this._controller._Str_23910(this._stuffId);
                this.close();
            }
        }
    }

