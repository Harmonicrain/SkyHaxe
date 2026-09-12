package com.sulake.habbo.friendbar.view.utils
;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.assets.BitmapDataAsset;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import flash.events.TimerEvent;

     class FriendListIcon extends Icon 
    {
        static inline final _Str_14569= 200;
        static inline final _Str_6576= 500;

        var _assets:IAssetLibrary;

        public function new(k:IAssetLibrary, _arg_2:IBitmapWrapperWindow)
        {
            super();
            this._assets = k;
            alignment = (Icon._Str_8982 | Icon._Str_8656);
            image = Std.downcast(k.getAssetByName("icon_friendlist_png") , BitmapDataAsset);
            canvas = _arg_2;
        }

        override public function dispose()
        {
            if (!disposed)
            {
                this._assets = null;
                super.dispose();
            }
        }

        override public function notify(k:Bool)
        {
            super.notify(k);
            this.enable(k);
            _Str_7231((k || _hover), (_hover ? _Str_14569 : _Str_6576));
            if (((!_Str_5470) && (!_hover)))
            {
                image = Std.downcast(this._assets.getAssetByName("icon_friendlist_png") , BitmapDataAsset);
            }
        }

        override public function hover(k:Bool)
        {
            super.hover(k);
            _Str_7231((k || _Str_5470), (_hover ? _Str_14569 : _Str_6576));
            if (((!_Str_5470) && (!_hover)))
            {
                image = Std.downcast(this._assets.getAssetByName("icon_friendlist_png") , BitmapDataAsset);
            }
        }

        override public function enable(k:Bool)
        {
            canvas.blend = (disabled ? 0.5 : 1);
        }

        override function onTimerEvent(k:TimerEvent)
        {
            if (_hover)
            {
                _frame = (++_frame % 4);
                image = Std.downcast(this._assets.getAssetByName((("icon_friendlist_hover_" + Std.string(_frame)) + "_png")) , BitmapDataAsset);
            }
            else
            {
                if (_Str_5470)
                {
                    _frame = (++_frame % 2);
                    image = Std.downcast(this._assets.getAssetByName((("icon_friendlist_notify_" + Std.string(_frame)) + "_png")) , BitmapDataAsset);
                }
            }
        }
    }

