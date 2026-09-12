package com.sulake.habbo.sound
;
    import com.sulake.core.runtime.IUpdateReceiver;
    import flash.media.Sound;
    import flash.utils.ByteArray;
    import flash.media.SoundTransform;

     class HabboSoundWithPitch extends HabboSoundBase implements IUpdateReceiver 
    {
        static inline final _Str_19531:UInt = 50;
        static inline final _Str_19780:UInt = 175;

        var _pitch:Float = Math.NaN;
        var _dynamicSound:Sound;
        var _loadedSamples:com.sulake.core.utils.ByteArray;
        var _numSamples:Int = 0;
        var _updateMs:UInt = 0;
        var _startMs:UInt = 0;
        var _fadeComplete:Bool = false;

        public function new(k:Sound, _arg_2:Float=1)
        {
            super(k);
            this._pitch = _arg_2;
            this._dynamicSound = new Sound();
            this._Str_23148();
            this._Str_19664(this._pitch);
        }

        override public function dispose()
        {
            super.dispose();
            this._dynamicSound = null;
            this._loadedSamples.clear();
            this._loadedSamples = null;
        }

        override public function play(k:Float=0):Bool
        {
            this.stop();
            this._startMs = this._updateMs;
            this._fadeComplete = false;
            _Str_22198(false);
            _Str_20695(this._dynamicSound.play(0, 0, new SoundTransform(0)));
            return true;
        }

        override public function stop():Bool
        {
            if (_Str_15495() != null)
            {
                _Str_15495().stop();
            }
            return true;
        }

        public function update(k:UInt)
        {
            this._updateMs = (this._updateMs + k);
            var _local_2= (this._updateMs - this._startMs);
            if (((this._startMs > 0) && (_local_2 < HabboSoundWithPitch._Str_19531)))
            {
                _Str_7399(0);
            }
            else
            {
                if ((((this._startMs > 0) && (_local_2 >= HabboSoundWithPitch._Str_19531)) && (_local_2 < HabboSoundWithPitch._Str_19780)))
                {
                    _Str_7399((volume * (_local_2 / HabboSoundWithPitch._Str_19780)));
                }
                else
                {
                    if (!this._fadeComplete)
                    {
                        _Str_7399(volume);
                        this._fadeComplete = true;
                    }
                }
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._loadedSamples == null;
        }

        public function _Str_19664(k:Float)
        {
            var _local_5 = Math.NaN;
            this._pitch = k;
            var _local_2= new com.sulake.core.utils.ByteArray();
            var _local_3:UInt = Std.int(((this._loadedSamples.length / 4) * this._pitch));
            var _local_4:Float = 0;
            var _local_6 = 0;
            while ((((_local_6 : UInt) < _local_3) && (((Std.int(_local_4) * 4) : UInt) < this._loadedSamples.length)))
            {
                this._loadedSamples.position = (Std.int(_local_4) * 4);
                _local_5 = this._loadedSamples.readFloat();
                _local_2.writeFloat(_local_5);
                _local_2.writeFloat(_local_5);
                _local_4 = (_local_4 + this._pitch);
                _local_6++;
            }
            _local_2.position = 0;
            this._dynamicSound.loadPCMFromByteArray(_local_2, Std.int(_local_2.length / 8), "float");
        }

        function _Str_23148()
        {
            var _local_2 = 0;
            var _local_3 = Math.NaN;
            var k= new com.sulake.core.utils.ByteArray();
ASCompat.extractSound(            _soundObject, k, Std.int((_soundObject.length * 44.1)), 0);
            this._loadedSamples = new com.sulake.core.utils.ByteArray();
            this._numSamples = Std.int(k.length / 8);
            k.position = 0;
            _local_2 = 0;
            while (_local_2 < this._numSamples)
            {
                _local_3 = k.readFloat();
                k.readFloat();
                this._loadedSamples.writeFloat(_local_3);
                _local_2++;
            }
        }
    }

