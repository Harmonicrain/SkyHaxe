package com.sulake.core.window.graphics.renderer
;
    import com.sulake.core.window.utils.TextStyle;
    import com.sulake.core.assets.IAsset;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.window.IWindow;
    import flash.display.BitmapData;
    import flash.geom.Rectangle;

     class SkinRenderer implements ISkinRenderer 
    {
        static final _Str_3766:ASDictionary<ASAny,ASAny> = new ASDictionary();

        var _name:String;
        var _disposed:Bool = false;
        var _Str_4990:ASDictionary<ASAny,ASAny>;
        var _Str_5217:ASDictionary<ASAny,ASAny>;
        var _Str_5788:ASDictionary<ASAny,ASAny>;
        var _Str_5580:ASDictionary<ASAny,ASAny>;

        public function new(k:String)
        {
            this._name = k;
            this._Str_4990 = new ASDictionary<ASAny,ASAny>();
            this._Str_5217 = new ASDictionary<ASAny,ASAny>();
            this._Str_5788 = new ASDictionary<ASAny,ASAny>();
            this._Str_5580 = new ASDictionary<ASAny,ASAny>();
        }

        public var name(get,never):String;
public function  get_name():String
        {
            return this._name;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function parse(k:IAsset, _arg_2:com.sulake.core.utils.xml.XMLList, _arg_3:IAssetLibrary)
        {
        }

        public function dispose()
        {
var k:String  = null;            var k:String = null;
            if (!this._disposed)
            {
                final _iter_ = this._Str_5788; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
                {
k = _tmp_;
                    cast(this._Str_5788[k], ISkinLayout).dispose();
                    this._Str_5788.remove(k);
                }
                this._Str_5788 = null;
                this._Str_5580 = null;
                final _iter_ = this._Str_4990; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
                {
k = _tmp_;
                    cast(this._Str_4990[k], ISkinTemplate).dispose();
                    this._Str_4990.remove(k);
                }
                this._Str_4990 = null;
                this._Str_5217 = null;
            }
        }

        public function draw(k:IWindow, _arg_2:BitmapData, _arg_3:Rectangle, _arg_4:UInt, _arg_5:Bool)
        {
        }

        public function isStateDrawable(k:UInt):Bool
        {
            return false;
        }

        public function _Str_22661(k:UInt):ISkinLayout
        {
            return this._Str_5580[k];
        }

        public function _Str_21977(k:UInt, _arg_2:String)
        {
            var _local_3:ISkinLayout = this._Str_5788[_arg_2];
            if (_local_3 == null)
            {
                throw new ASError((('Layout "' + _arg_2) + '" not found in renderer!'));
            }
            this._Str_5580[k] = _local_3;
        }

        public function _Str_19884(k:UInt)
        {
            this._Str_5580.remove(k);
        }

        public function _Str_23297(k:UInt):Bool
        {
            return !(this._Str_5580[k] == null);
        }

        public function _Str_25215(k:UInt):ISkinTemplate
        {
            return this._Str_5217[k];
        }

        public function _Str_19639(k:UInt, _arg_2:String)
        {
            var _local_3:ISkinTemplate = this._Str_4990[_arg_2];
            if (_local_3 == null)
            {
                throw new ASError((('Template "' + _arg_2) + '" not found in renderer!'));
            }
            this._Str_5217[k] = _local_3;
        }

        public function _Str_21934(k:UInt)
        {
            this._Str_5217.remove(k);
        }

        public function _Str_25392(k:UInt):Bool
        {
            return !(this._Str_5217[k] == null);
        }

        public function _Str_20341(k:ISkinLayout):ISkinLayout
        {
            this._Str_5788[k.name] = k;
            return k;
        }

        public function _Str_22665(k:String):ISkinLayout
        {
            return this._Str_5788[k];
        }

        public function _Str_22572(k:ISkinLayout):ISkinLayout
        {
var _local_2:ASObject  = null;            var _local_2:ASObject = null;
            var _local_3:UInt = 0;
            k = this._Str_4990[k.name];
            if (k != null)
            {
                final _iter_ = this._Str_5580; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
                {
_local_2 = _tmp_;
                    _local_3 = ASCompat.asUint(_local_2 );
                    if (this._Str_5580[_local_3] == k)
                    {
                        this._Str_19884(_local_3);
                    }
                }
                this._Str_5788.remove(k.name);
            }
            return k;
        }

        public function _Str_21576(k:ISkinTemplate):ISkinTemplate
        {
            this._Str_4990[k.name] = k;
            return k;
        }

        public function _Str_23196(k:String):ISkinTemplate
        {
            return this._Str_4990[k];
        }

        public function _Str_22597(k:ISkinTemplate):ISkinTemplate
        {
var _local_2:ASObject  = null;            var _local_2:ASObject = null;
            var _local_3:UInt = 0;
            k = this._Str_4990[k.name];
            if (k != null)
            {
                final _iter_ = this._Str_5217; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
                {
_local_2 = _tmp_;
                    _local_3 = ASCompat.asUint(_local_2 );
                    if (this._Str_5217[_local_3] == k)
                    {
                        this._Str_21934(_local_3);
                    }
                }
                this._Str_4990.remove(k.name);
            }
            return k;
        }

	static final ___init = {

        {
            _Str_3766[TextStyle.TOP_LEFT] = {
                "x":-1,
                "y":-1
            }
;            _Str_3766[TextStyle.TOP] = {
                "x":0,
                "y":-1
            }
;            _Str_3766[TextStyle.TOP_RIGHT] = {
                "x":1,
                "y":-1
            }
;            _Str_3766[TextStyle.LEFT] = {
                "x":-1,
                "y":0
            }
;            _Str_3766[TextStyle.RIGHT] = {
                "x":1,
                "y":0
            }
;            _Str_3766[TextStyle.BOTTOM_LEFT] = {
                "x":-1,
                "y":1
            }
;            _Str_3766[TextStyle.BOTTOM] = {
                "x":0,
                "y":1
            }
;            _Str_3766[TextStyle.BOTTOM_RIGHT] = {
                "x":1,
                "y":1
            }
;        }

	null;
	};
    }

