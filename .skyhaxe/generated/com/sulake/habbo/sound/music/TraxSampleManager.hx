package com.sulake.habbo.sound.music
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.sound.HabboSoundManagerFlash10;
    import com.sulake.core.utils.Map;
    import flash.utils.ByteArray;
    import flash.net.URLRequest;
    import flash.media.Sound;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import com.sulake.habbo.sound.events.TraxSongLoadEvent;
    import com.sulake.habbo.sound.trax.TraxSample;

     class TraxSampleManager implements IDisposable 
    {
        static inline final _Str_17010= 60;
        static inline final _Str_18145= 25165823;
        static inline final _Str_17865= 0xFFFFFF;

        var _soundManager:HabboSoundManagerFlash10;
        var _loadingSamples:Map;
        var _loadedSamples:Array<ASAny>;
        var _traxSamples:Map;
        var _byteBuffer:com.sulake.core.utils.ByteArray;
        var _loadErrorCallback:ASFunction;
        var _purgeSamplesEnabled:Bool = false;
        var _disposed:Bool = false;

        public function new(k:HabboSoundManagerFlash10, _arg_2:ASFunction)
        {
            this._loadingSamples = new Map();
            this._loadedSamples = [];
            this._traxSamples = new Map();
            this._byteBuffer = new com.sulake.core.utils.ByteArray();
            this._loadErrorCallback = _arg_2;
            this._soundManager = k;
            if (this._soundManager.getBoolean("trax.player.sample.memory.purge.enabled"))
            {
                this._purgeSamplesEnabled = true;
            }
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
                this._byteBuffer = null;
                this._loadedSamples = null;
                if (this._traxSamples != null)
                {
                    this._traxSamples.dispose();
                    this._traxSamples = null;
                }
                if (this._loadingSamples != null)
                {
                    this._loadingSamples.dispose();
                    this._loadingSamples = null;
                }
                this._soundManager = null;
                this._disposed = true;
            }
        }

        public var traxSamples(get,never):Map;
public function  get_traxSamples():Map
        {
            return this._traxSamples;
        }

        public function loadSample(k:Int)
        {
            var _local_2= this._soundManager.getProperty("flash.dynamic.download.url");
            _local_2 = (_local_2 + this._soundManager.getProperty("flash.dynamic.download.samples.template"));
            _local_2 = new compat.RegExp("%typeid%").replace(_local_2, Std.string(k));
            var _local_3= new URLRequest(_local_2);
            var _local_4= new Sound();
            _local_4.addEventListener(Event.COMPLETE, (this._Str_18059 : ASAny));
            _local_4.addEventListener(IOErrorEvent.IO_ERROR, (this.ioErrorHandler : ASAny));
            _local_4.load(_local_3);
            this._loadingSamples.add(_local_4, k);
        }

        public function update(k:UInt)
        {
            this.processLoadedSamples();
        }

        function _Str_18059(k:Event)
        {
            var _local_2= ASCompat.dynamicAs(k.target , Sound);
            this._loadedSamples.push(_local_2);
        }

        function ioErrorHandler(k:Event)
        {
            this._soundManager.events.dispatchEvent(new TraxSongLoadEvent(TraxSongLoadEvent.TSLE_TRAX_LOAD_FAILED, this._soundManager._Str_18031));
            this._loadErrorCallback();
        }

        function _Str_25674(k:Sound)
        {
            var _local_2 = 0;
            var _local_3 = Math.NaN;
            var _local_4:TraxSample = null;
            if (this._loadingSamples.getValue(k) != null)
            {
                _local_2 = ASCompat.toInt(this._loadingSamples.remove(k));
                if (this._traxSamples.getValue(_local_2) == null)
                {
                    this._byteBuffer.clear();
                    _local_3 = k.length;
ASCompat.extractSound(                    k, this._byteBuffer, Std.int((_local_3 * 44.1)));
                    _local_4 = new TraxSample(this._byteBuffer, _local_2, TraxSample.SAMPLE_FREQUENCY_44KHZ, TraxSample.SAMPLE_SCALE_16BIT);
                    this._traxSamples.add(_local_2, _local_4);
                }
            }
        }

        function processLoadedSamples()
        {
            var k = 0;
            var _local_2 = 0;
            var _local_3:Sound = null;
            if (this._loadedSamples.length > 0)
            {
                k = flash.Lib.getTimer();
                _local_2 = k;
                while ((((_local_2 - k) < _Str_17010) && (this._loadedSamples.length > 0)))
                {
                    _local_3 = this._loadedSamples.splice(0, 1)[0];
                    this._Str_25674(_local_3);
                    _local_2 = flash.Lib.getTimer();
                }
                if (((this._loadingSamples.length == 0) && (!(this._soundManager._Str_18031 == -1))))
                {
                    this._soundManager.events.dispatchEvent(new TraxSongLoadEvent(TraxSongLoadEvent.TSLE_TRAX_LOAD_COMPLETE, this._soundManager._Str_18031));
                    if (this._purgeSamplesEnabled)
                    {
                        this._Str_24614();
                    }
                }
            }
        }

        function _Str_25906()
        {
        }

        function _Str_24614()
        {
            var _local_5 = 0;
            var _local_6:TraxSample = null;
            var _local_7:Array<ASAny> = null;
            var _local_8:UInt = 0;
            var _local_9 = 0;
            var _local_10:TraxSample = null;
            var _local_11 = 0;
            var _local_12:TraxSample = null;
            var k:UInt = 0;
            var _local_2:Array<ASAny> = [];
            var _local_3= this._soundManager.musicController.samplesIdsInUse;
            var _local_4 = 0;
            while ((_local_4 : UInt) < this._traxSamples.length)
            {
                _local_5 = ASCompat.toInt(this._traxSamples.getKey(_local_4));
                _local_6 = this._traxSamples.getWithIndex(_local_4);
                if (((!(_local_6.usageCount == 0)) && (_local_3.indexOf(_local_5) == -1)))
                {
                    _local_2.push(_local_6);
                }
                k = (k + _local_6.length);
                _local_4++;
            }
            if (k > (_Str_18145 : UInt))
            {
                _local_7 = [];
                Logger.log(["Sample memory limit reached, clearing the oldest and least frequently used samples"]);
                ASCompat.ASArray.sort(_local_2, this._Str_23844);
                _local_8 = 0;
                _local_9 = 0;
                while (((_local_8 < (k - _Str_17865)) && (_local_9 < _local_2.length)))
                {
                    _local_10 = _local_2[_local_9++];
                    _local_8 = (_local_8 + _local_10.length);
                    _local_7.push(_local_10.id);
                }
                _local_2 = null;
                if (_local_7.length > 0)
                {
                    if (checkNullIteratee(_local_7)) for (_tmp_ in _local_7)
                    {
_local_11  = ASCompat.toInt(_tmp_);
                        Logger.log([("Purging sample : " + Std.string(_local_11))]);
                        _local_12 = ASCompat.dynamicAs(this._traxSamples.getValue(_local_11) , TraxSample);
                        _local_12.dispose();
                        this._traxSamples.remove(_local_11);
                    }
                    this._soundManager.musicController.samplesUnloaded(_local_7);
                }
            }
        }

        function _Str_23844(k:TraxSample, _arg_2:TraxSample):Int
        {
            if (k.usageCount < _arg_2.usageCount)
            {
                return -1;
            }
            if (k.usageCount > _arg_2.usageCount)
            {
                return 1;
            }
            if (k.usageTimeStamp < _arg_2.usageTimeStamp)
            {
                return -1;
            }
            if (k.usageTimeStamp > _arg_2.usageTimeStamp)
            {
                return 1;
            }
            return 0;
        }
    }

