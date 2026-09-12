package com.sulake.habbo.quest
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.widgets.IBadgeImageWidget;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.IWindowContainer;

     class AchievementResolutionCompletedView implements IDisposable 
    {
        static inline final HEADER_BUTTON_CLOSE= "header_button_close";
        static inline final CANCEL_BUTTON= "cancel_button";

        var _controller:AchievementsResolutionController;
        var _window:IFrameWindow;
        var _badgeCode:String;
        var _stuffCode:String;

        public function new(k:AchievementsResolutionController)
        {
            this._controller = k;
        }

        public function dispose()
        {
            this._controller = null;
            if (this._window != null)
            {
                this._window.dispose();
                this._window = null;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return !(this._controller == null);
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

        public function show(k:String, _arg_2:String)
        {
            if (this._window == null)
            {
                this.createWindow();
            }
            this._Str_10233();
            this._stuffCode = k;
            this._badgeCode = _arg_2;
            this._Str_5605(this._badgeCode);
            this._window.visible = true;
        }

        function createWindow()
        {
            this._window = cast(this._controller.questEngine.getXmlWindow("AchievementResolutionCompleted"), IFrameWindow);
            this.addClickListener(HEADER_BUTTON_CLOSE);
            this.addClickListener(CANCEL_BUTTON);
        }

        function addClickListener(k:String)
        {
            var _local_2= this._window.findChildByName(k);
            if (_local_2 != null)
            {
                _local_2.addEventListener(WindowMouseEvent.CLICK, this.onMouseClick);
            }
        }

        function onMouseClick(k:WindowMouseEvent)
        {
            switch (k.target.name)
            {
                case HEADER_BUTTON_CLOSE
                   | CANCEL_BUTTON:
                    this.close();
                    return;
            }
        }

        function _Str_10233()
        {
            this._window.center();
        }

        function _Str_5605(k:String)
        {
            var _local_2= Std.downcast(this._window.findChildByName("achievement_badge") , IWidgetWindow);
            var _local_3= Std.downcast(_local_2.widget , IBadgeImageWidget);
            cast(cast(_local_2.rootWindow, IWindowContainer).findChildByName("bitmap"), IStaticBitmapWrapperWindow).assetUri = "common_loading_icon";
            _local_3.badgeId = k;
            _local_2.visible = true;
        }

        public function close()
        {
            if (this._window != null)
            {
                this._window.visible = false;
            }
        }
    }

