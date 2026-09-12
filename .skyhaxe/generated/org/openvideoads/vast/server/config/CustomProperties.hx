package org.openvideoads.vast.server.config
;
    import org.openvideoads.base.Debuggable;

     class CustomProperties extends Debuggable 
    {
        var _Str_7517:ASDictionary<ASAny,ASAny>;

        public function new(k:ASObject=null)
        {
            this._Str_7517 = new ASDictionary<ASAny,ASAny>();
            super();
            this._Str_17005(k);
        }

        public function _Str_17005(k:ASObject)
        {
var _local_2:String  = null;            var _local_2:String = null;
            if (k != null)
            {
                if (checkNullIteratee(k)) for (_tmp_ in k.___keys())
                {
_local_2 = _tmp_;
                    this._Str_7517[_local_2] = ASCompat.getDynamicProperty(k, _local_2);
                }
            }
        }

        function _Str_23661(k:Array<ASAny>):String
        {
            var _local_2= "";
            var _local_3 = 0;
            while (_local_3 < k.length)
            {
                if (_local_2.length > 0)
                {
                    _local_2 = (_local_2 + "&");
                }
                _local_2 = (_local_2 + k[_local_3]);
                _local_3++;
            }
            return _local_2;
        }

        public function completeTemplate(k:String, _arg_2:Bool=false):String
        {
var _local_5:String  = null;            var _local_3:compat.RegExp = null;
            var _local_4:String = null;
            var _local_5:String = null;
            var _local_6:String = null;
            final _iter_ = this._Str_7517; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
            {
_local_5 = _tmp_;
                _local_6 = (("__" + _local_5) + "__");
                if (k.indexOf(_local_6) > -1)
                {
                    _local_3 = new compat.RegExp(_local_6, "g");
                    if (Std.is(this._Str_7517[_local_5] , Array))
                    {
                        k = _local_3.replace(k, this._Str_23661(this._Str_7517[_local_5]));
                    }
                    else
                    {
                        k = _local_3.replace(k, this._Str_7517[_local_5]);
                    }
                }
                else
                {
                    if (_arg_2)
                    {
                        k = (k + ((("&" + _local_5) + "=") + this._Str_7517[_local_5]));
                    }
                }
            }
            return k;
        }
    }

