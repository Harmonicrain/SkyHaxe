package com.sulake.habbo.sound
;
    import com.sulake.core.runtime.Component;
    import com.sulake.core.runtime.IUpdateReceiver;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import com.sulake.core.communication.connection.IConnection;
    import com.sulake.habbo.room.IRoomEngine;
    import com.sulake.habbo.notifications.IHabboNotifications;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.sound.trax.TraxSequencer;
    import com.sulake.habbo.sound.music.TraxSampleManager;
    import com.sulake.habbo.sound.furni.FurniSamplePlaybackManager;
    import com.sulake.iid.IIDHabboCommunicationManager;
    import com.sulake.iid.IIDRoomEngine;
    import com.sulake.iid.IIDHabboNotifications;
    import com.sulake.habbo.sound.events.TraxSongLoadEvent;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.room.events.RoomEngineObjectPlaySoundEvent;
    import flash.media.Sound;
    import com.sulake.habbo.sound.trax.TraxData;
    import com.sulake.core.runtime.IID;
    import com.sulake.core.runtime.IUnknown;
    import com.sulake.habbo.sound.music.HabboMusicController;
    import com.sulake.habbo.communication.messages.incoming.preferences.AccountPreferencesEvent;
    import com.sulake.habbo.communication.messages.outgoing.sound.GetSoundSettingsComposer;
    import flash.events.Event;
    import com.sulake.habbo.communication.messages.outgoing.preferences.SetSoundSettingsComposer;
    import com.sulake.core.communication.messages.IMessageEvent;

     class HabboSoundManagerFlash10 extends Component implements IHabboSoundManager implements  IUpdateReceiver 
    {
        var _communication:IHabboCommunicationManager;
        var _connection:IConnection;
        var _roomEngine:IRoomEngine;
        var _notifications:IHabboNotifications;
        var _genericVolume:Float = 1;
        var _traxVolume:Float = 1;
        var _furniVolume:Float = 1;
        var _genericSamples:Map;
        var _loadingSongId:Int = -1;
        var _loadingSong:TraxSequencer;
        var _musicController:IHabboMusicController;
        var _traxSampleManager:TraxSampleManager;
        var _onDemandSamplePlaybackManager:FurniSamplePlaybackManager;
        var _loadingSongQueue:Map;
        var _muted:Bool = false;

        public function new(k:IContext, _arg_2:UInt=0, _arg_3:IAssetLibrary=null, _arg_4:Bool=true)
        {
            this._genericSamples = new Map();
            this._loadingSongQueue = new Map();
            super(k, _arg_2, _arg_3);
            if (_arg_4)
            {
                queueInterface(new IIDHabboCommunicationManager(), this._Str_25566);
                queueInterface(new IIDRoomEngine(), this.onRoomEngineReady);
                queueInterface(new IIDHabboNotifications(), this._Str_16511);
            }
            events.addEventListener(TraxSongLoadEvent.TSLE_TRAX_LOAD_COMPLETE, this._Str_23582);
            registerUpdateReceiver(this, 1);
            Logger.log(["Sound manager 10 init"]);
        }

        public var musicController(get,never):IHabboMusicController;
public function  get_musicController():IHabboMusicController
        {
            return this._musicController;
        }

        
        public var genericVolume(get,set):Float;
public function  get_genericVolume():Float
        {
            return this._genericVolume;
        }
public function  set_genericVolume(k:Float):Float        {
            this._Str_9171(k, this._furniVolume, this._traxVolume);
            this._Str_16207();
return k;
        }

        
        public var traxVolume(get,set):Float;
public function  get_traxVolume():Float
        {
            return this._traxVolume;
        }
public function  set_traxVolume(k:Float):Float        {
            this._Str_9171(this._genericVolume, this._furniVolume, k);
            this._Str_16207();
return k;
        }

        
        public var furniVolume(get,set):Float;
public function  get_furniVolume():Float
        {
            return this._furniVolume;
        }
public function  set_furniVolume(k:Float):Float        {
            this._Str_9171(this._genericVolume, k, this._traxVolume);
            this._Str_16207();
return k;
        }

        public function previewVolume(k:Float, _arg_2:Float, _arg_3:Float)
        {
            this._Str_9171(k, _arg_2, _arg_3);
        }

        override public function dispose()
        {
            this._connection = null;
            if (this._musicController != null)
            {
                this._musicController.dispose();
                this._musicController = null;
            }
            if (this._traxSampleManager != null)
            {
                this._traxSampleManager.dispose();
                this._traxSampleManager = null;
            }
            if (this._genericSamples != null)
            {
                this._genericSamples.dispose();
                this._genericSamples = null;
            }
            if (this._onDemandSamplePlaybackManager != null)
            {
                this._onDemandSamplePlaybackManager.dispose();
                this._onDemandSamplePlaybackManager = null;
            }
            if (this._communication != null)
            {
                this._communication.release(new IIDHabboCommunicationManager());
                this._communication = null;
            }
            if (this._roomEngine != null)
            {
                this._roomEngine.events.removeEventListener(RoomEngineObjectPlaySoundEvent.PLAY_SOUND, this.onRoomEngineObjectPlaySound);
                this._roomEngine.events.removeEventListener(RoomEngineObjectPlaySoundEvent.PLAY_SOUND_AT_PITCH, this.onRoomEngineObjectPlaySound);
                this._roomEngine.release(new IIDRoomEngine());
                this._roomEngine = null;
            }
            if (this._notifications != null)
            {
                this._notifications.release(new IIDHabboNotifications());
                this._notifications = null;
            }
            super.dispose();
        }

        public function playSound(k:String, _arg_2:Int=0)
        {
            var _local_4:Sound = null;
            var _local_3:IHabboSound = this._genericSamples.getValue(k);
            if (_local_3 == null)
            {
                _local_4 = this._Str_21864(k);
                if (_local_4 != null)
                {
                    _local_3 = new HabboSoundBase(_local_4, _arg_2);
                    this._genericSamples.add(k, _local_3);
                }
            }
            _local_3.volume = this._genericVolume;
            _local_3.play();
        }

        public function playSoundAtPitch(k:String, _arg_2:Float):IHabboSound
        {
            var _local_3= this._Str_21864(k);
            if (_local_3 == null)
            {
                return null;
            }
            var _local_4= new HabboSoundWithPitch(_local_3, _arg_2);
            _local_4.volume = this._genericVolume;
            _local_4.play();
            return _local_4;
        }

        public function stopSound(k:String)
        {
            var _local_2:IHabboSound = this._genericSamples.getValue(k);
            if (_local_2 != null)
            {
                _local_2.stop();
            }
        }

        public var _Str_18031(get,never):Int;
public function  get__Str_18031():Int
        {
            return this._loadingSongId;
        }

        function _Str_25112()
        {
            this._loadingSongId = -1;
            this._loadingSong = null;
        }

        function _Str_21864(k:String):Sound
        {
            var _local_2= "";
            switch (k)
            {
                case HabboSoundTypesEnum.CALL_FOR_HELP:
                    _local_2 = "sound_call_for_help";
                    
                case HabboSoundTypesEnum.GUIDE_INVITATION:
                    _local_2 = "sound_guide_received_invitation";
                    
                case HabboSoundTypesEnum.GUIDE_REQUEST:
                    _local_2 = "sound_guide_help_requested";
                    
                case HabboSoundTypesEnum.MESSAGE_RECEIVED:
                    _local_2 = "sound_console_new_message";
                    
                case HabboSoundTypesEnum.MESSAGE_SENT:
                    _local_2 = "sound_console_message_sent";
                    
                case HabboSoundTypesEnum.PIXELS:
                    _local_2 = "sound_catalogue_duckets";
                    
                case HabboSoundTypesEnum.PURCHASE:
                    _local_2 = "sound_catalogue_cash";
                    
                case HabboSoundTypesEnum.RESPECT:
                    _local_2 = "sound_respect_received";
                    
                case HabboSoundTypesEnum.CAMERA_SHUTTER:
                    _local_2 = "sound_camera_shutter";
                    
                case HabboSoundTypesEnum.GAMES_IG_COUNTDOWN
                   | HabboSoundTypesEnum.GAMES_IG_WINNING
                   | HabboSoundTypesEnum.GAMES_IG_LOSING
				   | HabboSoundTypesEnum.GAMES_SW_GET_SNOWBALL
                   | HabboSoundTypesEnum.GAMES_SW_HIT1
                   | HabboSoundTypesEnum.GAMES_SW_HIT2
                   | HabboSoundTypesEnum.GAMES_SW_HIT3
                   | HabboSoundTypesEnum.GAMES_SW_MAKE_SNOWBALL
                   | HabboSoundTypesEnum.GAMES_SW_MISS
                   | HabboSoundTypesEnum.GAMES_SW_THROW
                   | HabboSoundTypesEnum.GAMES_SW_WALK:
                    _local_2 = k;
                    
                case HabboSoundTypesEnum.FURNITURE_CUCKOO_CLOCK:
                    _local_2 = k;
                    
                default:
                    Logger.log([("HabboSoundManagerFlash10: Unknown sound request: " + k)]);
                    return null;
            }
            return this._Str_22681(_local_2);
        }

        function _Str_22681(k:String):Sound
        {
            var _local_2= assets.getAssetByName(k);
            return ASCompat.dynamicAs(_local_2.content , Sound);
        }

        public function loadTraxSong(k:Int, _arg_2:String):IHabboSound
        {
            if (this._loadingSong != null)
            {
                return this.addTraxSongForDownload(k, _arg_2);
            }
            var _local_3= this.createTraxInstance(k, _arg_2);
            if (!_local_3.ready)
            {
                this._loadingSong = _local_3;
                this._loadingSongId = k;
            }
            return _local_3 ;
        }

        function addTraxSongForDownload(k:Int, _arg_2:String):IHabboSound
        {
            var _local_3= this.createTraxInstance(k, _arg_2, false);
            if (!_local_3.ready)
            {
                this._loadingSongQueue.add(k, _local_3);
            }
            return _local_3;
        }

        function createTraxInstance(k:Int, _arg_2:String, _arg_3:Bool=true):TraxSequencer
        {
            var _local_4= new TraxData(_arg_2);
            var _local_5= new TraxSequencer(k, _local_4, this._traxSampleManager.traxSamples, events);
            _local_5.volume = this._genericVolume;
            this.validateSampleAvailability(_local_5, _arg_3);
            return _local_5;
        }

        function validateSampleAvailability(k:TraxSequencer, _arg_2:Bool)
        {
            var _local_3= k.traxData;
            var _local_4= _local_3.getSampleIds();
            var _local_5 = false;
            var _local_6 = 0;
            while (_local_6 < _local_4.length)
            {
                if (this._traxSampleManager.traxSamples.getValue(ASCompat.toInt(_local_4[_local_6])) == null)
                {
                    if (_arg_2)
                    {
                        this._traxSampleManager.loadSample(ASCompat.toInt(_local_4[_local_6]));
                    }
                    _local_5 = true;
                }
                _local_6++;
            }
            if (_local_5)
            {
                k.ready = false;
            }
            else
            {
                k.ready = true;
            }
        }

        public function _Str_22895(k:String, _arg_2:String)
        {
            if (this._notifications == null)
            {
                return;
            }
            this._notifications.addSongPlayingNotification(k, _arg_2);
        }

        function _Str_25566(k:IID=null, _arg_2:IUnknown=null)
        {
            var _local_3:IConnection = null;
            if (_arg_2 != null)
            {
                this._communication = cast(_arg_2, IHabboCommunicationManager);
                _local_3 = this._communication.connection;
                if (_local_3 != null)
                {
                    this._Str_23041(_local_3);
                    this.init();
                }
            }
        }

        function onRoomEngineReady(k:IID=null, _arg_2:IUnknown=null)
        {
            if (_arg_2 == null)
            {
                return;
            }
            this._roomEngine = cast(_arg_2, IRoomEngine);
            this.init();
        }

        function _Str_16511(k:IID=null, _arg_2:IUnknown=null)
        {
            if (_arg_2 == null)
            {
                return;
            }
            this._notifications = cast(_arg_2, IHabboNotifications);
        }

        function _Str_23041(k:IConnection)
        {
            if (disposed)
            {
                return;
            }
            if (k != null)
            {
                this._connection = k;
            }
            this.init();
        }

        function init()
        {
            if ((((this._connection == null) || (this._roomEngine == null)) || (!(this._musicController == null))))
            {
                return;
            }
            this._musicController = new HabboMusicController(this, events, this._roomEngine.events, this._connection);
            this._traxSampleManager = new TraxSampleManager(this, this._Str_25112);
            this._onDemandSamplePlaybackManager = new FurniSamplePlaybackManager(this, this._roomEngine.events);
            this._roomEngine.events.addEventListener(RoomEngineObjectPlaySoundEvent.PLAY_SOUND, this.onRoomEngineObjectPlaySound);
            this._roomEngine.events.addEventListener(RoomEngineObjectPlaySoundEvent.PLAY_SOUND_AT_PITCH, this.onRoomEngineObjectPlaySound);
            this._connection.addMessageEvent(new AccountPreferencesEvent(this._Str_24903));
            this._connection.send(new GetSoundSettingsComposer());
        }

        function _Str_25965(k:IHabboMusicController)
        {
            this._musicController = k;
        }

        function _Str_23582(k:Event)
        {
            var _local_2= Std.downcast(k , TraxSongLoadEvent);
            if (_local_2 == null)
            {
                return;
            }
            if (this._loadingSong == null)
            {
                return;
            }
            this._loadingSong.ready = true;
            if (this._musicController == null)
            {
                return;
            }
            this._musicController.onSongLoaded(_local_2.id);
            this._loadingSong = null;
            this._loadingSongId = -1;
        }

        function _Str_16207()
        {
            if (this._connection != null)
            {
                this._connection.send(new SetSoundSettingsComposer(Std.int(this._traxVolume * 100), Std.int(this._furniVolume * 100), Std.int(this._genericVolume * 100)));
            }
        }

        function _Str_9171(k:Float, _arg_2:Float, _arg_3:Float)
        {
            if (this._muted)
            {
                this._genericVolume = 0;
                this._furniVolume = 0;
                this._traxVolume = 0;
                this._musicController.updateVolume(0);
                this._onDemandSamplePlaybackManager.updateVolume(0);
            }
            else
            {
                this._genericVolume = k;
                this._furniVolume = _arg_2;
                this._traxVolume = _arg_3;
                this._musicController.updateVolume(_arg_3);
                this._onDemandSamplePlaybackManager.updateVolume(_arg_2);
            }
        }

        function _Str_24903(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , AccountPreferencesEvent);
            var _local_3= _local_2.getParser() ;
            var _local_4:Float = _local_3.uiVolume;
            if (_local_4 == 1)
            {
                _local_4 = 100;
            }
            this._Str_9171((_local_4 / 100), (_local_3.furniVolume / 100), (_local_3.traxVolume / 100));
        }

        function _Str_23975()
        {
            var k = 0;
            var _local_2:TraxSequencer = null;
            if (((this._loadingSong == null) && (this._loadingSongQueue.length > 0)))
            {
                k = ASCompat.toInt(this._loadingSongQueue.getKey(0));
                _local_2 = this._loadingSongQueue.remove(k);
                if (((!(_local_2 == null)) && (!_local_2.disposed)))
                {
                    this.validateSampleAvailability(_local_2, true);
                    if (_local_2.ready)
                    {
                        events.dispatchEvent(new TraxSongLoadEvent(TraxSongLoadEvent.TSLE_TRAX_LOAD_COMPLETE, k));
                    }
                    else
                    {
                        this._loadingSong = _local_2;
                        this._loadingSongId = k;
                    }
                }
            }
        }

        function onRoomEngineObjectPlaySound(k:Event)
        {
            var _local_2= cast(k, RoomEngineObjectPlaySoundEvent);
            if (k.type == RoomEngineObjectPlaySoundEvent.PLAY_SOUND)
            {
                this.playSound(_local_2.soundId);
            }
            if (k.type == RoomEngineObjectPlaySoundEvent.PLAY_SOUND_AT_PITCH)
            {
                this.playSoundAtPitch(_local_2.soundId, _local_2.pitch);
            }
        }

        public function update(k:UInt)
        {
            if (this._traxSampleManager != null)
            {
                this._traxSampleManager.update(k);
            }
            this._Str_23975();
        }

        public function mute(k:Bool)
        {
            this._muted = k;
            this._Str_9171(this._genericVolume, this._furniVolume, this._traxVolume);
        }
    }

