package com.sulake.habbo.navigator
;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IInteractiveWindow;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.components.IBitmapWrapperWindow;
    import com.sulake.core.window.*;
    import com.sulake.core.window.components.*;

     class UserCountRenderer 
    {
        public static inline final USERCOUNT= "usercount";

        var _navigator:IHabboTransitionalNavigator;

        public function new(k:IHabboTransitionalNavigator)
        {
            this._navigator = k;
        }

        public function dispose()
        {
            this._navigator = null;
        }

        public function refreshUserCount(k:Int, _arg_2:IWindowContainer, _arg_3:Int, _arg_4:String, _arg_5:Int, _arg_6:Int)
        {
            var _local_7= cast(_arg_2.findChildByName(USERCOUNT), IWindowContainer);
            if (_local_7 == null)
            {
                _local_7 = cast(this._navigator.getXmlWindow("grs_usercount"), IWindowContainer);
                _local_7.name = USERCOUNT;
                _local_7.x = _arg_5;
                _local_7.y = _arg_6;
                _arg_2.addChild(_local_7);
            }
            cast(_local_7, IInteractiveWindow).toolTipCaption = _arg_4;
            var _local_8= cast(_local_7.findChildByName("txt"), ITextWindow);
            _local_8.text = ("" + Std.string(_arg_3));
            var _local_9= this.getBgColor(k, _arg_3);
            this._Str_23351(_local_7, _local_9);
            _local_7.visible = true;
        }

        function getBgColor(k:Int, _arg_2:Int):String
        {
            if (_arg_2 == 0)
            {
                return "b";
            }
            if (this._Str_18037(k, _arg_2, "red", 92))
            {
                return "r";
            }
            if (this._Str_18037(k, _arg_2, "orange", 80))
            {
                return "o";
            }
            if (this._Str_18037(k, _arg_2, "yellow", 50))
            {
                return "y";
            }
            return "g";
        }

        function _Str_18037(k:Int, _arg_2:Int, _arg_3:String, _arg_4:Int):Bool
        {
            var _local_5= ("navigator.colorlimit." + _arg_3);
            var _local_6= this._navigator.getInteger(_local_5, _arg_4);
            var _local_7= Std.int((k * _local_6) / 100);
            return _arg_2 >= _local_7;
        }

        function _Str_23351(k:IWindowContainer, _arg_2:String)
        {
            var _local_4:String = null;
            var _local_3= cast(k.findChildByName("usercount_bg"), IBitmapWrapperWindow);
            if (_local_3.tags[0] != _arg_2)
            {
                _local_3.tags.splice(0, _local_3.tags.length);
                _local_3.tags.push(_arg_2);
                _local_4 = ("usercount_fixed_" + _arg_2);
                _local_3.bitmap = this._navigator.getButtonImage(_local_4);
                _local_3.disposesBitmap = false;
                _local_3.invalidate();
            }
        }

        function _Str_17821(k:IWindowContainer, _arg_2:String, _arg_3:Bool)
        {
            this._navigator.refreshButton(k, _arg_2, _arg_3, null, 0);
        }
    }


