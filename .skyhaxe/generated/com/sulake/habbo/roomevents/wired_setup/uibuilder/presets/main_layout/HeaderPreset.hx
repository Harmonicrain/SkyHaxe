package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.main_layout
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IItemListWindow;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.Util;
    import com.sulake.habbo.roomevents.wired_setup.IWiredTypeHolder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SimpleListViewPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.WiredUIPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class HeaderPreset extends WiredUIPreset
    {
        public static inline final BUTTON_MODE_NONE= 0;
        public static inline final BUTTON_MODE_APPLY_SNAPSHOT= 1;
        public static inline final BUTTON_MODE_VARIABLE_MENU= 2;
        public static inline final BUTTON_MODE_VIEW_LOGS= 3;

        var _buttonMode:Int = 0;
        var _container:IWindowContainer;
        var _listPreset:SimpleListViewPreset;
        var _button:WiredUIPreset;
        var _width:Int = 0;

        public function new(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:String, _arg_5:IWiredTypeHolder, _arg_6:Int, _arg_7:ASFunction, _arg_8:ASFunction, _arg_9:ASFunction)
        {
            super(_arg_1, _arg_2, _arg_3);
            this._buttonMode = _arg_6;
            this._container = Std.downcast(_arg_2.createLayout("container_view") , IWindowContainer);
            var _local_10:Array<ASAny> = [];
            var _local_11= this.createTopHeaderElement(_arg_4, _arg_5);
            _local_10.push(_local_11);
            this._button = null;
            if (_arg_6 == BUTTON_MODE_APPLY_SNAPSHOT)
            {
                this._button = _arg_2.createTextualButtonPreset(loc("wiredfurni.applysnapshot"), _arg_7);
            }
            else if (_arg_6 == BUTTON_MODE_VARIABLE_MENU)
            {
                this._button = _arg_2.createTextualButtonPreset(loc("wiredfurni.view_in_menu"), _arg_8);
            }
            else if (_arg_6 == BUTTON_MODE_VIEW_LOGS)
            {
                this._button = _arg_2.createTextualButtonPreset(loc("wiredfurni.params.write_to_logs.view"), _arg_9);
            }
            if (this._button != null)
            {
                this._button = this._button.alignCenter();
                _local_10.push(this._button);
            }
            this._listPreset = _arg_2.createSimpleListView(true, _local_10);
            this._container.addChild(this._listPreset.window);
            this._listPreset.window.x = _style.headerMargin;
            this._listPreset.window.y = _style.headerMargin;
        }

        function createTopHeaderElement(_arg_1:String, _arg_2:IWiredTypeHolder):WiredUIPreset
        {
            return null;
        }

        public function updateName(_arg_1:String)
        {
        }

        public var buttonVisible(never,set):Bool;
public function  set_buttonVisible(_arg_1:Bool):Bool        {
            if (this._button.visible != _arg_1)
            {
                this._button.visible = _arg_1;
                this.resizeToWidth(this._width);
            }
return _arg_1;
        }

        override public function  get_window():IWindow
        {
            return this._container;
        }

        override public function resizeToWidth(_arg_1:Int)
        {
            super.resizeToWidth(_arg_1);
            this._width = _arg_1;
            var _local_2= (_style.headerMargin + (((this._button == null) || (!this._button.visible)) ? _style.headerMargin : _style.headerBottomMarginWithLink));
            this._listPreset.resizeToWidth(_arg_1 - (_style.headerMargin * 2));
            this._container.width = _arg_1;
            this._container.height = (Util.getLowestPointList(Std.downcast(this._listPreset.window , IItemListWindow)) + _local_2);
        }

        override function  get_childPresets():Array<ASAny>
        {
            return [this._listPreset];
        }

        override public function dispose()
        {
            if (disposed)
            {
                return;
            }
            super.dispose();
            this._container.dispose();
            this._container = null;
            this._listPreset = null;
        }
    }

