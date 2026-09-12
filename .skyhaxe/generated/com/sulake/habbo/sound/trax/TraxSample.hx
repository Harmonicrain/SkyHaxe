package com.sulake.habbo.sound.trax
;
    import com.sulake.core.runtime.IDisposable;
    import flash.utils.ByteArray;

     class TraxSample implements IDisposable 
    {
        public static inline final SAMPLE_FREQUENCY_44KHZ= "sample_44khz";
        public static inline final SAMPLE_FREQUENCY_22KHZ= "sample_22khz";
        public static inline final SAMPLE_FREQUENCY_11KHZ= "sample_11khz";
        public static inline final SAMPLE_SCALE_16BIT= "sample_16bit";
        public static inline final SAMPLE_SCALE_8BIT= "sample_8bit";
        public static final _Str_11575:Float = (1 / 0x8000);//3.0517578125E-5
        static inline final _Str_14308= 32;
        static inline final MASK_8BIT= 0xFF;
        static inline final MASK_16BIT= 0xFFFF;
        static inline final OFFSET_8BIT= 127;
        static inline final OFFSET_16BIT= 32767;

        var _disposed:Bool = false;
        var _sampleData:Vector<Int> = null;
        var _id:Int = 0;
        var _samplesPerValue:Int = 2;
        var _sampleRepeats:Int = 1;
        var _usageList:Array<ASAny>;
        var _usageTimeStamp:UInt = 0;

        public function new(k:com.sulake.core.utils.ByteArray, _arg_2:Int, _arg_3:String="sample_44khz", _arg_4:String="sample_16bit")
        {
            var _local_12 = Math.NaN;
            var _local_13 = 0;
            var _local_14 = 0;
            var _local_15 = Math.NaN;
            var _local_16 = Math.NaN;
            this._usageList = [];
            this._id = _arg_2;
            var _local_5:ASAny = 65536;
            switch (_arg_3)
            {
                case SAMPLE_FREQUENCY_22KHZ:
                    this._sampleRepeats = 2;
                    
                case SAMPLE_FREQUENCY_11KHZ:
                    this._sampleRepeats = 4;
                    
                default:
                    this._sampleRepeats = 1;
            }
            switch (_arg_4)
            {
                case SAMPLE_SCALE_8BIT:
                    this._samplesPerValue = 4;
                    _local_5 = 0x0100;
                    
                default:
                    this._samplesPerValue = 2;
                    _local_5 = 65536;
            }
            var _local_6= (this._samplesPerValue * this._sampleRepeats);
            var _local_7= Std.int(k.length / 8);
            _local_7 = (Std.int((_local_7 / _local_6)) * _local_6);
            this._sampleData = new Vector<Int>(Std.int(_local_7 / _local_6), true);
            var _local_8= (1 / (ASCompat.toNumber(_local_5) / 2));
            k.position = 0;
            var _local_9 = 0;
            var _local_10= Std.int(_local_7 / this._sampleRepeats);
            var _local_11 = 0;
            while (_local_11 < _local_10)
            {
                _local_12 = k.readFloat();
                k.readFloat();
                _local_13 = 2;
                while (_local_13 <= this._sampleRepeats)
                {
                    _local_15 = k.readFloat();
                    k.readFloat();
                    _local_16 = _local_13;
                    _local_12 = (((_local_12 * (_local_16 - 1)) / _local_16) + (_local_15 / _local_16));
                    _local_13++;
                }
                if (_local_11 >= ((_local_10 - 1) - _Str_14308))
                {
                    _local_12 = (_local_12 * (((_local_10 - _local_11) - 1) / _Str_14308));
                }
                _local_14 = Std.int((_local_12 + 1) / _local_8);
                if (_local_14 < 0)
                {
                    _local_14 = 0;
                }
                else
                {
                    if (_local_14 >= _local_5)
                    {
                        _local_14 = ASCompat.toInt(ASCompat.toNumber(_local_5) - 1);
                    }
                }
                _local_9 = ASCompat.toInt(_local_9 * ASCompat.toNumber(_local_5));
                _local_9 = (_local_9 + _local_14);
                if ((_local_11 % this._samplesPerValue) == (this._samplesPerValue - 1))
                {
                    this._sampleData[Std.int((_local_11 / this._samplesPerValue))] = _local_9;
                    _local_9 = 0;
                }
                _local_11++;
            }
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
        }

        public var length(get,never):UInt;
public function  get_length():UInt
        {
            return (this._sampleData.length * this._samplesPerValue) * this._sampleRepeats;
        }

        public var usageCount(get,never):Int;
public function  get_usageCount():Int
        {
            return this._usageList.length;
        }

        public var usageTimeStamp(get,never):Int;
public function  get_usageTimeStamp():Int
        {
            return ASCompat.toInt(this._usageTimeStamp);
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                this._sampleData = null;
                this._usageList = null;
            }
        }

        public function setSample(k:Vector<Int>, _arg_2:Int, _arg_3:Int, _arg_4:Int):Int
        {
var _local_13:ASAny  = null, _local_14:ASAny  = null;            var _local_8 = 0;
            var _local_9 = 0;
            var _local_10 = 0;
            var _local_11:ASAny = null;
            var _local_12:ASAny = null;
            if (((k == null) || (this._sampleData == null)))
            {
                return _arg_4;
            }
            var _local_5= (this._samplesPerValue * this._sampleRepeats);
            _arg_4 = Std.int(_arg_4 / _local_5);
            if (_arg_2 < 0)
            {
                _arg_3 = (_arg_3 + _arg_2);
                _arg_2 = 0;
            }
            if (_arg_3 > (k.length - _arg_2))
            {
                _arg_3 = (k.length - _arg_2);
            }
            var _local_6= Std.int(_arg_3 / _local_5);
            var _local_7 = 0;
            if (_local_6 > (this._sampleData.length - _arg_4))
            {
                _local_7 = ((_local_6 - (this._sampleData.length - _arg_4)) * _local_5);
                _local_6 = (this._sampleData.length - _arg_4);
                if (_local_7 > (k.length - _arg_2))
                {
                    _local_7 = (k.length - _arg_2);
                }
            }
            if (this._sampleRepeats == 1)
            {
                if (this._samplesPerValue == 2)
                {
                    while (_local_6-- > 0)
                    {
                        _local_8 = this._sampleData[_arg_4++];
                        _local_11 = _arg_2++;
                        k[ASCompat.toInt(_local_11)] = (((_local_8 >> 16) & MASK_16BIT) - OFFSET_16BIT);
                        _local_12 = _arg_2++;
                        k[ASCompat.toInt(_local_12)] = ((_local_8 & MASK_16BIT) - OFFSET_16BIT);
                    }
                }
                else
                {
                    if (this._samplesPerValue == 4)
                    {
                        while (_local_6-- > 0)
                        {
                            _local_8 = this._sampleData[_arg_4++];
                            _local_11 = _arg_2++;
                            k[ASCompat.toInt(_local_11)] = ((((_local_8 >> 24) & MASK_8BIT) - OFFSET_8BIT) << 8);
                            _local_12 = _arg_2++;
                            k[ASCompat.toInt(_local_12)] = ((((_local_8 >> 16) & MASK_8BIT) - OFFSET_8BIT) << 8);
_local_13= _arg_2++;
                            k[ASCompat.toInt(_local_13)] = ((((_local_8 >> 8) & MASK_8BIT) - OFFSET_8BIT) << 8);
_local_14= _arg_2++;
                            k[ASCompat.toInt(_local_14)] = (((_local_8 & MASK_8BIT) - OFFSET_8BIT) << 8);
                        }
                    }
                }
            }
            else
            {
                if (this._sampleRepeats >= 2)
                {
                    _local_9 = 0;
                    _local_10 = 0;
                    if (this._samplesPerValue == 2)
                    {
                        while (_local_6-- > 0)
                        {
                            _local_8 = this._sampleData[_arg_4++];
                            _local_10 = (((_local_8 >> 16) & MASK_16BIT) - OFFSET_16BIT);
                            _local_9 = this._sampleRepeats;
                            while (_local_9 > 0)
                            {
                                _local_11 = _arg_2++;
                                k[ASCompat.toInt(_local_11)] = _local_10;
                                _local_9--;
                            }
                            _local_10 = ((_local_8 & MASK_16BIT) - OFFSET_16BIT);
                            _local_9 = this._sampleRepeats;
                            while (_local_9 > 0)
                            {
                                _local_11 = _arg_2++;
                                k[ASCompat.toInt(_local_11)] = _local_10;
                                _local_9--;
                            }
                        }
                    }
                    else
                    {
                        if (this._samplesPerValue == 4)
                        {
                            while (_local_6-- > 0)
                            {
                                _local_8 = this._sampleData[_arg_4++];
                                _local_10 = ((((_local_8 >> 24) & MASK_8BIT) - OFFSET_8BIT) << 8);
                                _local_9 = this._sampleRepeats;
                                while (_local_9 > 0)
                                {
                                    _local_11 = _arg_2++;
                                    k[ASCompat.toInt(_local_11)] = _local_10;
                                    _local_9--;
                                }
                                _local_10 = ((((_local_8 >> 16) & MASK_8BIT) - OFFSET_8BIT) << 8);
                                _local_9 = this._sampleRepeats;
                                while (_local_9 > 0)
                                {
                                    _local_11 = _arg_2++;
                                    k[ASCompat.toInt(_local_11)] = _local_10;
                                    _local_9--;
                                }
                                _local_10 = ((((_local_8 >> 8) & MASK_8BIT) - OFFSET_8BIT) << 8);
                                _local_9 = this._sampleRepeats;
                                while (_local_9 > 0)
                                {
                                    _local_11 = _arg_2++;
                                    k[ASCompat.toInt(_local_11)] = _local_10;
                                    _local_9--;
                                }
                                _local_10 = (((_local_8 & MASK_8BIT) - OFFSET_8BIT) << 8);
                                _local_9 = this._sampleRepeats;
                                while (_local_9 > 0)
                                {
                                    _local_11 = _arg_2++;
                                    k[ASCompat.toInt(_local_11)] = _local_10;
                                    _local_9--;
                                }
                            }
                        }
                    }
                }
            }
            while (_local_7-- > 0)
            {
                _local_11 = _arg_2++;
                k[ASCompat.toInt(_local_11)] = 0;
            }
            return _arg_4 * _local_5;
        }

        public function addSample(k:Vector<Int>, _arg_2:Int, _arg_3:Int, _arg_4:Int):Int
        {
var _local_13:ASAny  = null;            var _local_7 = 0;
            var _local_8 = 0;
            var _local_9 = 0;
            var _local_10:ASAny = null;
            var _local_11:ASAny = null;
            var _local_12:ASAny = null;
            if (((k == null) || (this._sampleData == null)))
            {
                return _arg_4;
            }
            var _local_5= (this._samplesPerValue * this._sampleRepeats);
            _arg_4 = Std.int(_arg_4 / _local_5);
            if (_arg_2 < 0)
            {
                _arg_3 = (_arg_3 + _arg_2);
                _arg_2 = 0;
            }
            if (_arg_3 > (k.length - _arg_2))
            {
                _arg_3 = (k.length - _arg_2);
            }
            var _local_6= Std.int(_arg_3 / _local_5);
            if (_local_6 > (this._sampleData.length - _arg_4))
            {
                _local_6 = (this._sampleData.length - _arg_4);
            }
            if (this._sampleRepeats == 1)
            {
                if (this._samplesPerValue == 2)
                {
                    while (_local_6-- > 0)
                    {
                        _local_7 = this._sampleData[_arg_4++];
                        _local_10 = _arg_2++;
                        k[ASCompat.toInt(_local_10)] = (k[ASCompat.toInt(_local_10)] + (((_local_7 >> 16) & MASK_16BIT) - OFFSET_16BIT));
                        _local_11 = _arg_2++;
                        k[ASCompat.toInt(_local_11)] = (k[ASCompat.toInt(_local_11)] + ((_local_7 & MASK_16BIT) - OFFSET_16BIT));
                    }
                }
                else
                {
                    if (this._samplesPerValue == 4)
                    {
                        while (_local_6-- > 0)
                        {
                            _local_7 = this._sampleData[_arg_4++];
                            _local_10 = _arg_2++;
                            k[ASCompat.toInt(_local_10)] = (k[ASCompat.toInt(_local_10)] + ((((_local_7 >> 24) & MASK_8BIT) - OFFSET_8BIT) << 8));
                            _local_11 = _arg_2++;
                            k[ASCompat.toInt(_local_11)] = (k[ASCompat.toInt(_local_11)] + ((((_local_7 >> 16) & MASK_8BIT) - OFFSET_8BIT) << 8));
                            _local_12 = _arg_2++;
                            k[ASCompat.toInt(_local_12)] = (k[ASCompat.toInt(_local_12)] + ((((_local_7 >> 8) & MASK_8BIT) - OFFSET_8BIT) << 8));
_local_13= _arg_2++;
                            k[ASCompat.toInt(_local_13)] = (k[ASCompat.toInt(_local_13)] + (((_local_7 & MASK_8BIT) - OFFSET_8BIT) << 8));
                        }
                    }
                }
            }
            else
            {
                if (this._sampleRepeats >= 2)
                {
                    _local_8 = 0;
                    _local_9 = 0;
                    if (this._samplesPerValue == 2)
                    {
                        while (_local_6-- > 0)
                        {
                            _local_7 = this._sampleData[_arg_4++];
                            _local_9 = (((_local_7 >> 16) & MASK_16BIT) - OFFSET_16BIT);
                            _local_8 = this._sampleRepeats;
                            while (_local_8 > 0)
                            {
                                _local_10 = _arg_2++;
                                k[ASCompat.toInt(_local_10)] = (k[ASCompat.toInt(_local_10)] + _local_9);
                                _local_8--;
                            }
                            _local_9 = ((_local_7 & MASK_16BIT) - OFFSET_16BIT);
                            _local_8 = this._sampleRepeats;
                            while (_local_8 > 0)
                            {
                                _local_10 = _arg_2++;
                                k[ASCompat.toInt(_local_10)] = (k[ASCompat.toInt(_local_10)] + _local_9);
                                _local_8--;
                            }
                        }
                    }
                    else
                    {
                        if (this._samplesPerValue == 4)
                        {
                            while (_local_6-- > 0)
                            {
                                _local_7 = this._sampleData[_arg_4++];
                                _local_9 = ((((_local_7 >> 24) & MASK_8BIT) - OFFSET_8BIT) << 8);
                                _local_8 = this._sampleRepeats;
                                while (_local_8 > 0)
                                {
                                    _local_10 = _arg_2++;
                                    k[ASCompat.toInt(_local_10)] = (k[ASCompat.toInt(_local_10)] + _local_9);
                                    _local_8--;
                                }
                                _local_9 = ((((_local_7 >> 16) & MASK_8BIT) - OFFSET_8BIT) << 8);
                                _local_8 = this._sampleRepeats;
                                while (_local_8 > 0)
                                {
                                    _local_10 = _arg_2++;
                                    k[ASCompat.toInt(_local_10)] = (k[ASCompat.toInt(_local_10)] + _local_9);
                                    _local_8--;
                                }
                                _local_9 = ((((_local_7 >> 8) & MASK_8BIT) - OFFSET_8BIT) << 8);
                                _local_8 = this._sampleRepeats;
                                while (_local_8 > 0)
                                {
                                    _local_10 = _arg_2++;
                                    k[ASCompat.toInt(_local_10)] = (k[ASCompat.toInt(_local_10)] + _local_9);
                                    _local_8--;
                                }
                                _local_9 = (((_local_7 & MASK_8BIT) - OFFSET_8BIT) << 8);
                                _local_8 = this._sampleRepeats;
                                while (_local_8 > 0)
                                {
                                    _local_10 = _arg_2++;
                                    k[ASCompat.toInt(_local_10)] = (k[ASCompat.toInt(_local_10)] + _local_9);
                                    _local_8--;
                                }
                            }
                        }
                    }
                }
            }
            return _arg_4 * _local_5;
        }

        public function setUsageFromSong(k:Int, _arg_2:UInt)
        {
            if (this._usageList == null)
            {
                return;
            }
            if (this._usageList.indexOf(k) == -1)
            {
                this._usageList.push(k);
            }
            this._usageTimeStamp = _arg_2;
        }

        public function isUsedFromSong(k:Int):Bool
        {
            if (this._usageList == null)
            {
                return false;
            }
            return !(this._usageList.indexOf(k) == -1);
        }
    }

