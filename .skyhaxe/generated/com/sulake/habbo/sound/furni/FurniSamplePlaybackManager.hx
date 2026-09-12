package com.sulake.habbo.sound.furni
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.sound.HabboSoundManagerFlash10;
    import flash.events.IEventDispatcher;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.room.events.RoomEngineObjectSamplePlaybackEvent;
    import com.sulake.habbo.sound.HabboSoundWithPitch;
    import flash.net.URLRequest;
    import flash.media.Sound;
    import flash.events.Event;
    import flash.events.IOErrorEvent;

     class FurniSamplePlaybackManager implements IDisposable 
    {
        var _soundManager:HabboSoundManagerFlash10;
        var _roomEvents:IEventDispatcher;
        var _disposed:Bool = false;
        var _loadedSamples:Map;
        var _loadingSamples:Map;
        var _initialPitch:Map;
        var _volume:Float = 1;

        public function new(k:HabboSoundManagerFlash10, _arg_2:IEventDispatcher)
        {
            this._loadedSamples = new Map();
            this._loadingSamples = new Map();
            this._initialPitch = new Map();
            this._soundManager = k;
            this._roomEvents = _arg_2;
            this._roomEvents.addEventListener(RoomEngineObjectSamplePlaybackEvent.REOSPE_ROOM_OBJECT_INITIALIZED, this._Str_19837);
            this._roomEvents.addEventListener(RoomEngineObjectSamplePlaybackEvent.REOSPE_ROOM_OBJECT_DISPOSED, this._Str_21969);
            this._roomEvents.addEventListener(RoomEngineObjectSamplePlaybackEvent.REOSPE_PLAY_SAMPLE, this._Str_22002);
            this._roomEvents.addEventListener(RoomEngineObjectSamplePlaybackEvent.REOSPE_CHANGE_PITCH, this._Str_20753);
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                if (this._roomEvents != null)
                {
                    this._roomEvents.removeEventListener(RoomEngineObjectSamplePlaybackEvent.REOSPE_ROOM_OBJECT_INITIALIZED, this._Str_19837);
                    this._roomEvents.removeEventListener(RoomEngineObjectSamplePlaybackEvent.REOSPE_ROOM_OBJECT_DISPOSED, this._Str_21969);
                    this._roomEvents.removeEventListener(RoomEngineObjectSamplePlaybackEvent.REOSPE_PLAY_SAMPLE, this._Str_22002);
                    this._roomEvents.removeEventListener(RoomEngineObjectSamplePlaybackEvent.REOSPE_CHANGE_PITCH, this._Str_20753);
                    this._roomEvents = null;
                }
                if (this._loadedSamples != null)
                {
                    this._loadedSamples.dispose();
                    this._loadedSamples = null;
                }
                if (this._loadingSamples != null)
                {
                    this._loadingSamples.dispose();
                    this._loadingSamples = null;
                }
                if (this._initialPitch != null)
                {
                    this._initialPitch.dispose();
                    this._initialPitch = null;
                }
                this._soundManager = null;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function updateVolume(k:Float)
        {
            var _local_2:HabboSoundWithPitch = null;
            this._volume = k;
            final _iter_ = this._loadedSamples.getValues(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                _local_2.volume = this._volume;
            }
        }

        function _Str_19837(k:RoomEngineObjectSamplePlaybackEvent)
        {
            if (k._Str_6992 != -1)
            {
                this._Str_23007(k.objectId, k._Str_6992);
                if (this._initialPitch.hasKey(k.objectId))
                {
                    this._initialPitch.remove(k.objectId);
                }
                this._initialPitch.add(k.objectId, k.pitch);
            }
        }

        function _Str_21969(k:RoomEngineObjectSamplePlaybackEvent)
        {
            this._Str_25308(k.objectId);
        }

        function _Str_22002(k:RoomEngineObjectSamplePlaybackEvent)
        {
            if (this._loadedSamples.getValue(k.objectId) != null)
            {
                this._Str_24951(k.objectId);
            }
        }

        function _Str_20753(k:RoomEngineObjectSamplePlaybackEvent)
        {
            if (this._loadedSamples.getValue(k.objectId) != null)
            {
                this._Str_25082(k.objectId, k.pitch);
            }
        }

        function _Str_23007(k:Int, _arg_2:Int)
        {
            if (((this._loadedSamples.getValue(k) == null) && (this._loadingSamples.getValues().indexOf(_arg_2) == -1)))
            {
                this.loadSample(_arg_2, k);
            }
        }

        function _Str_25308(k:Int)
        {
            var _local_2:HabboSoundWithPitch = this._loadedSamples.getValue(k);
            if (_local_2 != null)
            {
                this._soundManager.removeUpdateReceiver(_local_2);
                _local_2.dispose();
                this._loadedSamples.remove(k);
            }
        }

        function _Str_24951(k:Int)
        {
            var _local_2:HabboSoundWithPitch = this._loadedSamples.getValue(k);
            if (_local_2 != null)
            {
                _local_2.stop();
                _local_2.play();
            }
        }

        function _Str_25082(k:Int, _arg_2:Float)
        {
            var _local_3:HabboSoundWithPitch = this._loadedSamples.getValue(k);
            if (_local_3 != null)
            {
                _local_3._Str_19664(_arg_2);
            }
        }

        function loadSample(k:Int, _arg_2:Int)
        {
            var _local_3= this._soundManager.getProperty("flash.dynamic.download.url");
            _local_3 = (_local_3 + this._soundManager.getProperty("flash.dynamic.download.samples.template"));
            _local_3 = new compat.RegExp("%typeid%").replace(_local_3, Std.string(k));
            var _local_4= new URLRequest(_local_3);
            var _local_5= new Sound();
            _local_5.addEventListener(Event.COMPLETE, (this._Str_18059 : ASAny));
            _local_5.addEventListener(IOErrorEvent.IO_ERROR, (this.ioErrorHandler : ASAny));
            _local_5.load(_local_4);
            this._loadingSamples.add(_local_5, _arg_2);
        }

        function _Str_18059(k:Event)
        {
            if (this.disposed)
            {
                return;
            }
            var _local_2= ASCompat.dynamicAs(k.target , Sound);
            if (((_local_2 == null) || (this._loadingSamples.getValue(_local_2) == null)))
            {
                return;
            }
            var _local_3= ASCompat.toInt(this._loadingSamples.getValue(_local_2));
            var _local_4= new HabboSoundWithPitch(_local_2, ASCompat.toNumber(this._initialPitch.getValue(_local_3)));
            this._soundManager.registerUpdateReceiver(_local_4, 0);
            _local_4.volume = this._volume;
            this._loadedSamples.add(_local_3, _local_4);
            this._loadingSamples.remove(_local_2);
        }

        function ioErrorHandler(k:IOErrorEvent)
        {
            Logger.log([((("Error loading sound " + k.target) + " text ") + k.text)]);
        }
    }

