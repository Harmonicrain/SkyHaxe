package com.sulake.habbo.friendbar.view.utils
;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.events.TimerEvent;

     class MessengerIcon extends Icon 
    {
        static inline final _Str_6576= 500;

        var _assets:IAssetLibrary;

        public function new(k:IAssetLibrary, _arg_2:IBitmapWrapperWindow)
        {
            super();
            this._assets = k;
            alignment = (Icon._Str_8982 | Icon._Str_8656);
            image = Std.downcast(k.getAssetByName("icon_messenger_png") , BitmapDataAsset);
            canvas = _arg_2;
        }

        override public function notify(k:Bool)
        {
            super.notify(k);
            image = Std.downcast(this._assets.getAssetByName((k ? "icon_messenger_notify_1_png" : "icon_messenger_png")) , BitmapDataAsset);
            _Str_7231(k, _Str_6576);
        }

        override public function hover(k:Bool)
        {
            super.hover(k);
        }

        override public function enable(k:Bool)
        {
            super.enable(k);
            canvas.visible = k;
        }

        override function onTimerEvent(k:TimerEvent)
        {
            if (_Str_5470)
            {
                _frame = ((_frame == 1) ? 0 : 1);
                image = Std.downcast(this._assets.getAssetByName((("icon_messenger_notify_" + Std.string(_frame)) + "_png")) , BitmapDataAsset);
            }
        }
    }

