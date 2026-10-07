package com.sulake.habbo.help.namechange
;
    import com.sulake.habbo.help.INameChangeUI;
    import flash.geom.Rectangle;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;

     class NameSuggestionListRenderer 
    {
        static inline final _Str_11311= 5;
        static inline final _Str_11646= 5;

        var _main:INameChangeUI;
        var _offsetX:Int = 0;
        var _offsetY:Int = 0;
        var _rect:Rectangle = null;
        var _windowId:Int = 0;

        public function new(k:INameChangeUI)
        {
            this._main = k;
        }

        public function dispose()
        {
            this._main = null;
        }

        public function render(k:Array<ASAny>, _arg_2:IWindowContainer):Int
        {
            var _local_3:ITextWindow = null;
            var _local_7:IWindow = null;
            while (_arg_2.numChildren > 0)
            {
                _local_7 = _arg_2.removeChildAt(0);
                _local_7.dispose();
            }
            _arg_2.parent.invalidate();
            this._windowId = 0;
            this._offsetX = 0;
            this._offsetY = 0;
            this._rect = _arg_2.rectangle;
            this._rect.height = 150;
            var _local_4 = 0;
            while (_local_4 < k.length)
            {
                _local_3 = this._Str_16658(ASCompat.asString(k[_local_4] ));
                if (this._Str_6528(_local_3))
                {
                    _arg_2.addChild(_local_3);
                }
                else
                {
                    _local_3.dispose();
                }
                _local_4++;
            }
            var _local_5= _arg_2.numChildren;
            if (_local_5 == 0)
            {
                return 0;
            }
            var _local_6= _arg_2.getChildAt((_arg_2.numChildren - 1));
            return _local_6.bottom;
        }

        function _Str_6528(k:IWindow):Bool
        {
            if (((k.width > this._rect.width) || (k.width < 2)))
            {
                return false;
            }
            if ((this._offsetY + k.height) > this._rect.height)
            {
                return false;
            }
            if ((this._offsetX + k.width) > this._rect.width)
            {
                this._offsetX = 0;
                this._offsetY = (this._offsetY + (k.height + NameSuggestionListRenderer._Str_11646));
                return this._Str_6528(k);
            }
            k.x = (k.x + this._offsetX);
            k.y = (k.y + this._offsetY);
            this._offsetX = (this._offsetX + (k.width + NameSuggestionListRenderer._Str_11311));
            return true;
        }

        function _Str_16658(k:String):ITextWindow
        {
            var _local_2= Std.downcast(this._main.buildXmlWindow("welcome_name_suggestion_item") , ITextWindow);
            if (_local_2 == null)
            {
                return null;
            }
            _local_2.text = k;
            return _local_2;
        }
    }

