package com.sulake.habbo.avatar.figuredata
;
    import com.sulake.habbo.avatar.IAvatarImageListener;
    import com.sulake.habbo.avatar.HabboAvatarEditor;

     class FigureData implements IAvatarImageListener 
    {
        public static inline final M= "M";
        public static inline final F= "F";
        public static inline final U= "U";
        public static inline final H= "h";
        public static inline final STD= "std";
        public static inline final _Str_2028= "0";
        public static inline final FACE= "hd";
        public static inline final HR= "hr";
        public static inline final HA= "ha";
        public static inline final HE= "he";
        public static inline final EA= "ea";
        public static inline final FA= "fa";
        public static inline final CC= "cc";
        public static inline final CH= "ch";
        public static inline final CHEST_ACCESSORIES= "ca";
        public static inline final CHEST_PRINTS= "cp";
        public static inline final MISC= "mc";
        public static inline final PET= "pt";
        public static inline final LG= "lg";
        public static inline final SH= "sh";
        public static inline final WA= "wa";

        var _avatarEditor:HabboAvatarEditor;
        var _view:FigureDataView;
        var _data:ASDictionary<ASAny,ASAny>;
        var _colors:ASDictionary<ASAny,ASAny>;
        var _gender:String = "M";
        var _isDisposed:Bool = false;
        var _direction:Int = 4;
        var _avatarEffectType:Int = -1;

        public function new(k:HabboAvatarEditor)
        {
            this._direction = FigureDataView._Str_9887;
            this._avatarEditor = k;
            this._view = new FigureDataView(this);
        }

        public function loadAvatarData(k:String, _arg_2:String)
        {
            this._data = new ASDictionary<ASAny,ASAny>();
            this._colors = new ASDictionary<ASAny,ASAny>();
            this._gender = _arg_2;
            this._Str_958(k);
            this.updateView();
        }

        public function dispose()
        {
            this._avatarEditor = null;
            this._view = null;
            this._data = null;
            this._colors = null;
            this._isDisposed = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._isDisposed;
        }

        function _Str_958(k:String)
        {
            var _local_2:String = null;
            var _local_3:Array<ASAny> = null;
            var _local_4:String = null;
            var _local_5 = 0;
            var _local_6:Array<ASAny> = null;
            var _local_7 = 0;
            if (k == null)
            {
                return;
            }
            final _iter_ = k.split("."); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
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
                        _local_6.push(_local_3[_local_7]);
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

        public function getPartSetId(k:String):Int
        {
            if (this._data[k] != null)
            {
                return ASCompat.toInt(this._data[k]);
            }
            return -1;
        }

        public function getColourIds(k:String):Array<ASAny>
        {
            if (this._colors[k] != null)
            {
                return this._colors[k];
            }
            return [this._avatarEditor._Str_24919(k)];
        }

        public function getFigureString():String
        {
var _local_3:String  = null;            var _local_3:String = null;
            var _local_4 = 0;
            var _local_5:String = null;
            var _local_6:Array<ASAny> = null;
            var _local_7:String = null;
            var _local_8 = 0;
            var k= "";
            var _local_2:Array<ASAny> = [];
            final _iter_ = this._data; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
            {
_local_3 = _tmp_;
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
                case FACE
                   | HR
                   | HA
                   | HE
                   | EA
                   | FA
                   | CH
                   | CC
                   | CHEST_ACCESSORIES
                   | CHEST_PRINTS
                   | MISC
                   | PET
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
                    
            }
            if (_arg_3)
            {
                this.updateView();
            }
        }

        public function savePartSetColourId(k:String, _arg_2:Array<ASAny>, _arg_3:Bool=true)
        {
            switch (k)
            {
                case FACE
                   | HR
                   | HA
                   | HE
                   | EA
                   | FA
                   | CH
                   | CC
                   | CHEST_ACCESSORIES
                   | CHEST_PRINTS
                   | MISC
                   | PET
                   | LG
                   | SH
                   | WA:
                    this._colors[k] = _arg_2;
                    
            }
            if (_arg_3)
            {
                this.updateView();
            }
        }

        public function getFigureStringWithFace(k:Int):String
        {
            var _local_5:String = null;
            var _local_6 = 0;
            var _local_7 = 0;
            var _local_8:Array<ASAny> = null;
            var _local_9:String = null;
            var _local_10 = 0;
            var _local_2:Array<ASAny> = [];
            _local_2.push(FACE);
            var _local_3= "";
            var _local_4:Array<ASAny> = [];
            if (checkNullIteratee(_local_2)) for (_tmp_ in _local_2)
            {
_local_5  = _tmp_;
                if (this._colors[_local_5] != null)
                {
                    _local_7 = ASCompat.toInt(this._data[_local_5]);
                    _local_8 = ASCompat.dynamicAs(this._colors[_local_5] , Array);
                    if (_local_5 == FACE)
                    {
                        _local_7 = k;
                    }
                    _local_9 = ((_local_5 + "-") + Std.string(_local_7));
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

        public function updateView()
        {
            this._view.update(this.getFigureString(), this._avatarEffectType, this._direction);
        }

        public var view(get,never):FigureDataView;
public function  get_view():FigureDataView
        {
            return this._view;
        }

        public var gender(get,never):String;
public function  get_gender():String
        {
            return this._gender;
        }

        public function avatarImageReady(k:String)
        {
            this.updateView();
        }

        
        public var avatarEffectType(get,set):Int;
public function  set_avatarEffectType(k:Int):Int        {
            return this._avatarEffectType = k;
        }
public function  get_avatarEffectType():Int
        {
            return this._avatarEffectType;
        }

        public var avatarEditor(get,never):HabboAvatarEditor;
public function  get_avatarEditor():HabboAvatarEditor
        {
            return this._avatarEditor;
        }

        
        public var direction(get,set):Int;
public function  get_direction():Int
        {
            return this._direction;
        }
public function  set_direction(k:Int):Int        {
            this._direction = k;
            this.updateView();
return k;
        }
    }

