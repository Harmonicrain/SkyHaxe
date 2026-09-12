package com.sulake.habbo.room.object.data
;
    import com.sulake.habbo.room.IStuffData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.habbo.room.object.RoomObjectVariableEnum;
    import com.sulake.room.object.IRoomObjectModel;
    import com.sulake.room.object.IRoomObjectModelController;

     class HighScoreStuffData extends StuffDataBase implements IStuffData 
    {
        public static final FORMAT_KEY:Int = StuffDataFormatKeyEnum.HIGH_SCORE_TYPE_KEY;

        var _state:String = "";
        var _scoreType:Int = -1;
        var _clearType:Int = -1;
        var _entries:Vector<HighScoreData>;


        public var scoreType(get,never):Int;
public function  get_scoreType():Int
        {
            return this._scoreType;
        }

        public var clearType(get,never):Int;
public function  get_clearType():Int
        {
            return this._clearType;
        }

        public var entries(get,never):Vector<HighScoreData>;
public function  get_entries():Vector<HighScoreData>
        {
            return this._entries;
        }

        override public function initializeFromIncomingMessage(k:IMessageDataWrapper)
        {
            var highscoredata:HighScoreData = null;
            var amountUsers = 0;
            var iterator2 = 0;
            this._entries = new Vector<HighScoreData>();
            this._state = k.readString();
            this._scoreType = k.readInteger();
            this._clearType = k.readInteger();
            var scoresAmount= k.readInteger();
            var iterator = 0;
            while (iterator < scoresAmount)
            {
                highscoredata = new HighScoreData();
                highscoredata.score = k.readInteger();
                amountUsers= k.readInteger();
                iterator2 = 0;
                while (iterator2 < amountUsers)
                {
                    highscoredata.addUser(k.readString());
                    iterator2++;
                }
                this._entries.push(highscoredata);
                iterator++;
            }
        }

        override public function initializeFromRoomObjectModel(k:IRoomObjectModel)
        {
            var _local_4:HighScoreData = null;
            this._entries = new Vector<HighScoreData>();
            super.initializeFromRoomObjectModel(k);
            this._scoreType = Std.int(k.getNumber(RoomObjectVariableEnum.FURNITURE_HIGHSCORE_SCORE_TYPE));
            this._clearType = Std.int(k.getNumber(RoomObjectVariableEnum.FURNITURE_HIGHSCORE_CLEAR_TYPE));
            var _local_2= Std.int(k.getNumber(RoomObjectVariableEnum.FURNITURE_HIGHSCORE_DATA_ENTRY_COUNT));
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                _local_4 = new HighScoreData();
                _local_4.score = Std.int(k.getNumber((RoomObjectVariableEnum.FURNITURE_HIGHSCORE_DATA_ENTRY_BASE_SCORE_ + Std.string(_local_3))));
                _local_4.users = k.getStringArray((RoomObjectVariableEnum.FURNITURE_HIGHSCORE_DATA_ENTRY_BASE_USERS_ + Std.string(_local_3)));
                this._entries.push(_local_4);
                _local_3++;
            }
        }

        override public function writeRoomObjectModel(k:IRoomObjectModelController)
        {
            var _local_2 = 0;
            var _local_3:HighScoreData = null;
            super.writeRoomObjectModel(k);
            k.setNumber(RoomObjectVariableEnum.FURNITURE_DATA_FORMAT, FORMAT_KEY);
            k.setNumber(RoomObjectVariableEnum.FURNITURE_HIGHSCORE_SCORE_TYPE, this._scoreType);
            k.setNumber(RoomObjectVariableEnum.FURNITURE_HIGHSCORE_CLEAR_TYPE, this._clearType);
            if (this._entries != null)
            {
                k.setNumber(RoomObjectVariableEnum.FURNITURE_HIGHSCORE_DATA_ENTRY_COUNT, this._entries.length);
                _local_2 = 0;
                while (_local_2 < this._entries.length)
                {
                    _local_3 = this._entries[_local_2];
                    k.setNumber((RoomObjectVariableEnum.FURNITURE_HIGHSCORE_DATA_ENTRY_BASE_SCORE_ + Std.string(_local_2)), _local_3.score);
                    k.setStringArray((RoomObjectVariableEnum.FURNITURE_HIGHSCORE_DATA_ENTRY_BASE_USERS_ + Std.string(_local_2)), _local_3.users);
                    _local_2++;
                }
            }
        }

        override public function getLegacyString():String
        {
            return this._state;
        }

	public function new() { super(); }
    }

