package com.sulake.habbo.sound.music
;
    import com.sulake.habbo.sound.IPlayListController;
    import com.sulake.habbo.sound.HabboSoundManagerFlash10;
    import com.sulake.core.communication.connection.IConnection;
    import flash.events.IEventDispatcher;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.sound.PlayListMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.sound.PlayListSongAddedMessageEvent;
    import com.sulake.habbo.sound.events.SoundControllerEvent;
    import com.sulake.habbo.sound.events.SongInfoReceivedEvent;
    import com.sulake.habbo.room.events.RoomObjectSoundMachineEvent;
    import com.sulake.habbo.sound.HabboMusicPrioritiesEnum;
    import flash.events.Event;
    import com.sulake.habbo.sound.ISongInfo;
    import com.sulake.habbo.communication.messages.outgoing.sound.GetSoundMachinePlayListMessageComposer;
    import com.sulake.habbo.communication.messages.incoming.sound.PlayListEntry;
    import com.sulake.habbo.sound.events.PlayListStatusEvent;
    import com.sulake.habbo.sound.*;

     class SoundMachinePlayListController implements IPlayListController 
    {
        var _soundManager:HabboSoundManagerFlash10;
        var _musicController:HabboMusicController;
        var _connection:IConnection;
        var _events:IEventDispatcher;
        var _roomEvents:IEventDispatcher;
        var _currentEntryId:Int = -1;
        var _playListEntries:Array<ASAny>;
        var _isPlaying:Bool = false;
        var _disposed:Bool = false;
        var _messageEvents:Array<ASAny>;

        public function new(k:HabboSoundManagerFlash10, _arg_2:HabboMusicController, _arg_3:IEventDispatcher, _arg_4:IEventDispatcher, _arg_5:IConnection)
        {
            var _local_6:IMessageEvent = null;
            this._playListEntries = new Array<ASAny>();
            this._soundManager = k;
            this._events = _arg_3;
            this._roomEvents = _arg_4;
            this._connection = _arg_5;
            this._musicController = _arg_2;
            this._messageEvents = [];
            this._messageEvents.push(new PlayListMessageEvent(this.onPlayListMessage));
            this._messageEvents.push(new PlayListSongAddedMessageEvent(this.onPlayListSongAddedMessage));
            final _iter_ = this._messageEvents; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_6  = _tmp_;
                this._connection.addMessageEvent(_local_6);
            }
            this._events.addEventListener(SoundControllerEvent.TRAX_SONG_COMPLETE, this.onSongFinishedPlayingEvent);
            this._events.addEventListener(SongInfoReceivedEvent.SIR_TRAX_SONG_INFO_RECEIVED, this.onSongInfoReceivedEvent);
            this._roomEvents.addEventListener(RoomObjectSoundMachineEvent.SOUND_MACHINE_SWITCHED_ON, this.onSoundMachinePlayEvent);
            this._roomEvents.addEventListener(RoomObjectSoundMachineEvent.SOUND_MACHINE_SWITCHED_OFF, this.onSoundMachineStopEvent);
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var priority(get,never):Int;
public function  get_priority():Int
        {
            return HabboMusicPrioritiesEnum.PRIORITY_ROOM_PLAYLIST;
        }

        public var length(get,never):Int;
public function  get_length():Int
        {
            if (this._playListEntries == null)
            {
                return 0;
            }
            return this._playListEntries.length;
        }

        
        public var playPosition(get,set):Int;
public function  get_playPosition():Int
        {
            return -1;
        }

        public var nowPlayingSongId(get,never):Int;
public function  get_nowPlayingSongId():Int
        {
            return this._currentEntryId;
        }

        public var isPlaying(get,never):Bool;
public function  get_isPlaying():Bool
        {
            return this._isPlaying;
        }
public function  set_playPosition(k:Int):Int        {
return k;
        }

        public function dispose()
        {
            var k:IMessageEvent = null;
            if (!this._disposed)
            {
                if (this._isPlaying)
                {
                    this.stopPlaying();
                }
                this._soundManager = null;
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
                this._playListEntries = null;
                this._musicController = null;
                if (this._events != null)
                {
                    this._events.removeEventListener(SoundControllerEvent.TRAX_SONG_COMPLETE, this.onSongFinishedPlayingEvent);
                    this._events = null;
                }
                if (this._roomEvents != null)
                {
                    this._roomEvents.removeEventListener(RoomObjectSoundMachineEvent.SOUND_MACHINE_SWITCHED_ON, this.onSoundMachinePlayEvent);
                    this._roomEvents.removeEventListener(RoomObjectSoundMachineEvent.SOUND_MACHINE_SWITCHED_OFF, this.onSoundMachineStopEvent);
                    this._roomEvents = null;
                }
                this._disposed = true;
            }
        }

        function onSoundMachinePlayEvent(k:Event)
        {
            this.startPlaying();
        }

        function onSoundMachineStopEvent(k:Event)
        {
            this.stopPlaying();
        }

        public function startPlaying()
        {
            if (this._isPlaying)
            {
                return;
            }
            if (((this._playListEntries == null) || (this._playListEntries.length == 0)))
            {
                this.requestPlayList();
                this._isPlaying = true;
                return;
            }
            this.stopPlaying();
            this._currentEntryId = -1;
            this._isPlaying = true;
            this.playNextSong();
        }

        public function checkSongPlayState(k:Int)
        {
            var _local_2:SongDataEntry = null;
            if (this._currentEntryId == k)
            {
                this.playCurrentSongAndNotify(this._currentEntryId);
                _local_2 = this.getNextEntry();
                if (_local_2 != null)
                {
                    this._musicController.addSongInfoRequest(_local_2.id);
                }
            }
        }

        public function stopPlaying()
        {
            this._currentEntryId = -1;
            this._isPlaying = false;
            this._musicController.stop(HabboMusicPrioritiesEnum.PRIORITY_ROOM_PLAYLIST);
        }

        public function updateVolume(k:Float)
        {
        }

        public function addItem(k:ISongInfo, _arg_2:Int=0):Int
        {
            return -1;
        }

        public function moveItem(k:Int, _arg_2:Int)
        {
        }

        public function removeItem(k:Int)
        {
        }

        function onSongFinishedPlayingEvent(k:SoundControllerEvent)
        {
            if (k.id == this._currentEntryId)
            {
                this.playNextSong();
            }
        }

        function onSongInfoReceivedEvent(k:SongInfoReceivedEvent)
        {
            var _local_2:SongDataEntry = null;
            var _local_4:SongDataEntry = null;
            if (((this._playListEntries == null) || (this._playListEntries.length == 0)))
            {
                return;
            }
            var _local_3 = 0;
            while (_local_3 < this._playListEntries.length)
            {
                _local_2 = this._playListEntries[_local_3];
                if (_local_2.id == k.id)
                {
                    _local_4 = Std.downcast(this._musicController.getSongInfo(k.id) , SongDataEntry);
                    if (_local_4 != null)
                    {
                        this._playListEntries[_local_3] = _local_4;
                    }
                    return;
                }
                _local_3++;
            }
        }

        function playNextSong()
        {
            var k= this.getNextEntry();
            if (k != null)
            {
                this._currentEntryId = k.id;
                this.playCurrentSongAndNotify(this._currentEntryId);
            }
        }

        function playCurrentSongAndNotify(k:Int)
        {
            var _local_2= Std.downcast(this.getEntryWithId(k) , SongDataEntry);
            if (_local_2 == null)
            {
                return;
            }
            var _local_3= _local_2.startPlayHeadPos;
            _local_2.startPlayHeadPos = 0;
            if (this._musicController.playSong(k, HabboMusicPrioritiesEnum.PRIORITY_ROOM_PLAYLIST, _local_3, 0, 0, 0))
            {
                Logger.log([((("Trax song started by playlist: " + _local_2.name) + " by ") + _local_2.creator)]);
            }
        }

        function getNextEntry():SongDataEntry
        {
            var _local_2:SongDataEntry = null;
            if (((this._playListEntries == null) || (this._playListEntries.length == 0)))
            {
                return null;
            }
            var k = 0;
            var _local_3 = 0;
            while (_local_3 < this._playListEntries.length)
            {
                _local_2 = this._playListEntries[_local_3];
                if (_local_2.id == this._currentEntryId)
                {
                    k = (_local_3 + 1);
                }
                _local_3++;
            }
            if (k >= this._playListEntries.length)
            {
                k = 0;
            }
            _local_2 = this._playListEntries[k];
            return _local_2;
        }

        public function getEntry(k:Int):ISongInfo
        {
            if ((((this._playListEntries == null) || (k < 0)) || (k >= this._playListEntries.length)))
            {
                return null;
            }
            return this._playListEntries[k];
        }

        public function getEntryWithId(k:Int):ISongInfo
        {
            var _local_2:SongDataEntry = null;
            if (((this._playListEntries == null) || (this._playListEntries.length == 0)))
            {
                return null;
            }
            var _local_3 = 0;
            while (_local_3 < this._playListEntries.length)
            {
                _local_2 = this._playListEntries[_local_3];
                if (_local_2.id == k)
                {
                    return _local_2;
                }
                _local_3++;
            }
            return null;
        }

        public function requestPlayList()
        {
            if (this._connection == null)
            {
                return;
            }
            this._connection.send(new GetSoundMachinePlayListMessageComposer());
        }

        function convertParserPlayList(k:Array<ASAny>):Array<ASAny>
        {
            var _local_3:PlayListEntry = null;
            var _local_2= new Array<ASAny>();
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_3  = _tmp_;
                _local_2.push(new SongDataEntry(_local_3.id, _local_3.length, _local_3.name, _local_3.creator, null));
            }
            return _local_2;
        }

        function onPlayListMessage(k:IMessageEvent)
        {
            var _local_6:SongDataEntry = null;
            var _local_8 = 0;
            var _local_2= Std.downcast(k , PlayListMessageEvent);
            var _local_3= _local_2.getParser() ;
            var _local_4= _local_3.synchronizationCount;
            var _local_5= this.convertParserPlayList(_local_3.playList);
            if (((_local_5 == null) || (_local_5.length == 0)))
            {
                return;
            }
            this._playListEntries = _local_5;
            var _local_7 = 0;
            _local_8 = 0;
            while (_local_8 < _local_5.length)
            {
                _local_6 = this._playListEntries[_local_8];
                _local_7 = (_local_7 + _local_6.length);
                _local_8++;
            }
            if (_local_4 < 0)
            {
                _local_4 = 0;
            }
            _local_4 = (_local_4 % _local_7);
            _local_8 = 0;
            while (_local_8 < _local_5.length)
            {
                _local_6 = this._playListEntries[_local_8];
                if (_local_4 > _local_6.length)
                {
                    _local_4 = (_local_4 - _local_6.length);
                }
                else
                {
                    this._currentEntryId = _local_6.id;
                    _local_6.startPlayHeadPos = (_local_4 / 1000);
                    break;
                }
                _local_8++;
            }
            this._events.dispatchEvent(new PlayListStatusEvent(PlayListStatusEvent.PLUE_PLAY_LIST_UPDATED));
            if (((!(_local_6 == null)) && this._isPlaying))
            {
                this.playCurrentSongAndNotify(_local_6.id);
            }
        }

        function onPlayListSongAddedMessage(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , PlayListSongAddedMessageEvent);
            var _local_3= _local_2.getParser() ;
            var _local_4= new SongDataEntry(_local_3.entry.id, _local_3.entry.length, _local_3.entry.name, _local_3.entry.creator, null);
            if (_local_4 == null)
            {
                return;
            }
            this._playListEntries.push(_local_4);
            this._events.dispatchEvent(new PlayListStatusEvent(PlayListStatusEvent.PLUE_PLAY_LIST_UPDATED));
            if (!this._isPlaying)
            {
                return;
            }
            if (this._playListEntries.length == 1)
            {
                this.playCurrentSongAndNotify(_local_4.id);
            }
            else
            {
                this.checkSongPlayState(_local_4.id);
            }
        }
    }

