package com.sulake.core.window.graphics
;
    import com.sulake.core.window._enum.WindowState;
    import com.sulake.core.window.graphics.renderer.ISkinRenderer;
    import com.sulake.core.window.utils.DefaultAttStruct;
    import com.sulake.core.window._enum.WindowStyle;
    import com.sulake.core.window.graphics.renderer.*;

     class SkinContainer implements ISkinContainer 
    {
        static inline final _Str_8830:UInt = 100;
        static var _Str_4802:Array<ASAny>;

        var _disposed:Bool = false;
        var _skinRendererTable:ASDictionary<ASAny,ASAny>;
        var _defaultAttrTable:ASDictionary<ASAny,ASAny>;
        var _windowLayoutTable:ASDictionary<ASAny,ASAny>;
        var _intentTable:ASDictionary<ASAny,ASAny>;

        public function new()
        {
            this._skinRendererTable = new ASDictionary<ASAny,ASAny>();
            this._defaultAttrTable = new ASDictionary<ASAny,ASAny>();
            this._windowLayoutTable = new ASDictionary<ASAny,ASAny>();
            this._intentTable = new ASDictionary<ASAny,ASAny>();
            if (_Str_4802 == null)
            {
                _Str_4802 = new Array<ASAny>();
                _Str_4802.push(WindowState.LOCKED);
                _Str_4802.push(WindowState.DISABLED);
                _Str_4802.push(WindowState.PRESSED);
                _Str_4802.push(WindowState.SELECTED);
                _Str_4802.push(WindowState.HOVERING);
                _Str_4802.push(WindowState.FOCUSED);
                _Str_4802.push(WindowState.ACTIVE);
                _Str_4802.push(WindowState.DEFAULT);
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function dispose()
        {
            this._skinRendererTable = null;
            this._defaultAttrTable = null;
            this._windowLayoutTable = null;
            this._intentTable = null;
            this._disposed = true;
        }

        public function _Str_23324(k:UInt, _arg_2:UInt, _arg_3:String, _arg_4:ISkinRenderer, _arg_5:com.sulake.core.utils.xml.XML, _arg_6:DefaultAttStruct)
        {
            if (this._skinRendererTable[k] == null)
            {
                this._skinRendererTable[k] = ASCompat.allocArray(_Str_8830);
            }
            this._skinRendererTable[k][_arg_2] = _arg_4;
            if (this._defaultAttrTable[k] == null)
            {
                this._defaultAttrTable[k] = ASCompat.allocArray(_Str_8830);
            }
            this._defaultAttrTable[k][_arg_2] = _arg_6;
            if (this._windowLayoutTable[k] == null)
            {
                this._windowLayoutTable[k] = ASCompat.allocArray(_Str_8830);
            }
            this._windowLayoutTable[k][_arg_2] = _arg_5;
            if (this._intentTable[k] == null)
            {
                this._intentTable[k] = ASCompat.allocArray(_Str_8830);
            }
            this._intentTable[k][_arg_2] = (((!(_arg_3 == null)) && (_arg_3.length > 0)) ? _arg_3 : Std.string(_arg_2));
        }

        public function _Str_18054(k:UInt, _arg_2:UInt):ISkinRenderer
        {
            var _local_4:ISkinRenderer = null;
            var _local_3:Array<ASAny> = this._skinRendererTable[k];
            if (_local_3 != null)
            {
                _local_4 = _local_3[ASCompat.toInt(_arg_2)];
                if (((!(_local_4 != null)) && (!(_arg_2 == WindowStyle.WINDOW_STYLE_DEFAULT))))
                {
                    _local_4 = _local_3[ASCompat.toInt(WindowStyle.WINDOW_STYLE_DEFAULT)];
                }
            }
            return _local_4;
        }

        public function _Str_20972(k:UInt, _arg_2:UInt):Bool
        {
            return ASCompat.toBool(this._skinRendererTable[k]) && ASCompat.toBool(this._skinRendererTable[k][_arg_2]);
        }

        public function _Str_21732(k:UInt, _arg_2:UInt):DefaultAttStruct
        {
            var _local_4:DefaultAttStruct = null;
            var _local_3:Array<ASAny> = this._defaultAttrTable[k];
            if (_local_3 != null)
            {
                _local_4 = _local_3[ASCompat.toInt(_arg_2)];
                if (((!(_local_4 != null)) && (!(_arg_2 == WindowStyle.WINDOW_STYLE_DEFAULT))))
                {
                    _local_4 = _local_3[ASCompat.toInt(WindowStyle.WINDOW_STYLE_DEFAULT)];
                }
            }
            return _local_4;
        }

        public function _Str_23436(k:UInt, _arg_2:UInt):com.sulake.core.utils.xml.XML
        {
            var _local_3:Array<ASAny> = this._windowLayoutTable[k];
            if (_local_3 == null)
            {
                return null;
            }
            if (_local_3[ASCompat.toInt(_arg_2)] == null)
            {
                return _local_3[0];
            }
            return _local_3[ASCompat.toInt(_arg_2)];
        }

        public function _Str_16505(k:UInt, _arg_2:UInt):String
        {
            var _local_3:Array<ASAny> = this._intentTable[k];
            return ((!(_local_3 == null)) && (!(_local_3[ASCompat.toInt(_arg_2)] == null))) ? _local_3[ASCompat.toInt(_arg_2)] : null;
        }

        public function _Str_15965(k:UInt, _arg_2:UInt, _arg_3:UInt):UInt
        {
            var _local_5:UInt = 0;
            var _local_4= this._Str_18054(k, _arg_2);
            if (_local_4 != null)
            {
                final _iter_ = _Str_4802; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_5  = ASCompat.toUInt(_tmp_);
                    if (((ASCompat.toInt(_arg_3 )& ASCompat.toInt(_local_5)) : UInt) == _local_5)
                    {
                        if (_local_4.isStateDrawable(_local_5))
                        {
                            return _local_5;
                        }
                    }
                }
            }
            return 0;
        }
    }

