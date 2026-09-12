package com.sulake.habbo.friendbar.landingview.widget
;
    import com.sulake.habbo.friendbar.landingview.interfaces.ILandingViewWidget;
    import com.sulake.habbo.friendbar.landingview.interfaces.ISlotAwareWidget;
    import com.sulake.habbo.friendbar.landingview.HabboLandingView;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.friendbar.landingview.layout.CommonWidgetSettings;
    import com.sulake.habbo.friendbar.landingview.layout.WidgetPlaceholder;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.communication.messages.incoming.competition.CurrentTimingCodeMessageEvent;
    import com.sulake.habbo.communication.messages.outgoing.competition.GetCurrentTimingCodeMessageComposer;
    import com.sulake.habbo.friendbar.landingview.layout.HabboLandingViewWidgets;
    import com.sulake.habbo.friendbar.landingview.interfaces._Str_6397;
    import com.sulake.habbo.friendbar.landingview.*;

     class WidgetContainerWidget implements ILandingViewWidget implements  ISlotAwareWidget 
    {
        var _landingView:HabboLandingView;
        var _container:IWindowContainer;
        var _widgets:ASDictionary<ASAny,ASAny>;
        var _commonWidgetSettings:CommonWidgetSettings;
        var _slot:Int = 0;
        var _schedulingStr:String;
        var _currentWidget:WidgetPlaceholder;

        public function new(k:HabboLandingView)
        {
            this._widgets = new ASDictionary<ASAny,ASAny>();
            this._landingView = k;
        }

        public static function hideChildren(k:IWindowContainer)
        {
            var _local_2 = 0;
            while (_local_2 < k.numChildren)
            {
                k.getChildAt(_local_2).visible = false;
                _local_2++;
            }
        }


        public var slot(never,set):Int;
public function  set_slot(k:Int):Int        {
            return this._slot = k;
        }

        public var container(get,never):IWindow;
public function  get_container():IWindow
        {
            return this._container;
        }

        public function dispose()
        {
            this._landingView = null;
            this._container = null;
        }

        public function initialize()
        {
            this._container = cast(this._landingView.getXmlWindow("widget_container_widget"), IWindowContainer);
            this._commonWidgetSettings = new CommonWidgetSettings(this._landingView);
            this._landingView.communicationManager.addHabboConnectionMessageEvent(new CurrentTimingCodeMessageEvent(this.onTimingCode));
            this._schedulingStr = this._landingView.getProperty((("landing.view.dynamic.slot." + Std.string(this._slot)) + ".conf"));
        }

        public function refresh()
        {
            this._landingView.send(new GetCurrentTimingCodeMessageComposer(this._schedulingStr));
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._landingView == null;
        }

        function refreshContent()
        {
            hideChildren(this._container);
            if (this._currentWidget != null)
            {
                this._currentWidget.refresh(this._container);
                this._currentWidget.container.visible = true;
                this._container.height = this._currentWidget.container.height;
                this._container.width = this._currentWidget.container.width;
            }
        }

        function _Str_22575(k:String):WidgetPlaceholder
        {
            var _local_2= this._landingView.getProperty((("landing.view." + k) + ".widget"));
            var _local_3= HabboLandingViewWidgets.createWidget(_local_2, this._landingView);
            if (_local_3 == null)
            {
                return null;
            }
            if (Std.is(_local_3 , ISlotAwareWidget))
            {
                cast(_local_3, ISlotAwareWidget).slot = this._slot;
            }
            if (Std.is(_local_3 , _Str_6397))
            {
                cast(_local_3, _Str_6397)._Str_12275 = k;
            }
            var _local_4= new WidgetPlaceholder(_local_3, null, this._commonWidgetSettings, this._container);
            this._widgets[k] = _local_4;
            return _local_4;
        }

        function onTimingCode(k:CurrentTimingCodeMessageEvent)
        {
            if (((k.getParser().schedulingStr == this._schedulingStr) && (!this.disposed)))
            {
                this._Str_22315(k.getParser().code);
                this.refreshContent();
            }
        }

        function _Str_22315(k:String)
        {
            if (k == "")
            {
                this._currentWidget = null;
                return;
            }
            var _local_2:WidgetPlaceholder = this._widgets[k];
            if (_local_2 == null)
            {
                _local_2 = this._Str_22575(k);
            }
            this._currentWidget = _local_2;
        }
    }

