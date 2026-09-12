package com.sulake.habbo.ui.widget.furniture.trophy
;
    import com.sulake.habbo.ui.widget.RoomWidgetBase;
    import com.sulake.core.runtime.IHabboConfigurationManager;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.ui.widget.events._Str_5099;
    import flash.events.IEventDispatcher;

     class TrophyFurniWidget extends RoomWidgetBase implements ITrophyFurniWidget
    {
        public static inline final _Str_12649= 10;
        public static inline final _Str_10142= 20;

        var _name:String;
        var _date:String;
        var _message:String;
        var _color:Int = 0;
        var _configuration:IHabboConfigurationManager;
        var _view:ITrophyView;
        var _viewType:Int = 0;

        public function new(k:IRoomWidgetHandler, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary, _arg_4:IHabboLocalizationManager, _arg_5:IHabboConfigurationManager)
        {
            super(k, _arg_2, _arg_3, _arg_4);
            this._configuration = _arg_5;
        }

        public var name(get,never):String;
public function  get_name():String
        {
            return this._name;
        }

        public var date(get,never):String;
public function  get_date():String
        {
            return this._date;
        }

        public var message(get,never):String;
public function  get_message():String
        {
            return this._message;
        }

        public var color(get,never):Int;
public function  get_color():Int
        {
            return this._color;
        }

        public var configuration(get,never):IHabboConfigurationManager;
public function  get_configuration():IHabboConfigurationManager
        {
            return this._configuration;
        }

        override public function dispose()
        {
            if (this._view != null)
            {
                this._view.dispose();
                this._view = null;
            }
            this._configuration = null;
            super.dispose();
        }

        override public function registerUpdateEvents(k:IEventDispatcher)
        {
            if (k == null)
            {
                return;
            }
            k.addEventListener(_Str_5099.RWTDUE_TROPHY_DATA, this.onObjectUpdate);
            super.registerUpdateEvents(k);
        }

        override public function unregisterUpdateEvents(k:IEventDispatcher)
        {
            if (k == null)
            {
                return;
            }
            k.removeEventListener(_Str_5099.RWTDUE_TROPHY_DATA, this.onObjectUpdate);
        }

        function onObjectUpdate(k:_Str_5099)
        {
            this._name = k.name;
            this._date = k.date;
            this._message = k.message;
            this._color = Std.int(k.color - 1);
            this._viewType = k._Str_16299;
            if (((this._color < 0) || (this._color > 2)))
            {
                this._color = 0;
            }
            this._Str_17002();
        }

        function _Str_17002()
        {
            if (this._view != null)
            {
                this._view.dispose();
            }
            switch (this._viewType)
            {
                case _Str_10142
                   | _Str_12649:
                    this._view = new NikoTrophyView(this, this._viewType);
                    
                default:
                    this._view = new TrophyView(this);
            }
            this._view.showInterface();
        }
    }

