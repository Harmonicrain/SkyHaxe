package com.sulake.habbo.sound.music
;
    import com.sulake.habbo.sound.IHabboMusicController;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.sound.HabboMusicPrioritiesEnum;
    import com.sulake.habbo.sound.HabboSoundManagerFlash10;
    import com.sulake.core.communication.connection.IConnection;
    import flash.events.IEventDispatcher;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.sound.IPlayListController;
    import flash.utils.Timer;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.sound.TraxSongInfoMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.sound.UserSongDisksInventoryMessageEvent;
    import com.sulake.habbo.room.events.RoomObjectSoundMachineEvent;
    import flash.events.TimerEvent;
    import com.sulake.habbo.sound.events.SoundControllerEvent;
    import com.sulake.habbo.sound.events.NowPlayingEvent;
    import com.sulake.habbo.sound.IHabboSound;
    import com.sulake.habbo.sound.ISongInfo;
    import com.sulake.habbo.communication.messages.outgoing.sound.GetUserSongDisksMessageComposer;
    import com.sulake.habbo.sound.trax.TraxSequencer;
    import com.sulake.habbo.communication.messages.outgoing.sound.GetSongInfoMessageComposer;
    import com.sulake.habbo.communication.messages.incoming.sound.SongInfoEntry;
    import com.sulake.habbo.sound.events.SongInfoReceivedEvent;
    import com.sulake.habbo.sound.events.SongDiskInventoryReceivedEvent;
    import flash.events.Event;
    import com.sulake.habbo.communication.messages.outgoing.sound.GetNowPlayingMessageComposer;
    import com.sulake.habbo.sound.*;

     class HabboMusicController implements IHabboMusicController implements  IDisposable 
    {
        public static inline final SKIP_POSITION_SET= -1;
        static final MAXIMUM_NOTIFY_PRIORITY:Int = HabboMusicPrioritiesEnum.PRIORITY_ROOM_PLAYLIST;//0

        var _soundManager:HabboSoundManagerFlash10;
        var _connection:IConnection;
        var _events:IEventDispatcher;
        var _roomEvents:IEventDispatcher;
        var _availableSongs:Map;
        var _requestedSongs:Map;
        var _songRequestList:Array<ASAny>;
        var _roomItemPlaylist:IPlayListController = null;
        var _disposed:Bool = false;
        var _songRequestsPerPriority:Array<ASAny>;
        var _songRequestCountsPerPriority:Array<ASAny>;
        var _priorityPlaying:Int = -1;
        var _songIdPlaying:Int = -1;
        var _requestNumberPlaying:Int = -1;
        var _songRequestTimer:Timer;
        var _songDiskInventory:Map;
        var _diskInventoryMissingData:Array<ASAny>;
        var _messageEvents:Array<ASAny>;
        var _previousNotifiedSongId:Int = -1;
        var _previousNotificationTime:Int = -1;

        public function new(k:HabboSoundManagerFlash10, _arg_2:IEventDispatcher, _arg_3:IEventDispatcher, _arg_4:IConnection)
        {
            var _local_5:IMessageEvent = null;
            var _local_6 = 0;
            this._availableSongs = new Map();
            this._requestedSongs = new Map();
            this._songRequestList = new Array<ASAny>();
            this._songRequestsPerPriority = [];
            this._songRequestCountsPerPriority = [];
            this._songDiskInventory = new Map();
            this._diskInventoryMissingData = new Array<ASAny>();
            this._messageEvents = [];
            this._soundManager = k;
            this._events = _arg_2;
            this._roomEvents = _arg_3;
            this._connection = _arg_4;
            this._messageEvents.push(new TraxSongInfoMessageEvent(this.onSongInfoMessage));
            this._messageEvents.push(new UserSongDisksInventoryMessageEvent(this.onSongDiskInventoryMessage));
            final _iter_ = this._messageEvents; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_5  = _tmp_;
                this._connection.addMessageEvent(_local_5);
            }
            this._roomEvents.addEventListener(RoomObjectSoundMachineEvent.JUKEBOX_INIT, this.onJukeboxInit);
            this._roomEvents.addEventListener(RoomObjectSoundMachineEvent.JUKEBOX_DISPOSE, this.onJukeboxDispose);
            this._roomEvents.addEventListener(RoomObjectSoundMachineEvent.SOUND_MACHINE_INIT, this.onSoundMachineInit);
            this._roomEvents.addEventListener(RoomObjectSoundMachineEvent.SOUND_MACHINE_DISPOSE, this.onSoundMachineDispose);
            this._songRequestTimer = new Timer(1000);
            this._songRequestTimer.start();
            this._songRequestTimer.addEventListener(TimerEvent.TIMER, (this.onTimerEvent : ASAny));
            this._events.addEventListener(SoundControllerEvent.TRAX_SONG_COMPLETE, this.onTraxSongComplete);
            _local_6 = 0;
            while (_local_6 < HabboMusicPrioritiesEnum.PRIORITY_COUNT)
            {
                this._songRequestsPerPriority[_local_6] = null;
                this._songRequestCountsPerPriority[_local_6] = 0;
                _local_6++;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var events(get,never):IEventDispatcher;
public function  get_events():IEventDispatcher
        {
            return this._events;
        }

        function onTraxSongComplete(k:SoundControllerEvent)
        {
            var _local_2 = 0;
            Logger.log([(("Song " + Std.string(k.id)) + " finished playing")]);
            if (this.getSongIdPlayingAtPriority(this._priorityPlaying) == k.id)
            {
                if (((this.getTopRequestPriority() == this._priorityPlaying) && (this.getSongRequestCountAtPriority(this._priorityPlaying) == this._requestNumberPlaying)))
                {
                    this.resetSongStartRequest(this._priorityPlaying);
                }
                _local_2 = this._priorityPlaying;
                this.playSongWithHighestPriority();
                if (_local_2 >= HabboMusicPrioritiesEnum.PRIORITY_SONG_PLAY)
                {
                    this._events.dispatchEvent(new NowPlayingEvent(NowPlayingEvent.NPW_USER_STOP_SONG, _local_2, k.id, -1));
                }
            }
        }

        public function dispose()
        {
            var k:IMessageEvent = null;
            var _local_2 = 0;
            var _local_3:SongDataEntry = null;
            var _local_4:IHabboSound = null;
            if (!this._disposed)
            {
                this._soundManager = null;
                this._songRequestList = null;
                if (this._connection != null)
                {
                    final _iter_ = this._messageEvents; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                    {
k  = _tmp_;
                        this._connection.removeMessageEvent(k);
                        k.dispose();
                    }
                    this._messageEvents = null;
                    this._connection = null;
                }
                if (this._roomItemPlaylist != null)
                {
                    this._roomItemPlaylist.dispose();
                    this._roomItemPlaylist = null;
                }
                if (this._availableSongs != null)
                {
                    _local_2 = 0;
                    while ((_local_2 : UInt) < this._availableSongs.length)
                    {
                        _local_3 = ASCompat.dynamicAs(this._availableSongs.getWithIndex(_local_2) , SongDataEntry);
                        _local_4 = _local_3.soundObject ;
                        if (_local_4 != null)
                        {
                            _local_4.stop();
                        }
                        _local_3.soundObject = null;
                        _local_2++;
                    }
                    this._availableSongs.dispose();
                    this._availableSongs = null;
                }
                if (this._requestedSongs != null)
                {
                    this._requestedSongs.dispose();
                    this._requestedSongs = null;
                }
                this._songRequestTimer.stop();
                this._songRequestTimer = null;
                if (this._roomEvents != null)
                {
                    this._roomEvents.removeEventListener(RoomObjectSoundMachineEvent.JUKEBOX_INIT, this.onJukeboxInit);
                    this._roomEvents.removeEventListener(RoomObjectSoundMachineEvent.JUKEBOX_DISPOSE, this.onJukeboxDispose);
                    this._roomEvents.removeEventListener(RoomObjectSoundMachineEvent.SOUND_MACHINE_INIT, this.onSoundMachineInit);
                    this._roomEvents.removeEventListener(RoomObjectSoundMachineEvent.SOUND_MACHINE_DISPOSE, this.onSoundMachineDispose);
                }
                if (this._songDiskInventory != null)
                {
                    this._songDiskInventory.dispose();
                    this._songDiskInventory = null;
                }
                this._disposed = true;
            }
        }

        public function getRoomItemPlaylist(k:Int=-1):IPlayListController
        {
            return this._roomItemPlaylist;
        }

        function addSongStartRequest(k:Int, _arg_2:Int, _arg_3:Float, _arg_4:Float, _arg_5:Float, _arg_6:Float):Bool
        {
            if (((k < 0) || (k >= HabboMusicPrioritiesEnum.PRIORITY_COUNT)))
            {
                return false;
            }
            var _local_7= new SongStartRequestData(_arg_2, _arg_3, _arg_4, _arg_5, _arg_6);
            this._songRequestsPerPriority[k] = _local_7;
            this._songRequestCountsPerPriority[k] = (this._songRequestCountsPerPriority[k] + 1);
            return true;
        }

        function getSongStartRequest(k:Int):SongStartRequestData
        {
            return this._songRequestsPerPriority[k];
        }

        function getSongIdRequestedAtPriority(k:Int):Int
        {
            if (((k < 0) || (k >= HabboMusicPrioritiesEnum.PRIORITY_COUNT)))
            {
                return -1;
            }
            if (this._songRequestsPerPriority[k] == null)
            {
                return -1;
            }
            var _local_2:SongStartRequestData = this._songRequestsPerPriority[k];
            return _local_2.songId;
        }

        function getSongRequestCountAtPriority(k:Int):Int
        {
            if (((k < 0) || (k >= HabboMusicPrioritiesEnum.PRIORITY_COUNT)))
            {
                return -1;
            }
            return ASCompat.toInt(this._songRequestCountsPerPriority[k]);
        }

        function getTopRequestPriority():Int
        {
            var k= (this._songRequestsPerPriority.length - 1);
            while (k >= 0)
            {
                if (this._songRequestsPerPriority[k] != null)
                {
                    return k;
                }
                k--;
            }
            return -1;
        }

        function resetSongStartRequest(k:Int)
        {
            if (((k >= 0) && (k < HabboMusicPrioritiesEnum.PRIORITY_COUNT)))
            {
                this._songRequestsPerPriority[k] = null;
            }
        }

        function reRequestSongAtPriority(k:Int)
        {
            this._songRequestCountsPerPriority[k] = (this._songRequestCountsPerPriority[k] + 1);
        }

        function processSongEntryForPlaying(k:Int, _arg_2:Bool=true):Bool
        {
            var _local_3= this.getSongDataEntry(k);
            if (_local_3 == null)
            {
                this.addSongInfoRequest(k);
                return false;
            }
            if (_local_3.soundObject == null)
            {
                _local_3.soundObject = this._soundManager.loadTraxSong(_local_3.id, _local_3.songData);
            }
            var _local_4= _local_3.soundObject;
            if (!_local_4.ready)
            {
                return false;
            }
            return true;
        }

        public function playSong(k:Int, _arg_2:Int, _arg_3:Float=0, _arg_4:Float=0, _arg_5:Float=0.5, _arg_6:Float=0.5):Bool
        {
            Logger.log([(("Requesting " + Std.string(k)) + " for playing")]);
            if (!this.addSongStartRequest(_arg_2, k, _arg_3, _arg_4, _arg_5, _arg_6))
            {
                return false;
            }
            if (!this.processSongEntryForPlaying(k))
            {
                return false;
            }
            if (_arg_2 >= this._priorityPlaying)
            {
                this.playSongObject(_arg_2, k);
            }
            else
            {
                Logger.log([((("Higher priority song blocked playing. Stored song " + Std.string(k)) + " for priority ") + Std.string(_arg_2))]);
            }
            return true;
        }

        function playSongWithHighestPriority()
        {
            var _local_3 = 0;
            this._priorityPlaying = -1;
            this._songIdPlaying = -1;
            this._requestNumberPlaying = -1;
            var k= this.getTopRequestPriority();
            var _local_2= k;
            while (_local_2 >= 0)
            {
                _local_3 = this.getSongIdRequestedAtPriority(_local_2);
                if (((_local_3 >= 0) && this.playSongObject(_local_2, _local_3)))
                {
                    return;
                }
                _local_2--;
            }
        }

        public function stop(k:Int)
        {
            var _local_2:ASAny = (k == this._priorityPlaying);
            var _local_3:ASAny = (this.getTopRequestPriority() == k);
            if (_local_2)
            {
                this.resetSongStartRequest(k);
                this.stopSongAtPriority(k);
            }
            else
            {
                this.resetSongStartRequest(k);
                if (_local_3)
                {
                    this.reRequestSongAtPriority(this._priorityPlaying);
                }
            }
        }

        function stopSongAtPriority(k:Int):Bool
        {
            var _local_2 = 0;
            var _local_3:SongDataEntry = null;
            if (((k == this._priorityPlaying) && (this._priorityPlaying >= 0)))
            {
                _local_2 = this.getSongIdPlayingAtPriority(k);
                if (_local_2 >= 0)
                {
                    _local_3 = this.getSongDataEntry(_local_2);
                    this.stopSongDataEntry(_local_3);
                    return true;
                }
            }
            return false;
        }

        function stopSongDataEntry(k:SongDataEntry)
        {
            var _local_2:IHabboSound = null;
            if (k != null)
            {
                Logger.log([("Stopping current song " + Std.string(k.id))]);
                _local_2 = k.soundObject;
                if (_local_2 != null)
                {
                    _local_2.stop();
                }
            }
        }

        function getSongDataEntry(k:Int):SongDataEntry
        {
            var _local_2:SongDataEntry = null;
            if (this._availableSongs != null)
            {
                _local_2 = ASCompat.dynamicAs(this._availableSongs.getValue(k) , SongDataEntry);
            }
            return _local_2;
        }

        public function updateVolume(k:Float)
        {
            var _local_3 = 0;
            var _local_4:SongDataEntry = null;
            var _local_2 = 0;
            while (_local_2 < HabboMusicPrioritiesEnum.PRIORITY_COUNT)
            {
                _local_3 = this.getSongIdPlayingAtPriority(_local_2);
                if (_local_3 >= 0)
                {
                    _local_4 = this.getSongDataEntry(_local_3) ;
                    if (((!(_local_4 == null)) && (!(_local_4.soundObject == null))))
                    {
                        _local_4.soundObject.volume = k;
                    }
                }
                _local_2++;
            }
        }

        public function onSongLoaded(k:Int)
        {
            var _local_3 = 0;
            Logger.log([("Song loaded : " + Std.string(k))]);
            var _local_2= this.getTopRequestPriority();
            if (_local_2 >= 0)
            {
                _local_3 = this.getSongIdRequestedAtPriority(_local_2);
                if (k == _local_3)
                {
                    this.playSongObject(_local_2, k);
                }
            }
        }

        public function addSongInfoRequest(k:Int)
        {
            this.requestSong(k, true);
        }

        public function requestSongInfoWithoutSamples(k:Int)
        {
            this.requestSong(k, false);
        }

        function requestSong(k:Int, _arg_2:Bool)
        {
            if (this._requestedSongs.getValue(k) == null)
            {
                this._requestedSongs.add(k, _arg_2);
                this._songRequestList.push(k);
            }
        }

        public function getSongInfo(k:Int):ISongInfo
        {
            var _local_2= this.getSongDataEntry(k);
            if (_local_2 == null)
            {
                this.requestSongInfoWithoutSamples(k);
            }
            return _local_2;
        }

        public function requestUserSongDisks()
        {
            if (this._connection == null)
            {
                return;
            }
            this._connection.send(new GetUserSongDisksMessageComposer());
        }

        public function getSongDiskInventorySize():Int
        {
            return ASCompat.toInt(this._songDiskInventory.length);
        }

        public function getSongDiskInventoryDiskId(k:Int):Int
        {
            if (((k >= 0) && ((k : UInt) < this._songDiskInventory.length)))
            {
                return ASCompat.toInt(this._songDiskInventory.getKey(k));
            }
            return -1;
        }

        public function getSongDiskInventorySongId(k:Int):Int
        {
            if (((k >= 0) && ((k : UInt) < this._songDiskInventory.length)))
            {
                return ASCompat.toInt(this._songDiskInventory.getWithIndex(k));
            }
            return -1;
        }

        public function getSongIdPlayingAtPriority(k:Int):Int
        {
            if (k != this._priorityPlaying)
            {
                return -1;
            }
            return this._songIdPlaying;
        }

        public function samplesUnloaded(k:Array<ASAny>)
        {
            var _local_3:SongDataEntry = null;
            var _local_4:TraxSequencer = null;
            var _local_5:Array<ASAny> = null;
            var _local_6 = 0;
            var _local_2 = 0;
            while ((_local_2 : UInt) < this._availableSongs.length)
            {
                _local_3 = ASCompat.dynamicAs(this._availableSongs.getWithIndex(_local_2) , SongDataEntry);
                _local_4 = Std.downcast(_local_3.soundObject , TraxSequencer);
                if ((((!(_local_3.id == this._songIdPlaying)) && (!(_local_4 == null))) && _local_4.ready))
                {
                    _local_5 = _local_4.traxData.getSampleIds();
                    _local_6 = 0;
                    while (_local_6 < k.length)
                    {
                        if (_local_5.indexOf(k[_local_6]) != -1)
                        {
                            _local_3.soundObject = null;
                            _local_4.dispose();
                            Logger.log([((("Unloaded " + _local_3.name) + " by ") + _local_3.creator)]);
                        }
                        _local_6++;
                    }
                }
                _local_2++;
            }
        }

        public var samplesIdsInUse(get,never):Array<ASAny>;
public function  get_samplesIdsInUse():Array<ASAny>
        {
            var _local_3:SongStartRequestData = null;
            var _local_4:SongDataEntry = null;
            var _local_5:TraxSequencer = null;
            var k:Array<ASAny> = [];
            var _local_2 = 0;
            while (_local_2 < this._songRequestsPerPriority.length)
            {
                if (this._songRequestsPerPriority[_local_2] != null)
                {
                    _local_3 = this._songRequestsPerPriority[_local_2];
                    _local_4 = this._availableSongs.getValue(_local_3.songId);
                    if (_local_4 != null)
                    {
                        _local_5 = Std.downcast(_local_4.soundObject , TraxSequencer);
                        if (_local_5 != null)
                        {
                            k = k.concat(_local_5.traxData.getSampleIds());
                        }
                    }
                }
                _local_2++;
            }
            return k;
        }

        function onTimerEvent(k:TimerEvent)
        {
            if (this._songRequestList.length < 1)
            {
                return;
            }
            if (this._connection == null)
            {
                return;
            }
            this._connection.send(new GetSongInfoMessageComposer(this._songRequestList));
            Logger.log([("Requested song info's : " + ASCompat.toString(this._songRequestList))]);
            this._songRequestList = new Array<ASAny>();
        }

        function onSongInfoMessage(k:IMessageEvent)
        {
            var _local_6:SongInfoEntry = null;
            var _local_7 = false;
            var _local_8 = false;
            var _local_9:IHabboSound = null;
            var _local_10:SongDataEntry = null;
            var _local_11 = 0;
            var _local_12 = 0;
            var _local_2= Std.downcast(k , TraxSongInfoMessageEvent);
            var _local_3= _local_2.getParser() ;
            var _local_4= _local_3.songs;
            var _local_5 = 0;
            while (_local_5 < _local_4.length)
            {
                _local_6 = _local_4[_local_5];
                _local_7 = (this.getSongDataEntry(_local_6.id) == null);
                _local_8 = this.areSamplesRequested(_local_6.id);
                if (_local_7)
                {
                    _local_9 = null;
                    if (_local_8)
                    {
                        _local_9 = this._soundManager.loadTraxSong(_local_6.id, _local_6.data);
                    }
                    _local_10 = new SongDataEntry(_local_6.id, _local_6.length, _local_6.name, _local_6.creator, _local_9);
                    _local_10.songData = _local_6.data;
                    this._availableSongs.add(_local_6.id, _local_10);
                    _local_11 = this.getTopRequestPriority();
                    _local_12 = this.getSongIdRequestedAtPriority(_local_11);
                    if ((((!(_local_9 == null)) && _local_9.ready) && (_local_6.id == _local_12)))
                    {
                        this.playSongObject(_local_11, _local_12);
                    }
                    this._events.dispatchEvent(new SongInfoReceivedEvent(SongInfoReceivedEvent.SIR_TRAX_SONG_INFO_RECEIVED, _local_6.id));
                    while (this._diskInventoryMissingData.indexOf(_local_6.id) != -1)
                    {
                        this._diskInventoryMissingData.splice(this._diskInventoryMissingData.indexOf(_local_6.id), 1);
                        if (this._diskInventoryMissingData.length == 0)
                        {
                            this._events.dispatchEvent(new SongDiskInventoryReceivedEvent(SongDiskInventoryReceivedEvent.SDIR_SONG_DISK_INVENTORY_RECEIVENT_EVENT));
                        }
                    }
                    Logger.log([("Received song info : " + Std.string(_local_6.id))]);
                }
                _local_5++;
            }
        }

        function playSongObject(k:Int, _arg_2:Int):Bool
        {
            if ((((_arg_2 == -1) || (k < 0)) || (k >= HabboMusicPrioritiesEnum.PRIORITY_COUNT)))
            {
                return false;
            }
            var _local_3 = false;
            if (this.stopSongAtPriority(this._priorityPlaying))
            {
                _local_3 = true;
            }
            var _local_4= this.getSongDataEntry(_arg_2);
            if (_local_4 == null)
            {
                Logger.log([(("WARNING: Unable to find song entry id " + Std.string(_arg_2)) + " that was supposed to be loaded.")]);
                return false;
            }
            var _local_5= _local_4.soundObject;
            if (((_local_5 == null) || (!_local_5.ready)))
            {
                return false;
            }
            if (_local_3)
            {
                Logger.log([("Waiting previous song to stop before playing song " + Std.string(_arg_2))]);
                return true;
            }
            _local_5.volume = this._soundManager.traxVolume;
            var _local_6:Float = SKIP_POSITION_SET;
            var _local_7:Float = 0;
            var _local_8:Float = 2;
            var _local_9:Float = 1;
            var _local_10= this.getSongStartRequest(k);
            if (_local_10 != null)
            {
                _local_6 = _local_10.startPos;
                _local_7 = _local_10.playLength;
                _local_8 = _local_10.fadeInSeconds;
                _local_9 = _local_10.fadeOutSeconds;
            }
            if (_local_6 >= (_local_4.length / 1000))
            {
                return false;
            }
            if (_local_6 == SKIP_POSITION_SET)
            {
                _local_6 = 0;
            }
            _local_5.fadeInSeconds = _local_8;
            _local_5.fadeOutSeconds = _local_9;
            _local_5.position = _local_6;
            _local_5.play(_local_7);
            this._priorityPlaying = k;
            this._requestNumberPlaying = this.getSongRequestCountAtPriority(k);
            this._songIdPlaying = _arg_2;
            if (this._priorityPlaying <= MAXIMUM_NOTIFY_PRIORITY)
            {
                this.notifySongPlaying(_local_4);
            }
            if (k > HabboMusicPrioritiesEnum.PRIORITY_ROOM_PLAYLIST)
            {
                this._events.dispatchEvent(new NowPlayingEvent(NowPlayingEvent.NPE_USER_PLAY_SONG, k, _local_4.id, -1));
            }
            Logger.log([((((((((("Started playing song " + Std.string(_arg_2)) + " at position ") + Std.string(_local_6)) + " for ") + Std.string(_local_7)) + " seconds (length ") + Std.string(_local_4.length / 1000)) + ") with priority ") + Std.string(k))]);
            return true;
        }

        function notifySongPlaying(k:SongDataEntry)
        {
            var _local_2:ASAny = 8000;
            var _local_3= flash.Lib.getTimer();
            if (((k.length >= _local_2) && ((!(this._previousNotifiedSongId == k.id)) || (_local_3 > (this._previousNotificationTime + _local_2)))))
            {
                this._soundManager._Str_22895(k.name, k.creator);
                this._previousNotifiedSongId = k.id;
                this._previousNotificationTime = _local_3;
            }
        }

        function areSamplesRequested(k:Int):Bool
        {
            if (this._requestedSongs.getValue(k) == null)
            {
                return false;
            }
            return this._requestedSongs.getValue(k);
        }

        function onSongDiskInventoryMessage(k:IMessageEvent)
        {
            var _local_5 = 0;
            var _local_6 = 0;
            var _local_2= Std.downcast(k , UserSongDisksInventoryMessageEvent);
            var _local_3= _local_2.getParser() ;
            this._songDiskInventory.reset();
            var _local_4 = 0;
            while (_local_4 < _local_3._Str_22284)
            {
                _local_5 = _local_3._Str_23874(_local_4);
                _local_6 = _local_3._Str_24056(_local_4);
                this._songDiskInventory.add(_local_5, _local_6);
                if (this._availableSongs.getValue(_local_6) == null)
                {
                    this._diskInventoryMissingData.push(_local_6);
                    this.requestSongInfoWithoutSamples(_local_6);
                }
                _local_4++;
            }
            if (this._diskInventoryMissingData.length == 0)
            {
                this._events.dispatchEvent(new SongDiskInventoryReceivedEvent(SongDiskInventoryReceivedEvent.SDIR_SONG_DISK_INVENTORY_RECEIVENT_EVENT));
            }
        }

        function onSoundMachineInit(k:Event)
        {
            this.disposeRoomPlaylist();
            this._roomItemPlaylist = new SoundMachinePlayListController(this._soundManager, this, this._events, this._roomEvents, this._connection) ;
        }

        function onSoundMachineDispose(k:Event)
        {
            this.disposeRoomPlaylist();
        }

        function onJukeboxInit(k:Event)
        {
            this.disposeRoomPlaylist();
            this._roomItemPlaylist = new JukeboxPlayListController(this._soundManager, this, this._events, this._connection) ;
            this._connection.send(new GetNowPlayingMessageComposer());
        }

        function onJukeboxDispose(k:Event)
        {
            this.disposeRoomPlaylist();
        }

        function disposeRoomPlaylist()
        {
            if (this._roomItemPlaylist != null)
            {
                this._roomItemPlaylist.dispose();
                this._roomItemPlaylist = null;
            }
        }
    }

