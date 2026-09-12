package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class StaticBitmapAssetWrapperPreset extends WiredUIPreset
    {
        var _container:IStaticBitmapWrapperWindow;

        public function new(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:String)
        {
            super(_arg_1, _arg_2, _arg_3);
            this._container = Std.downcast(_arg_2.createLayout("static_bitmap_view") , IStaticBitmapWrapperWindow);
            this._container.assetUri = _arg_4;
        }

        override public function  get_window():IWindow
        {
            return this._container;
        }

        
        public var assetUri(get,set):String;
public function  get_assetUri():String
        {
            return this._container.assetUri;
        }
public function  set_assetUri(_arg_1:String):String        {
            return this._container.assetUri = _arg_1;
        }

        override public function resizeToWidth(_arg_1:Int)
        {
            super.resizeToWidth(_arg_1);
        }

        override public function hasStaticWidth():Bool
        {
            return true;
        }

        override public function  get_staticWidth():Int
        {
            return this._container.width;
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
        }
    }

