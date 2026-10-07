package com.sulake.habbo.ui.widget.infostand
;
    import flash.geom.Rectangle;
    import com.sulake.core.window.components.ITextWindow;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window.events.WindowMouseEvent;

     class TagListRenderer 
    {
        static inline final _Str_11311= 5;
        static inline final _Str_11646= 5;

        var _widget:InfoStandWidget;
        var _listener:ASFunction;
        var _offsetX:Int = 0;
        var _offsetY:Int = 0;
        var _rect:Rectangle = null;
        var _windowId:Int = 0;
        var _targetTags:Array<ASAny>;

        public function new(k:InfoStandWidget, _arg_2:ASFunction)
        {
            this._widget = k;
            this._listener = _arg_2;
        }

        public function dispose()
        {
            this._widget = null;
            this._listener = null;
        }

        public function _Str_23731(k:Array<ASAny>, _arg_2:IWindowContainer, _arg_3:Array<ASAny>):Int
        {
            var _local_4:ITextWindow = null;
            var _local_8:Array<ASAny> = null;
            var _local_9:String = null;
            this._targetTags = _arg_3;
            if (this._targetTags != null)
            {
                _local_8 = [];
                while ((_local_9 = k.pop()) != null)
                {
                    if (_arg_3.indexOf(_local_9) != -1)
                    {
                        _local_8.unshift(_local_9);
                    }
                    else
                    {
                        _local_8.push(_local_9);
                    }
                }
                k = _local_8;
            }
            do 
            {
            } while (_arg_2.removeChildAt(0) != null);
            this._windowId = 0;
            this._offsetX = 0;
            this._offsetY = 0;
            this._rect = _arg_2.rectangle;
            this._rect.height = 150;
            var _local_5 = 0;
            while (_local_5 < k.length)
            {
                _local_4 = this._Str_23992(ASCompat.asString(k[_local_5] ));
                if (this._Str_6528(_local_4))
                {
                    _arg_2.addChild(_local_4);
                }
                else
                {
                    _local_4.dispose();
                }
                _local_5++;
            }
            var _local_6= _arg_2.numChildren;
            if (_local_6 == 0)
            {
                return 0;
            }
            var _local_7= _arg_2.getChildAt((_arg_2.numChildren - 1));
            return _local_7.bottom;
        }

        function _Str_6528(k:IWindow):Bool
        {
            if (k.width > this._rect.width)
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
                this._offsetY = (this._offsetY + (k.height + TagListRenderer._Str_11646));
                return this._Str_6528(k);
            }
            k.offset(this._offsetX, this._offsetY);
            this._offsetX = (this._offsetX + (k.width + TagListRenderer._Str_11311));
            return true;
        }

        function _Str_23992(k:String):ITextWindow
        {
            var _local_2:XmlAsset = null;
            if (((!(this._targetTags == null)) && (!(this._targetTags.indexOf(k) == -1))))
            {
                _local_2 = Std.downcast(this._widget.assets.getAssetByName("user_tag_highlighted") , XmlAsset);
            }
            else
            {
                _local_2 = Std.downcast(this._widget.assets.getAssetByName("user_tag") , XmlAsset);
            }
            if (_local_2 == null)
            {
                return null;
            }
            var _local_3= Std.downcast(this._widget.windowManager.buildFromXML(((_local_2.content : com.sulake.core.utils.xml.XML) )) , ITextWindow);
            if (_local_3 == null)
            {
                throw new ASError("Failed to construct window from XML!");
            }
            _local_3.addEventListener(WindowMouseEvent.CLICK, this._listener);
            _local_3.caption = k;
            return _local_3;
        }
    }

