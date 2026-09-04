package com.sulake.habbo.communication.messages.parser.games
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

     class OpenLeaderboardMessageParser implements IMessageParser
    {
        var _leaderboardId:Int = 0;
        var _gameType:String;
        var _metric:String;
        var _titleLocalizationCode:String;
        var _descriptionLocalizationCode:String;
        var _menuLocalizationCode:String;
        var _period:String;
        var _offset:Int = 0;
        var _limit:Int = 0;
        var _totalRows:Int = 0;
        var _available:Array<ASAny>;
        var _rows:Array<ASAny>;
        var _ownRow:ASObject;

        public function flush():Bool
        {
            this._leaderboardId = 0;
            this._gameType = "";
            this._metric = "";
            this._titleLocalizationCode = "";
            this._descriptionLocalizationCode = "";
            this._menuLocalizationCode = "";
            this._period = "WEEKLY";
            this._offset = 0;
            this._limit = 10;
            this._totalRows = 0;
            this._available = [];
            this._rows = [];
            this._ownRow = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this.flush();
            this._leaderboardId = k.readInteger();
            this._gameType = k.readString();
            this._metric = k.readString();
            this._titleLocalizationCode = k.readString();
            this._descriptionLocalizationCode = k.readString();
            this._menuLocalizationCode = k.readString();
            this._period = k.readString();
            this._offset = k.readInteger();
            this._limit = k.readInteger();
            this._totalRows = k.readInteger();

            var optionCount= k.readInteger();
            for (optionIndex in 0...optionCount)
            {
                this._available.push({
                    id: k.readInteger(),
                    gameType: k.readString(),
                    metric: k.readString(),
                    titleLocalizationCode: k.readString(),
                    descriptionLocalizationCode: k.readString(),
                    menuLocalizationCode: k.readString()
                });
            }

            var rowCount= k.readInteger();
            for (rowIndex in 0...rowCount)
            {
                this._rows.push(this.readRow(k));
            }
            if (k.readBoolean()) this._ownRow = this.readRow(k);
            return true;
        }

        function readRow(k:IMessageDataWrapper):ASObject
        {
            return {
                userId: k.readInteger(),
                rank: k.readInteger(),
                username: k.readString(),
                figure: k.readString(),
                gender: k.readString(),
                value: k.readInteger(),
                own: k.readBoolean()
            };
        }

        public var leaderboardId(get,never):Int;
function  get_leaderboardId():Int { return this._leaderboardId; }
        public var gameType(get,never):String;
function  get_gameType():String { return this._gameType; }
        public var metric(get,never):String;
function  get_metric():String { return this._metric; }
        public var titleLocalizationCode(get,never):String;
function  get_titleLocalizationCode():String { return this._titleLocalizationCode; }
        public var descriptionLocalizationCode(get,never):String;
function  get_descriptionLocalizationCode():String { return this._descriptionLocalizationCode; }
        public var menuLocalizationCode(get,never):String;
function  get_menuLocalizationCode():String { return this._menuLocalizationCode; }
        public var period(get,never):String;
function  get_period():String { return this._period; }
        public var offset(get,never):Int;
function  get_offset():Int { return this._offset; }
        public var limit(get,never):Int;
function  get_limit():Int { return this._limit; }
        public var totalRows(get,never):Int;
function  get_totalRows():Int { return this._totalRows; }
        public var available(get,never):Array<ASAny>;
function  get_available():Array<ASAny> { return this._available; }
        public var rows(get,never):Array<ASAny>;
function  get_rows():Array<ASAny> { return this._rows; }
        public var ownRow(get,never):ASObject;
function  get_ownRow():ASObject { return this._ownRow; }

	public function new() {}
    }

