package com.sulake.habbo.ui.widget.furniture.highscore
;
    import com.sulake.habbo.ui.widget.RoomWidgetBase;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IBubbleWindow;
    import flash.geom.Point;
    import com.sulake.habbo.ui.handler.HighScoreFurniWidgetHandler;
    import com.sulake.core.window._enum.WindowType;
    import com.sulake.core.window._enum.WindowStyle;
    import com.sulake.core.window._enum.WindowParam;
    import flash.geom.Rectangle;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.room.object.data.HighScoreData;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.room.object.data.HighScoreStuffData;

     class HighScoreDisplayWidget extends RoomWidgetBase
    {
        public static inline final _Str_8951= -1;
        static inline final _Str_15987= -138;
        static inline final _Str_18725= -400;
        static inline final _Str_21806= 0;
        static inline final _Str_21875= 1;
        static inline final _Str_19575= 2;
        static inline final _Str_21517= 0;
        static inline final _Str_19512= 1;
        static inline final _Str_20113= 2;
        static inline final _Str_20184= 3;
        static final _Str_18189:Array<ASAny> = ["perteam", "mostwins", "classic"];
        static final _Str_18147:Array<ASAny> = ["alltime", "daily", "weekly", "monthly"];

        var _rootContainerBackground:IWindowContainer;
        var _bubble:IBubbleWindow;
        var _entryTemplate:IWindowContainer;
        var _roomId:Int = -1;
        var _roomObjId:Int = -1;
        var _lastPosition:Point;

        public function new(k:IRoomWidgetHandler, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary=null, _arg_4:IHabboLocalizationManager=null)
        {
            this._lastPosition = new Point(0, 0);
            super(k, _arg_2, _arg_3, _arg_4);
            cast(k, HighScoreFurniWidgetHandler).widget = this;
            this._rootContainerBackground = cast(_arg_2.createWindow("room_widget_highscore_background_container", "", WindowType.WINDOW_TYPE_CONTAINER, WindowStyle.WINDOW_STYLE_DEFAULT, WindowParam.WINDOW_PARAM_NULL, new Rectangle(0, 0, 10, 10)), IWindowContainer);
            this._Str_18177();
            this._rootContainerBackground.addEventListener(WindowEvent.WINDOW_EVENT_PARENT_RESIZED, this._Str_18177);
        }

        function _Str_18177(k:WindowEvent=null)
        {
            this._rootContainerBackground.width = this._rootContainerBackground.desktop.width;
            this._rootContainerBackground.height = this._rootContainerBackground.desktop.height;
        }

        override public function  get_mainWindow():IWindow
        {
            return this._rootContainerBackground;
        }

        override public function dispose()
        {
            if (this._bubble != null)
            {
                this.destroyWindow();
            }
            this._rootContainerBackground.removeEventListener(WindowEvent.WINDOW_EVENT_PARENT_RESIZED, this._Str_18177);
            this._rootContainerBackground.dispose();
            super.dispose();
        }

        public function open(k:Int, _arg_2:Int, _arg_3:HighScoreStuffData)
        {
            var _local_5:HighScoreData = null;
            var _local_6:String = null;
            var _local_7:String = null;
            var _local_8:IWindowContainer = null;
            if (this._bubble != null)
            {
                this.destroyWindow();
            }
            if (((!(_arg_3.clearType == _Str_8951)) && (!(_arg_3.scoreType == _Str_8951))))
            {
                _local_6 = cast(_handler, HighScoreFurniWidgetHandler).container.localization.getLocalization(("high.score.display.cleartype." + _Str_18147[_arg_3.clearType]));
                _local_7 = cast(_handler, HighScoreFurniWidgetHandler).container.localization.getLocalization(("high.score.display.scoretype." + _Str_18189[_arg_3.scoreType]));
                cast(_handler, HighScoreFurniWidgetHandler).container.localization.registerParameter("high.score.display.caption", "cleartype", _local_6);
                cast(_handler, HighScoreFurniWidgetHandler).container.localization.registerParameter("high.score.display.caption", "scoretype", _local_7);
            }
            this._roomId = _arg_2;
            this._roomObjId = k;
            this.createWindow();
            if (this._entryTemplate == null)
            {
                Logger.log(["ERROR: 'entry_template' could not found from high score display's window XML"]);
                return;
            }
            var _local_4= cast(this._bubble.findChildByName("entries"), IItemListWindow);
            final _iter_ = _arg_3.entries; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_5  = _tmp_;
                _local_8 = cast(this._entryTemplate.clone(), IWindowContainer);
                _local_8.getChildByName("usernames").caption = this.getUserNameList(_local_5.users);
                _local_8.getChildByName("score").caption = Std.string(_local_5.score);
                _local_4.addListItem(_local_8);
            }
            _local_4.invalidate();
        }

        function getUserNameList(k:Array<ASAny>):String
        {
            var _local_3:String = null;
            var _local_2= "";
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_3  = _tmp_;
                _local_2 = ((_local_2 + _local_3) + ", ");
            }
            return _local_2.substr(0, (_local_2.length - 2));
        }

        public function _Str_23957(k:Int, _arg_2:Int)
        {
            if (this._bubble == null)
            {
                return;
            }
            this._bubble.x = (k + _Str_15987);
            this._bubble.y = (_arg_2 + _Str_18725);
        }

        function createWindow()
        {
            var k= cast(windowManager.buildFromXML(new com.sulake.core.utils.xml.XML(assets.getAssetByName("high_score_display_xml").content)), IBubbleWindow);
            this._entryTemplate = cast(k.findChildByName("entry_template"), IWindowContainer);
            cast(k.findChildByName("entries"), IItemListWindow).removeListItem(this._entryTemplate);
            this._bubble = k;
            this._bubble.x = Std.int(this._lastPosition.x);
            this._bubble.y = Std.int(this._lastPosition.y);
            this._rootContainerBackground.addChild(k);
        }

        function destroyWindow()
        {
            this._rootContainerBackground.removeChild(this._bubble);
            this._lastPosition.x = this._bubble.x;
            this._lastPosition.y = this._bubble.y;
            this._bubble.dispose();
            this._bubble = null;
            this._roomId = _Str_8951;
            this._roomObjId = _Str_8951;
        }

        public var isOpen(get,never):Bool;
public function  get_isOpen():Bool
        {
            return (!(this._bubble == null)) && this._bubble.visible;
        }

        public var roomId(get,never):Int;
public function  get_roomId():Int
        {
            return this._roomId;
        }

        public var _Str_21467(get,never):Int;
public function  get__Str_21467():Int
        {
            return this._roomObjId;
        }

        public function close()
        {
            this.destroyWindow();
        }
    }

