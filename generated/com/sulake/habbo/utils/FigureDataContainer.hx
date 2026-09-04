package com.sulake.habbo.utils
;

     class FigureDataContainer 
    {
        public static inline final M= "M";
        public static inline final F= "F";
        public static inline final U= "U";
        public static inline final H= "h";
        public static inline final STD= "std";
        public static inline final _Str_2028= "0";
        public static inline final HD= "hd";
        public static inline final HR= "hr";
        public static inline final HA= "ha";
        public static inline final HE= "he";
        public static inline final EA= "ea";
        public static inline final FA= "fa";
        public static inline final CC= "cc";
        public static inline final CH= "ch";
        public static inline final CA= "ca";
        public static inline final CP= "cp";
        public static inline final MC= "mc";
        public static inline final PT= "pt";
        public static inline final LG= "lg";
        public static inline final SH= "sh";
        public static inline final WA= "wa";
        static final _Str_1329:Array<ASAny> = [28, 29, 30, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 68];

        var _data:ASDictionary<ASAny,ASAny>;
        var _colors:ASDictionary<ASAny,ASAny>;
        var _gender:String = "M";
        var _isDisposed:Bool = false;
        var _avatarEffectType:Int = -1;


        public function _Str_2153(k:String, _arg_2:String)
        {
            this._data = new ASDictionary<ASAny,ASAny>();
            this._colors = new ASDictionary<ASAny,ASAny>();
            this._gender = _arg_2;
            this._Str_958(k);
        }

        public function dispose()
        {
            this._data = null;
            this._colors = null;
            this._isDisposed = true;
        }

        public var disposed(get,never):Bool;
function  get_disposed():Bool
        {
            return this._isDisposed;
        }

        function _Str_958(k:String)
        {
            var _local_2:String;
            var _local_3:Array<ASAny>;
            var _local_4:String;
            var _local_5:Int;
            var _local_6:Array<ASAny>;
            var _local_7:Int;
            if (k == null)
            {
                return;
            }
            for (_tmp_ in k.split("."))
            {
_local_2  = _tmp_;
                _local_3 = (cast _local_2.split("-"));
                if (_local_3.length > 0)
                {
                    _local_4 = ASCompat.toString(_local_3[0]);
                    _local_5 = ASCompat.parseInt(_local_3[1]);
                    _local_6 = new Array<ASAny>();
                    _local_7 = 2;
                    while (_local_7 < _local_3.length)
                    {
                        _local_6.push(ASCompat.parseInt(_local_3[_local_7]));
                        _local_7++;
                    }
                    if (_local_6.length == 0)
                    {
                        _local_6.push(0);
                    }
                    this._Str_1876(_local_4, _local_5, false);
                    this.savePartSetColourId(_local_4, _local_6, false);
                }
            }
        }

        public function _Str_2131(k:String):Bool
        {
            return !(this._data[k] == null);
        }

        public function getPartSetId(k:String):Int
        {
            if (this._data[k] != null)
            {
                return this._data[k];
            }
            return -1;
        }

        public function getColourIds(k:String):Array<ASAny>
        {
            if (this._colors[k] != null)
            {
                return this._colors[k];
            }
            return [];
        }

        public function getFigureString():String
        {
            var _local_3:String;
            var _local_4:Int;
            var _local_5:String;
            var _local_6:Array<ASAny>;
            var _local_7:String;
            var _local_8:Int;
            var k= "";
            var _local_2:Array<ASAny> = [];
            for (_tmp_ in this._data.keys())
            {
var _local_3:String  = _tmp_;
                if (this._data[_local_3] != null)
                {
                    _local_5 = this._data[_local_3];
                    _local_6 = ASCompat.dynamicAs(this._colors[_local_3] , Array);
                    _local_7 = ((_local_3 + "-") + _local_5);
                    if (_local_6 != null)
                    {
                        _local_8 = 0;
                        while (_local_8 < _local_6.length)
                        {
                            _local_7 = (_local_7 + ("-" + _local_6[_local_8]));
                            _local_8++;
                        }
                    }
                    _local_2.push(_local_7);
                }
            }
            _local_4 = 0;
            while (_local_4 < _local_2.length)
            {
                k = (k + _local_2[_local_4]);
                if (_local_4 < (_local_2.length - 1))
                {
                    k = (k + ".");
                }
                _local_4++;
            }
            return k;
        }

        public function _Str_2088(k:String, _arg_2:Int, _arg_3:Array<ASAny>, _arg_4:Bool=false)
        {
            this._Str_1876(k, _arg_2, _arg_4);
            this.savePartSetColourId(k, _arg_3, _arg_4);
        }

        function _Str_1876(k:String, _arg_2:Int, _arg_3:Bool=true)
        {
            switch (k)
            {
                case HD
                   | HR
                   | HA
                   | HE
                   | EA
                   | FA
                   | CH
                   | CC
                   | CA
                   | CP
                   | MC
                   | PT
                   | LG
                   | SH
                   | WA:
                    if (_arg_2 >= 0)
                    {
                        this._data[k] = _arg_2;
                    }
                    else
                    {
                        this._data.remove(k);
                    }
                    return;
                default:
                    Logger.log(((("[FigureData] Unknown partset: " + k) + ", can not store id: ") + _arg_2));
            }
        }

        public function savePartSetColourId(k:String, _arg_2:Array<ASAny>, _arg_3:Bool=true)
        {
            switch (k)
            {
                case HD
                   | HR
                   | HA
                   | HE
                   | EA
                   | FA
                   | CH
                   | CC
                   | CA
                   | CP
                   | MC
                   | PT
                   | LG
                   | SH
                   | WA:
                    this._colors[k] = _arg_2;
                    return;
                default:
                    Logger.log((("[FigureData] Unknown partset: " + k) + ", can not store color-ids"));
            }
        }

        public function getFigureStringWithFace(k:Int):String
        {
            var _local_5:String;
            var _local_6:Int;
            var _local_7:Int;
            var _local_8:Array<ASAny>;
            var _local_9:String;
            var _local_10:Int;
            var _local_2:Array<ASAny> = [];
            _local_2.push(HD);
            var _local_3= "";
            var _local_4:Array<ASAny> = [];
            for (_tmp_ in _local_2)
            {
_local_5  = _tmp_;
                if (this._colors[_local_5] != null)
                {
                    _local_7 = this._data[_local_5];
                    _local_8 = ASCompat.dynamicAs(this._colors[_local_5] , Array);
                    if (_local_5 == HD)
                    {
                        _local_7 = k;
                    }
                    _local_9 = ((_local_5 + "-") + _local_7);
                    if (_local_7 >= 0)
                    {
                        _local_10 = 0;
                        while (_local_10 < _local_8.length)
                        {
                            _local_9 = (_local_9 + ("-" + _local_8[_local_10]));
                            _local_10++;
                        }
                    }
                    _local_4.push(_local_9);
                }
            }
            _local_6 = 0;
            while (_local_6 < _local_4.length)
            {
                _local_3 = (_local_3 + _local_4[_local_6]);
                if (_local_6 < (_local_4.length - 1))
                {
                    _local_3 = (_local_3 + ".");
                }
                _local_6++;
            }
            return _local_3;
        }

        public var gender(get,never):String;
function  get_gender():String
        {
            return this._gender;
        }
public function new(){}
    }

