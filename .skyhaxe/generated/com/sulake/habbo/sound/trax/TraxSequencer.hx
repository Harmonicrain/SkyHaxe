package com.sulake.habbo.sound.trax
;
    import com.sulake.habbo.sound.IHabboSound;
    import com.sulake.core.runtime.IDisposable;
    import flash.events.IEventDispatcher;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import com.sulake.core.utils.Map;
    import flash.utils.Timer;
    import flash.media.SoundTransform;
    import flash.events.SampleDataEvent;
    import flash.events.TimerEvent;
    import flash.utils.ByteArray;
    import com.sulake.habbo.sound.events.SoundControllerEvent;

     class TraxSequencer implements IHabboSound implements  IDisposable 
    {
        static inline final SAMPLES_PER_SECOND:Float = 44100;
        static inline final BUFFER_LENGTH:UInt = 0x2000;
        static inline final SAMPLES_BAR_LENGTH:UInt = 88000;
        static inline final BAR_LENGTH:UInt = 88000;
        static final MIXING_BUFFER:Vector<Int> = new Vector(BUFFER_LENGTH, true);
        static final INTERPOLATION_BUFFER:Vector<Int> = new Vector(BUFFER_LENGTH, true);

        var _disposed:Bool = false;
        var _events:IEventDispatcher;
        var _volume:Float = Math.NaN;
        var _sound:Sound;
        var _soundChannel:SoundChannel;
        var _traxData:TraxData;
        var _samples:Map;
        var _ready:Bool = false;
        var _songId:Int = 0;
        var _playLengthSamples:Int = 0;
        var _playHead:UInt = 0;
        var _sequence:Array<ASAny>;
        var _prepared:Bool = false;
        var _finished:Bool = true;
        var _lengthSamples:UInt = 0;
        var _latencyMs:UInt = 0;
        var _fadeInActive:Bool = false;
        var _fadeOutActive:Bool = false;
        var _fadeInLengthSamples:Int = 0;
        var _fadeOutLengthSamples:Int = 0;
        var _fadeInSampleCounter:Int = 0;
        var _fadeOutSampleCounter:Int = 0;
        var _fadeoutStopTimer:Timer;
        var _stopTimer:Timer;
        var _useCutMode:Bool = false;
        var _expectedStreamPosition:Int = 0;
        var _bufferUnderRunCount:Int = 0;

        public function new(k:Int, _arg_2:TraxData, _arg_3:Map, _arg_4:IEventDispatcher)
        {
            this._latencyMs = ASCompat.toUInt(30);
            this._events = _arg_4;
            this._songId = k;
            this._volume = 1;
            this._sound = new Sound();
            this._soundChannel = null;
            this._samples = _arg_3;
            this._traxData = _arg_2;
            this._ready = true;
            this._playHead = 0;
            this._sequence = [];
            this._prepared = false;
            this._lengthSamples = 0;
            this._finished = false;
            this._fadeInActive = false;
            this._fadeOutActive = false;
            this._fadeInLengthSamples = 0;
            this._fadeOutLengthSamples = 0;
            this._fadeInSampleCounter = 0;
            this._fadeOutSampleCounter = 0;
        }

        
        public var position(get,set):Float;
public function  set_position(k:Float):Float        {
            this._playHead = ASCompat.toUInt((k * SAMPLES_PER_SECOND));
return k;
        }

        
        public var volume(get,set):Float;
public function  get_volume():Float
        {
            return this._volume;
        }
public function  get_position():Float
        {
            return this._playHead / SAMPLES_PER_SECOND;
        }

        
        public var ready(get,set):Bool;
public function  get_ready():Bool
        {
            return this._ready;
        }
public function  set_ready(k:Bool):Bool        {
            return this._ready = k;
        }

        public var finished(get,never):Bool;
public function  get_finished():Bool
        {
            return this._finished;
        }

        
        public var fadeOutSeconds(get,set):Float;
public function  get_fadeOutSeconds():Float
        {
            return this._fadeOutLengthSamples / SAMPLES_PER_SECOND;
        }
public function  set_fadeOutSeconds(k:Float):Float        {
            this._fadeOutLengthSamples = Std.int((k * SAMPLES_PER_SECOND));
return k;
        }

        
        public var fadeInSeconds(get,set):Float;
public function  get_fadeInSeconds():Float
        {
            return this._fadeInLengthSamples / SAMPLES_PER_SECOND;
        }
public function  set_fadeInSeconds(k:Float):Float        {
            this._fadeInLengthSamples = Std.int((k * SAMPLES_PER_SECOND));
return k;
        }

        public var traxData(get,never):TraxData;
public function  get_traxData():TraxData
        {
            return this._traxData;
        }
public function  set_volume(k:Float):Float        {
            this._volume = k;
            if (this._soundChannel != null)
            {
                this._soundChannel.soundTransform = new SoundTransform(this._volume);
            }
return k;
        }

        public var length(get,never):Float;
public function  get_length():Float
        {
            return this._lengthSamples / SAMPLES_PER_SECOND;
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
                this.stopImmediately();
                this._traxData = null;
                this._samples = null;
                this._sequence = null;
                this._events = null;
                this._sound = null;
                this._disposed = true;
            }
        }

        public function prepare():Bool
        {
            if (!this._ready)
            {
                Logger.log(["Cannot start trax playback until samples ready!"]);
                return false;
            }
            if (!this._prepared)
            {
                if (this._traxData != null)
                {
                    this._useCutMode = false;
                    if (this._traxData.hasMetaData)
                    {
                        this._useCutMode = this._traxData.metaCutMode;
                    }
                    if (this._useCutMode)
                    {
                        if (!this.prepareSequence())
                        {
                            Logger.log(["Cannot start playback, prepare sequence failed!"]);
                            return false;
                        }
                    }
                    else
                    {
                        if (!this.prepareLegacySequence())
                        {
                            Logger.log(["Cannot start playback, prepare legacy sequence failed!"]);
                            return false;
                        }
                    }
                }
            }
            return true;
        }

        function prepareLegacySequence():Bool
        {
            var _local_3:Map = null;
            var _local_4:TraxChannel = null;
            var _local_5:UInt = 0;
            var _local_6:UInt = 0;
            var _local_7 = 0;
            var _local_8 = 0;
            var _local_9:TraxSample = null;
            var _local_10 = 0;
            var _local_11 = 0;
            var _local_12 = 0;
            if (this._sequence == null)
            {
                return false;
            }
            var k:UInt = flash.Lib.getTimer();
            var _local_2 = 0;
            while (_local_2 < this._traxData.channels.length)
            {
                _local_3 = new Map();
                _local_4 = ASCompat.dynamicAs(this._traxData.channels[_local_2] , TraxChannel);
                _local_5 = 0;
                _local_6 = 0;
                _local_7 = 0;
                while (_local_7 < _local_4.itemCount)
                {
                    _local_8 = _local_4.getItem(_local_7).id;
                    _local_9 = ASCompat.dynamicAs(this._samples.getValue(_local_8) , TraxSample);
                    _local_9.setUsageFromSong(this._songId, k);
                    if (_local_9 != null)
                    {
                        _local_10 = this.getSampleBars(_local_9.length);
                        _local_11 = Std.int(_local_4.getItem(_local_7).length / _local_10);
                        _local_12 = 0;
                        while (_local_12 < _local_11)
                        {
                            if (_local_8 != 0)
                            {
                                _local_3.add(_local_5, _local_9);
                            }
                            _local_6 = (_local_6 + _local_10);
                            _local_5 = (_local_6 * BAR_LENGTH);
                            _local_12++;
                        }
                    }
                    else
                    {
                        Logger.log(["Error in prepareLegacySequence(), sample was null!"]);
                        return false;
                    }
                    if (this._lengthSamples < _local_5)
                    {
                        this._lengthSamples = _local_5;
                    }
                    _local_7++;
                }
                this._sequence.push(_local_3);
                _local_2++;
            }
            this._prepared = true;
            return true;
        }

        function prepareSequence():Bool
        {
            var _local_3:Map = null;
            var _local_4:TraxChannel = null;
            var _local_5:UInt = 0;
            var _local_6:UInt = 0;
            var _local_7 = false;
            var _local_8 = 0;
            var _local_9 = 0;
            var _local_10:TraxSample = null;
            var _local_11 = 0;
            var _local_12 = 0;
            var _local_13 = 0;
            var _local_14 = 0;
            if (this._sequence == null)
            {
                return false;
            }
            var k:UInt = flash.Lib.getTimer();
            var _local_2 = 0;
            while (_local_2 < this._traxData.channels.length)
            {
                _local_3 = new Map();
                _local_4 = ASCompat.dynamicAs(this._traxData.channels[_local_2] , TraxChannel);
                _local_5 = 0;
                _local_6 = 0;
                _local_7 = false;
                _local_8 = 0;
                while (_local_8 < _local_4.itemCount)
                {
                    _local_9 = _local_4.getItem(_local_8).id;
                    _local_10 = ASCompat.dynamicAs(this._samples.getValue(_local_9) , TraxSample);
                    _local_10.setUsageFromSong(this._songId, k);
                    if (_local_10 != null)
                    {
                        _local_11 = ASCompat.toInt(_local_6);
                        _local_12 = ASCompat.toInt(_local_5);
                        _local_13 = this.getSampleBars(_local_10.length);
                        _local_14 = _local_4.getItem(_local_8).length;
                        while ((_local_11 : UInt) < (_local_6 + _local_14))
                        {
                            if (((!(_local_9 == 0)) || _local_7))
                            {
                                _local_3.add(_local_12, _local_10);
                                _local_7 = false;
                            }
                            _local_11 = (_local_11 + _local_13);
                            _local_12 = ASCompat.toInt(_local_11 * BAR_LENGTH);
                            if ((_local_11 : UInt) > (_local_6 + _local_14))
                            {
                                _local_7 = true;
                            }
                        }
                        _local_6 = (_local_6 + _local_4.getItem(_local_8).length);
                        _local_5 = (_local_6 * BAR_LENGTH);
                    }
                    else
                    {
                        Logger.log(["Error in prepareSequence(), sample was null!"]);
                        return false;
                    }
                    if (this._lengthSamples < _local_5)
                    {
                        this._lengthSamples = _local_5;
                    }
                    _local_8++;
                }
                this._sequence.push(_local_3);
                _local_2++;
            }
            this._prepared = true;
            return true;
        }

        public function play(k:Float=0):Bool
        {
            if (!this.prepare())
            {
                return false;
            }
            this.removeFadeoutStopTimer();
            if (this._soundChannel != null)
            {
                this.stopImmediately();
            }
            if (this._fadeInLengthSamples > 0)
            {
                this._fadeInActive = true;
                this._fadeInSampleCounter = 0;
            }
            this._fadeOutActive = false;
            this._fadeOutSampleCounter = 0;
            this._finished = false;
            this._sound.addEventListener(SampleDataEvent.SAMPLE_DATA, (this.onSampleData : ASAny));
            this._playLengthSamples = Std.int(k * SAMPLES_PER_SECOND);
            this._expectedStreamPosition = 0;
            this._bufferUnderRunCount = 0;
            this._soundChannel = this._sound.play();
            this.volume = this._volume;
            return true;
        }

        public function render(k:SampleDataEvent):Bool
        {
            if (!this.prepare())
            {
                return false;
            }
            while ((!this._finished))
            {
                this.onSampleData(k);
            }
            return true;
        }

        public function stop():Bool
        {
            if (((this._fadeOutLengthSamples > 0) && (!this._finished)))
            {
                this.stopWithFadeout();
            }
            else
            {
                this.playingComplete();
            }
            return true;
        }

        function stopImmediately()
        {
            this.removeStopTimer();
            if (this._soundChannel != null)
            {
                this._soundChannel.stop();
                this._soundChannel = null;
            }
            if (this._sound != null)
            {
                this._sound.removeEventListener(SampleDataEvent.SAMPLE_DATA, (this.onSampleData : ASAny));
            }
        }

        function stopWithFadeout()
        {
            if (this._fadeoutStopTimer == null)
            {
                this._fadeOutActive = true;
                this._fadeOutSampleCounter = 0;
                this._fadeoutStopTimer = new Timer((this._latencyMs + (this._fadeOutLengthSamples / (SAMPLES_PER_SECOND / 1000))), 1);
                this._fadeoutStopTimer.start();
                this._fadeoutStopTimer.addEventListener(TimerEvent.TIMER_COMPLETE, (this.onFadeOutComplete : ASAny));
            }
        }

        function getSampleBars(k:UInt):Int
        {
            if (this._useCutMode)
            {
                return Std.int(Math.fround((k / SAMPLES_BAR_LENGTH)));
            }
            return Std.int(Math.fceil((k / SAMPLES_BAR_LENGTH)));
        }

        function getChannelSequenceOffsets():Array<ASAny>
        {
            var _local_2 = 0;
            var _local_3 = 0;
            var _local_4:Map = null;
            var _local_5 = 0;
            var k:Array<ASAny> = [];
            if (this._sequence != null)
            {
                _local_2 = this._sequence.length;
                _local_3 = 0;
                while (_local_3 < _local_2)
                {
                    _local_4 = this._sequence[_local_3];
                    _local_5 = 0;
                    while ((((_local_5 : UInt) < _local_4.length) && (_local_4.getKey(_local_5) < this._playHead)))
                    {
                        _local_5++;
                    }
                    k.push((_local_5 - 1));
                    _local_3++;
                }
            }
            return k;
        }

        function mixChannelsIntoBuffer()
        {
var _local_15:ASAny  = null;            var _local_5:Map = null;
            var _local_6 = 0;
            var _local_7:TraxSample = null;
            var _local_8 = 0;
            var _local_9 = 0;
            var _local_10 = 0;
            var _local_11 = 0;
            var _local_12 = 0;
            var _local_13 = 0;
            var _local_14 = 0;
            if (this._sequence == null)
            {
                return;
            }
            var k= this.getChannelSequenceOffsets();
            var _local_2= this._sequence.length;
            var _local_3:TraxChannelSample = null;
            var _local_4= (_local_2 - 1);
            while (_local_4 >= 0)
            {
                _local_5 = this._sequence[_local_4];
                _local_6 = ASCompat.toInt(k[_local_4]);
                _local_7 = _local_5.getWithIndex(_local_6);
                if (_local_7 == null)
                {
                    _local_3 = null;
                }
                else
                {
                    _local_10 = ASCompat.toInt(_local_5.getKey(_local_6));
                    _local_11 = ASCompat.toInt(this._playHead - _local_10);
                    if (((_local_7.id == 0) || (_local_11 < 0)))
                    {
                        _local_3 = null;
                    }
                    else
                    {
                        _local_3 = new TraxChannelSample(_local_7, _local_11);
                    }
                }
                _local_8 = ASCompat.toInt(BUFFER_LENGTH);
                if ((this._lengthSamples - this._playHead) < (_local_8 : UInt))
                {
                    _local_8 = ASCompat.toInt(this._lengthSamples - this._playHead);
                }
                _local_9 = 0;
                while (_local_9 < _local_8)
                {
                    _local_12 = _local_8;
                    if ((_local_6 : UInt) < (_local_5.length - 1))
                    {
                        _local_13 = ASCompat.toInt(_local_5.getKey((_local_6 + 1)));
                        if ((_local_8 + this._playHead) >= (_local_13 : UInt))
                        {
                            _local_12 = ASCompat.toInt(_local_13 - this._playHead);
                        }
                    }
                    if (_local_12 > (_local_8 - _local_9))
                    {
                        _local_12 = (_local_8 - _local_9);
                    }
                    if (_local_4 == (_local_2 - 1))
                    {
                        if (_local_3 != null)
                        {
                            _local_3.setSample(MIXING_BUFFER, _local_9, _local_12);
                            _local_9 = (_local_9 + _local_12);
                        }
                        else
                        {
                            _local_14 = 0;
                            while (_local_14 < _local_12)
                            {
_local_15= _local_9++;
                                MIXING_BUFFER[ASCompat.toInt(_local_15)] = 0;
                                _local_14++;
                            }
                        }
                    }
                    else
                    {
                        if (_local_3 != null)
                        {
                            _local_3.addSample(MIXING_BUFFER, _local_9, _local_12);
                        }
                        _local_9 = (_local_9 + _local_12);
                    }
                    if (_local_9 < _local_8)
                    {
                        _local_7 = _local_5.getWithIndex(++_local_6);
                        if (((_local_7 == null) || (_local_7.id == 0)))
                        {
                            _local_3 = null;
                        }
                        else
                        {
                            _local_3 = new TraxChannelSample(_local_7, 0);
                        }
                    }
                }
                _local_4--;
            }
        }

        function checkSongFinishing()
        {
            var k= ASCompat.toInt((this._lengthSamples < (this._playLengthSamples : UInt)) ? ASCompat.toInt(this._lengthSamples ): ASCompat.toInt((this._playLengthSamples > 0) ? this._playLengthSamples : ASCompat.toInt(this._lengthSamples)));
            if (((this._playHead > (k + (this._latencyMs * (SAMPLES_PER_SECOND / 1000)))) && (!this._finished)))
            {
                this._finished = true;
                if (this._stopTimer != null)
                {
                    this._stopTimer.reset();
                    this._stopTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, (this.onPlayingComplete : ASAny));
                }
                this._stopTimer = new Timer(2, 1);
                this._stopTimer.start();
                this._stopTimer.addEventListener(TimerEvent.TIMER_COMPLETE, (this.onPlayingComplete : ASAny));
            }
            else
            {
                if (((this._playHead > ((k - this._fadeOutLengthSamples) : UInt)) && (!this._fadeOutActive)))
                {
                    this._fadeInActive = false;
                    this._fadeOutActive = true;
                    this._fadeOutSampleCounter = 0;
                }
            }
        }

        function onSampleData(k:SampleDataEvent)
        {
            if (k.position > this._expectedStreamPosition)
            {
                this._bufferUnderRunCount++;
                Logger.log(["Audio buffer under run..."]);
                this._expectedStreamPosition = Std.int(k.position);
            }
            if (this.volume > 0)
            {
                this.mixChannelsIntoBuffer();
            }
            var _local_2= ASCompat.toInt(BUFFER_LENGTH);
            if ((this._lengthSamples - this._playHead) < (_local_2 : UInt))
            {
                _local_2 = ASCompat.toInt(this._lengthSamples - this._playHead);
                if (_local_2 < 0)
                {
                    _local_2 = 0;
                }
            }
            if (this.volume <= 0)
            {
                _local_2 = 0;
            }
            this.writeAudioToOutputStream(k.data, _local_2);
            this._playHead = (this._playHead + BUFFER_LENGTH);
            this._expectedStreamPosition = ASCompat.toInt(this._expectedStreamPosition + BUFFER_LENGTH);
            if (this._soundChannel != null)
            {
                this._latencyMs = Std.int(((k.position / SAMPLES_PER_SECOND) * 1000) - this._soundChannel.position);
            }
            this.checkSongFinishing();
        }

        function writeAudioToOutputStream(k:com.sulake.core.utils.ByteArray, _arg_2:Int)
        {
            var _local_5 = Math.NaN;
            var _local_6 = Math.NaN;
            if (_arg_2 > 0)
            {
                if (((!this._fadeInActive) && (!this._fadeOutActive)))
                {
                    this.writeMixingBufferToOutputStream(k, _arg_2);
                }
                else
                {
                    if (this._fadeInActive)
                    {
                        _local_5 = (1 / this._fadeInLengthSamples);
                        _local_6 = (this._fadeInSampleCounter / this._fadeInLengthSamples);
                        this._fadeInSampleCounter = ASCompat.toInt(this._fadeInSampleCounter + BUFFER_LENGTH);
                        if (this._fadeInSampleCounter > this._fadeInLengthSamples)
                        {
                            this._fadeInActive = false;
                        }
                    }
                    else
                    {
                        if (this._fadeOutActive)
                        {
                            _local_5 = (-1 / this._fadeOutLengthSamples);
                            _local_6 = (1 - (this._fadeOutSampleCounter / this._fadeOutLengthSamples));
                            this._fadeOutSampleCounter = ASCompat.toInt(this._fadeOutSampleCounter + BUFFER_LENGTH);
                            if (this._fadeOutSampleCounter > this._fadeOutLengthSamples)
                            {
                                this._fadeOutSampleCounter = this._fadeOutLengthSamples;
                            }
                        }
                    }
                    this.writeMixingBufferToOutputStreamWithFade(k, _arg_2, _local_6, _local_5);
                }
            }
            var _local_3:Float = 0;
            var _local_4= _arg_2;
            while ((_local_4 : UInt) < BUFFER_LENGTH)
            {
                k.writeFloat(_local_3);
                k.writeFloat(_local_3);
                _local_4++;
            }
        }

        function writeMixingBufferToOutputStream(k:com.sulake.core.utils.ByteArray, _arg_2:Int)
        {
            var _local_3:Float = 0;
            var _local_4 = 0;
            while (_local_4 < _arg_2)
            {
                _local_3 = (MIXING_BUFFER[_local_4] * TraxSample._Str_11575);
                k.writeFloat(_local_3);
                k.writeFloat(_local_3);
                _local_4++;
            }
        }

        function writeMixingBufferToOutputStreamWithFade(k:com.sulake.core.utils.ByteArray, _arg_2:Int, _arg_3:Float, _arg_4:Float)
        {
            var _local_5:Float = 0;
            var _local_6 = 0;
            _local_6 = 0;
            while (_local_6 < _arg_2)
            {
                if (((_arg_3 < 0) || (_arg_3 > 1)))
                {
                    break;
                }
                _local_5 = ((MIXING_BUFFER[_local_6] * TraxSample._Str_11575) * _arg_3);
                _arg_3 = (_arg_3 + _arg_4);
                k.writeFloat(_local_5);
                k.writeFloat(_local_5);
                _local_6++;
            }
            if (_arg_3 < 0)
            {
                while (_local_6 < _arg_2)
                {
                    k.writeFloat(0);
                    k.writeFloat(0);
                    _local_6++;
                }
            }
            else
            {
                if (_arg_3 > 1)
                {
                    while (_local_6 < _arg_2)
                    {
                        _local_5 = (MIXING_BUFFER[_local_6] * TraxSample._Str_11575);
                        _arg_3 = (_arg_3 + _arg_4);
                        k.writeFloat(_local_5);
                        k.writeFloat(_local_5);
                        _local_6++;
                    }
                }
            }
        }

        function onPlayingComplete(k:TimerEvent)
        {
            if (this._finished)
            {
                this.playingComplete();
            }
        }

        function onFadeOutComplete(k:TimerEvent)
        {
            this.removeFadeoutStopTimer();
            this.playingComplete();
        }

        function playingComplete()
        {
            this.stopImmediately();
            this._events.dispatchEvent(new SoundControllerEvent(SoundControllerEvent.TRAX_SONG_COMPLETE, this._songId));
        }

        function removeFadeoutStopTimer()
        {
            if (this._fadeoutStopTimer != null)
            {
                this._fadeoutStopTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, (this.onFadeOutComplete : ASAny));
                this._fadeoutStopTimer.reset();
                this._fadeoutStopTimer = null;
            }
        }

        function removeStopTimer()
        {
            if (this._stopTimer != null)
            {
                this._stopTimer.reset();
                this._stopTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, (this.onPlayingComplete : ASAny));
                this._stopTimer = null;
            }
        }
    }

