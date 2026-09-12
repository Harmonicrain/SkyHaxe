package com.sulake.habbo.sound.music
;
    import com.sulake.habbo.sound.IPlayListController;
    import com.sulake.habbo.sound.IHabboMusicController;
    import flash.events.IEventDispatcher;
    import com.sulake.core.communication.connection.IConnection;
    import com.sulake.habbo.sound.HabboSoundManagerFlash10;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.sound.NowPlayingMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.sound.JukeboxSongDisksMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.sound.JukeboxPlayListFullMessageEvent;
    import com.sulake.habbo.sound.events.SoundControllerEvent;
    import com.sulake.habbo.sound.events.SongInfoReceivedEvent;
    import com.sulake.habbo.sound.HabboMusicPrioritiesEnum;
    import com.sulake.habbo.communication.messages.outgoing.sound.GetJukeboxPlayListMessageComposer;
    import com.sulake.habbo.sound.ISongInfo;
    import com.sulake.habbo.sound.events.NowPlayingEvent;
    import com.sulake.habbo.sound.events.PlayListStatusEvent;

     class JukeboxPlayListController implements IPlayListController 
    {
        var _disposed:Bool = false;
        var _isPlaying:Bool = false;
        var _entries:Array<ASAny>;
        var _musicController:IHabboMusicController;
        var _events:IEventDispatcher;
        var _connection:IConnection;
        var _soundManager:HabboSoundManagerFlash10;
        var _currentEntryId:Int = -1;
        var _missingSongInfo:Array<ASAny>;
        var _messageEvents:Array<ASAny>;
        var _playPosition:Int = -1;

        public function new(k:HabboSoundManagerFlash10, _arg_2:HabboMusicController, _arg_3:IEventDispatcher, _arg_4:IConnection)
        {
            var _local_5:IMessageEvent = null;
            this._entries = new Array<ASAny>();
            this._missingSongInfo = new Array<ASAny>();
            this._soundManager = k;
            this._musicController = _arg_2;
            this._events = _arg_3;
            this._connection = _arg_4;
            this._messageEvents = [];
            this._messageEvents.push(new NowPlayingMessageEvent(this._Str_25253));
            this._messageEvents.push(new JukeboxSongDisksMessageEvent(this._Str_24814));
            this._messageEvents.push(new JukeboxPlayListFullMessageEvent(this._Str_22626));
            final _iter_ = this._messageEvents; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_5  = _tmp_;
                this._connection.addMessageEvent(_local_5);
            }
            this._events.addEventListener(SoundControllerEvent.TRAX_SONG_COMPLETE, this.onSongFinishedPlayingEvent);
            this._musicController.events.addEventListener(SongInfoReceivedEvent.SIR_TRAX_SONG_INFO_RECEIVED, this.onSongInfoReceivedEvent);
        }

        public var priority(get,never):Int;
public function  get_priority():Int
        {
            return HabboMusicPrioritiesEnum.PRIORITY_ROOM_PLAYLIST;
        }

        public var nowPlayingSongId(get,never):Int;
public function  get_nowPlayingSongId():Int
        {
            return this._currentEntryId;
        }

        public var playPosition(get,never):Int;
public function  get_playPosition():Int
        {
            return this._playPosition;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var isPlaying(get,never):Bool;
public function  get_isPlaying():Bool
        {
            return this._isPlaying;
        }

        public var length(get,never):Int;
public function  get_length():Int
        {
            if (this._entries == null)
            {
                return 0;
            }
            return this._entries.length;
        }

        public function dispose()
        {
            var k:IMessageEvent = null;
            if (!this._disposed)
            {
                this.stopPlaying();
                if (this._musicController.events != null)
                {
                    this._musicController.events.removeEventListener(SongInfoReceivedEvent.SIR_TRAX_SONG_INFO_RECEIVED, this.onSongInfoReceivedEvent);
                }
                this._musicController = null;
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
                if (this._events != null)
                {
                    this._events.removeEventListener(SoundControllerEvent.TRAX_SONG_COMPLETE, this.onSongFinishedPlayingEvent);
                    this._events = null;
                }
                this._disposed = true;
            }
        }

        public function stopPlaying()
        {
            this._musicController.stop(this.priority);
            this._currentEntryId = -1;
            this._playPosition = -1;
            this._isPlaying = false;
        }

        public function requestPlayList()
        {
            if (this._connection == null)
            {
                return;
            }
            this._connection.send(new GetJukeboxPlayListMessageComposer());
        }

        public function getEntry(k:Int):ISongInfo
        {
            if (((k < 0) || (k >= this._entries.length)))
            {
                return null;
            }
            return this._entries[k];
        }

        function onSongFinishedPlayingEvent(k:SoundControllerEvent)
        {
        }

        function _Str_25253(k:IMessageEvent)
        {
            var _local_2= Std.downcast(k , NowPlayingMessageEvent);
            var _local_3= _local_2.getParser() ;
            Logger.log([((((("Received Now Playing message with: " + Std.string(_local_3.currentSongId)) + ", ") + Std.string(_local_3.nextSongId)) + ", ") + Std.string(_local_3.syncCount))]);
            this._isPlaying = (!(_local_3.currentSongId == -1));
            if (_local_3.currentSongId >= 0)
            {
                this._musicController.playSong(_local_3.currentSongId, HabboMusicPrioritiesEnum.PRIORITY_ROOM_PLAYLIST, (_local_3.syncCount / 1000), 0, 1, 1);
                this._currentEntryId = _local_3.currentSongId;
            }
            else
            {
                this.stopPlaying();
            }
            if (_local_3.nextSongId >= 0)
            {
                this._musicController.addSongInfoRequest(_local_3.nextSongId);
            }
            this._playPosition = _local_3.currentPosition;
            this._soundManager.events.dispatchEvent(new NowPlayingEvent(NowPlayingEvent.NPE_SONG_CHANGED, HabboMusicPrioritiesEnum.PRIORITY_ROOM_PLAYLIST, _local_3.currentSongId, _local_3.currentPosition));
        }

        function _Str_24814(k:IMessageEvent)
        {
            var _local_5 = 0;
            var _local_6 = 0;
            var _local_7:SongDataEntry = null;
            var _local_2= Std.downcast(k , JukeboxSongDisksMessageEvent);
            var _local_3= _local_2.getParser() ;
            Logger.log([("Received Jukebox song disks (=playlist) message, length of playlist: " + Std.string(_local_3._Str_14484.length))]);
            this._entries = new Array<ASAny>();
            var _local_4 = 0;
            while ((_local_4 : UInt) < _local_3._Str_14484.length)
            {
                _local_5 = ASCompat.toInt(_local_3._Str_14484.getWithIndex(_local_4));
                _local_6 = ASCompat.toInt(_local_3._Str_14484.getKey(_local_4));
                _local_7 = Std.downcast(this._musicController.getSongInfo(_local_5) , SongDataEntry);
                if (_local_7 == null)
                {
                    _local_7 = new SongDataEntry(_local_5, -1, null, null, null);
                    if (this._missingSongInfo.indexOf(_local_5) < 0)
                    {
                        this._missingSongInfo.push(_local_5);
                        this._musicController.requestSongInfoWithoutSamples(_local_5);
                    }
                }
                _local_7.diskId = _local_6;
                this._entries.push(_local_7);
                _local_4++;
            }
            if (this._missingSongInfo.length == 0)
            {
                this._events.dispatchEvent(new PlayListStatusEvent(PlayListStatusEvent.PLUE_PLAY_LIST_UPDATED));
            }
        }

        function _Str_22626(k:IMessageEvent)
        {
            Logger.log(["Received jukebox playlist full message."]);
            this._events.dispatchEvent(new PlayListStatusEvent(PlayListStatusEvent.PLUE_PLAY_LIST_FULL));
        }

        function onSongInfoReceivedEvent(k:SongInfoReceivedEvent)
        {
            var _local_4:ISongInfo = null;
            var _local_5 = 0;
            var _local_6:SongDataEntry = null;
            var _local_2 = 0;
            while (_local_2 < this.length)
            {
                _local_4 = this._entries[_local_2];
                if (_local_4.id == k.id)
                {
                    _local_5 = _local_4.diskId;
                    _local_6 = Std.downcast(this._musicController.getSongInfo(k.id) , SongDataEntry);
                    if (_local_6 != null)
                    {
                        _local_6.diskId = _local_5;
                        this._entries[_local_2] = _local_6;
                    }
                    break;
                }
                _local_2++;
            }
            var _local_3= this._missingSongInfo.indexOf(k.id);
            if (_local_3 >= 0)
            {
                this._missingSongInfo.splice(_local_3, 1);
            }
            if (this._missingSongInfo.length == 0)
            {
                this._events.dispatchEvent(new PlayListStatusEvent(PlayListStatusEvent.PLUE_PLAY_LIST_UPDATED));
            }
        }
    }


