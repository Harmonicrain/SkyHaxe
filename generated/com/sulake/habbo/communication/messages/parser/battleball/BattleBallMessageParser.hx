package com.sulake.habbo.communication.messages.parser.battleball
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.battleball.BattleBallProtocol;

     final class BattleBallMessageParser implements IMessageParser
    {
        /** Up to 100 live rooms plus the 15 most recent persisted results. */
        static inline final MAX_INSTANCES= 115;
        static inline final MAX_OBJECTS= 256;
        static inline final MAX_TILES= 1600;
        static inline final MAX_EVENTS= 512;

        var _header:Int = 0;
        var _data:ASObject;

        public var header(get,never):Int;
function  get_header():Int { return this._header; }
        public var data(get,never):ASObject;
function  get_data():ASObject { return this._data; }

        public function flush():Bool
        {
            this._header = 0;
            this._data = {};
            return true;
        }

        public function parse(message:IMessageDataWrapper):Bool
        {
            if (message == null) return false;
            this._header = message.getID();
            this._data = {};
            try
            {
                switch (this._header)
                {
                    case BattleBallProtocol.LOUNGE_INFO:
                        this._data.protocolVersion = message.readInteger();
                        if (this._data.protocolVersion != BattleBallProtocol.STATUS_VERSION)
                            throw new ASError("Unsupported BattleBall lounge protocol");
                        this._data.ticketCost = message.readInteger();
                        this._data.skillLevel = message.readInteger();
                        this._data.ticketBalance = message.readInteger();
                        
                    case BattleBallProtocol.INSTANCE_LIST:
                        this._data.instances = this.readInstances(message);
                        
                    case BattleBallProtocol.GAME_INSTANCE:
                        this._data.instance = this.readInstance(message);
                        if (ASCompat.toInt(this._data.instance.instanceId) < 0)
                        {
                            this._data.instance.winningTeam = message.readByte();
                            this._data.instance.scores = this.readScores(message);
                            this._data.instance.players = this.readFinishedPlayers(message);
                        }
                        
                    case BattleBallProtocol.CREATE_FAILED:
                        this._data.reason = message.readInteger();
                        
                    case BattleBallProtocol.INSTANCE_NOT_AVAILABLE
                       | BattleBallProtocol.JOIN_FAILED
                       | BattleBallProtocol.WATCH_FAILED
                       | BattleBallProtocol.START_FAILED:
                        this._data.instanceId = message.readInteger();
                        this._data.reason = message.readInteger();
                        
                    case BattleBallProtocol.GAME_DELETED:
                        this._data.instanceId = message.readInteger();
                        
                    case BattleBallProtocol.PLAYER_REMOVED:
                        this._data.instanceId = message.readInteger();
                        this._data.reason = message.readInteger();
                        if (this._data.reason < 0 || this._data.reason > 1)
                            throw new ASError("Invalid BattleBall removal reason");
                        
                    case BattleBallProtocol.JOIN_PARAMETERS:
                        this.readJoinParameters(message);
                        
                    case BattleBallProtocol.GAME_LOCATION:
                        this._data.instanceId = message.readInteger();
                        this._data.mapId = message.readByte();
                        this._data.spectator = message.readBoolean();
                        
                    case BattleBallProtocol.FULL_STATUS:
                        this.readFullStatus(message);
                        
                    case BattleBallProtocol.STATUS:
                        this.readStatus(message);
                        
                    case BattleBallProtocol.GAME_START:
                        this._data.instanceId = message.readInteger(); this._data.sequence = message.readInteger();
                        this._data.countdownMs = message.readShort(); this._data.roundMs = message.readShort() * 1000;
                        
                    case BattleBallProtocol.GAME_END:
                        this._data.instanceId = message.readInteger(); this._data.sequence = message.readInteger();
                        this._data.winningTeam = message.readByte(); this._data.endingMs = message.readInteger();
                        this._data.scores = this.readScores(message);
                        this._data.playerScores = this.readPlayerScores(message);
                        
                    case BattleBallProtocol.SPECTATOR_COUNT:
                        this._data.instanceId = message.readInteger();
                        this._data.spectatorCount = message.readInteger();
                        if (this._data.spectatorCount < 0 || this._data.spectatorCount > MAX_OBJECTS)
                            throw new ASError("Invalid BattleBall spectator count");
                        
                    case BattleBallProtocol.IDLE_WARNING:
                        this._data.instanceId = message.readInteger(); this._data.secondsRemaining = message.readInteger();
                        
                    case BattleBallProtocol.SKILL_LEVEL_CHANGED:
                        this._data.skillLevel = message.readInteger();
                        
                    default:
                        return false;
                }
                return message.bytesAvailable == 0;
            }
            catch (error:ASError)
            {
                this.flush();
                return false;
            }
            return false;
        }

        function readInstances(message:IMessageDataWrapper):Array<ASAny>
        {
            var count= this.shortCount(message, MAX_INSTANCES);
            var values:Array<ASAny> = [];
            for (index in 0...count) values.push(this.readInstance(message));
            return values;
        }

        function readInstance(message:IMessageDataWrapper):ASObject
        {
            return {instanceId:message.readInteger(), name:message.readString(), ownerUserId:message.readInteger(),
                ownerName:message.readString(), mapId:message.readByte(), state:message.readByte(),
                privateGame:message.readBoolean(), teamCount:message.readByte(), playerCount:message.readByte(),
                capacity:message.readByte(), roundSeconds:message.readShort()};
        }

        function readJoinParameters(message:IMessageDataWrapper)
        {
            this._data.instanceId = message.readInteger();
            var count= this.byteCount(message, 4); var capacity= message.readByte(); this._data.teams = [];
            for (index in 0...count)
                this._data.teams.push({teamId:index, playerCount:message.readByte(), capacity:capacity});
        }

        function readFullStatus(message:IMessageDataWrapper)
        {
            this.readStatusVersion(message); this.readStatusHeader(message);
            this._data.objects = this.readFullObjects(message);
            this._data.width = message.readInteger(); this._data.height = message.readInteger();
            this._data.tiles = this.readFullTiles(message, this._data.width, this._data.height);
            this._data.priorityTiles = this._data.tiles;
            this._data.fillTiles = []; this._data.scores = this.readScores(message); this._data.events = [];
            this._data.spawns = []; this._data.updates = []; this._data.removals = []; this._data.boardReset = false;
            this._data.full = true;
        }

        function readStatus(message:IMessageDataWrapper)
        {
            this.readStatusVersion(message); this._data.instanceId = message.readInteger();
            this._data.baseSequence = message.readInteger(); this.readStateHeader(message);
            this.readObjectChanges(message); this._data.boardReset = message.readBoolean();
            this._data.objects = []; this._data.priorityTiles = this.readDeltaTiles(message);
            this._data.fillTiles = this.readDeltaTiles(message); this._data.scores = this.readScores(message);
            this._data.events = this.readEffects(message); this._data.full = false;
        }

        function readStatusVersion(message:IMessageDataWrapper)
        {
            this._data.protocolVersion = message.readInteger();
            if (this._data.protocolVersion != BattleBallProtocol.STATUS_VERSION)
                throw new ASError("Unsupported BattleBall status protocol");
        }

        function readStatusHeader(message:IMessageDataWrapper)
        {
            this._data.instanceId = message.readInteger(); this.readStateHeader(message);
        }

        function readStateHeader(message:IMessageDataWrapper)
        {
            this._data.sequence = message.readInteger();
            this._data.state = message.readInteger(); this._data.timeRemainingMs = message.readInteger();
        }

        function readFullObjects(message:IMessageDataWrapper):Array<ASAny>
        {
            var count= this.shortCount(message, MAX_OBJECTS); var values:Array<ASAny> = [];
            for (index in 0...count) values.push(this.readFullObject(message));
            return values;
        }

        function readFullObject(message:IMessageDataWrapper):ASObject
        {
            var type= message.readByte(); var objectId= message.readInteger();
            if (type == 0)
            {
                return {type:0, objectId:objectId, userId:message.readInteger(), x:this.position(message), y:this.position(message),
                    direction:message.readByte(), playerState:message.readByte(), colouringForUserId:message.readInteger(),
                    name:message.readString(), figure:message.readString(), teamId:message.readByte()};
            }
            if (type == 1)
            {
                return {type:1, objectId:objectId, holderObjectId:message.readInteger(), powerType:message.readByte(),
                    powerSecondsRemaining:message.readByte(), powerStampedAt:flash.Lib.getTimer(),
                    x:this.position(message), y:this.position(message)};
            }
            if (type == 2)
            {
                return {type:2, objectId:objectId, x:this.position(message), y:this.position(message)};
            }
            throw new ASError("Unknown BattleBall object type");
        }

        function readObjectChanges(message:IMessageDataWrapper)
        {
            var count= this.shortCount(message, MAX_OBJECTS); var index:Int;
            this._data.spawns = [];
            for (index in 0...count) this._data.spawns.push(this.readFullObject(message));
            count = this.shortCount(message, MAX_OBJECTS); this._data.updates = [];
            for (index in 0...count) this._data.updates.push(this.readDynamicObject(message));
            count = this.shortCount(message, MAX_OBJECTS); this._data.removals = [];
            for (index in 0...count) this._data.removals.push(message.readInteger());
        }

        function readDynamicObject(message:IMessageDataWrapper):ASObject
        {
            var type= message.readByte(); var objectId= message.readInteger();
            if (type == 0)
                return {type:0, objectId:objectId, x:this.position(message), y:this.position(message),
                    direction:message.readByte(), playerState:message.readByte(),
                    colouringForUserId:message.readInteger(), teamId:message.readByte()};
            if (type == 1)
                return {type:1, objectId:objectId, holderObjectId:message.readInteger(), powerType:message.readByte(),
                    powerSecondsRemaining:message.readByte(), powerStampedAt:flash.Lib.getTimer(),
                    x:this.position(message), y:this.position(message)};
            if (type == 2)
                return {type:2, objectId:objectId, x:this.position(message), y:this.position(message)};
            throw new ASError("Unknown BattleBall dynamic object type");
        }

        function position(message:IMessageDataWrapper):Int
        {
            var value= message.readByte();
            if (value < 0 || value > 127) throw new ASError("Invalid BattleBall object position");
            return value;
        }

        /** Full v2 tile grids are dense and row-major; each tile is one positive packed short. */
        function readFullTiles(message:IMessageDataWrapper, width:Int, height:Int):Array<ASAny>
        {
            if (width <= 0 || height <= 0 || width > MAX_TILES || height > MAX_TILES || width * height > MAX_TILES)
                throw new ASError("Invalid BattleBall tile grid");
            var count= width * height; var values:Array<ASAny> = [];
            for (index in 0...count)
            {
                var packed= message.readShort();
                if (packed < 0 || packed > 0x7FF) throw new ASError("Invalid packed BattleBall tile");
                var colour= packed & 7; var state= packed >> 3 & 7;
                if (colour > 5 || state > 4) throw new ASError("Invalid packed BattleBall tile state");
                values.push({x:index % width, y:Std.int(index / width), colour:colour - 2, state:state,
                    floorHeight:packed >> 6 & 15, walkable:(packed >> 10 & 1) != 0});
            }
            return values;
        }

        /** Delta v2 tiles carry only coordinates and mutable colour/state. */
        function readDeltaTiles(message:IMessageDataWrapper):Array<ASAny>
        {
            var count= message.readShort(); var values:Array<ASAny> = [];
            if (count < 0 || count > MAX_TILES) throw new ASError("Invalid BattleBall delta tile count");
            for (index in 0...count)
            {
                var x= message.readByte(); var y= message.readByte(); var packed= message.readByte();
                if (x < 0 || y < 0 || packed < 0 || packed > 0x3F)
                    throw new ASError("Invalid compact BattleBall delta tile");
                var colour= packed & 7; var state= packed >> 3 & 7;
                if (colour > 5 || state > 4) throw new ASError("Invalid compact BattleBall delta state");
                values.push({x:x, y:y, colour:colour - 2, state:state});
            }
            return values;
        }

        function readScores(message:IMessageDataWrapper):ASObject
        {
            var count= this.byteCount(message, 4); var values:ASObject = {};
            for (index in 0...count) values[Std.string(message.readByte())] = message.readInteger();
            return values;
        }

        /** End-of-round scores keyed by real or negative game-scoped bot user id. */
        function readPlayerScores(message:IMessageDataWrapper):ASObject
        {
            var count= this.shortCount(message, MAX_OBJECTS); var values:ASObject = {};
            for (index in 0...count) values[Std.string(message.readInteger())] = message.readInteger();
            return values;
        }

        function readFinishedPlayers(message:IMessageDataWrapper):Array<ASAny>
        {
            var count= this.shortCount(message, MAX_OBJECTS); var values:Array<ASAny> = [];
            for (index in 0...count)
                values.push({userId:message.readInteger(), name:message.readString(),
                    teamId:message.readByte(), score:message.readInteger(), type:0});
            return values;
        }

        function readEffects(message:IMessageDataWrapper):Array<ASAny>
        {
            var count= this.shortCount(message, MAX_EVENTS); var values:Array<ASAny> = [];
            for (index in 0...count)
            {
                var type= message.readByte();
                if (type != 3 && type != 4 && type != 5) throw new ASError("Unknown BattleBall effect type");
                values.push({type:type});
            }
            return values;
        }

        function shortCount(message:IMessageDataWrapper, maximum:Int):Int
        {
            var value= message.readShort();
            if (value < 0 || value > maximum) throw new ASError("Invalid BattleBall compact collection count");
            return value;
        }

        function byteCount(message:IMessageDataWrapper, maximum:Int):Int
        {
            var value= message.readByte();
            if (value < 0 || value > maximum) throw new ASError("Invalid BattleBall byte collection count");
            return value;
        }

	public function new() {}
    }

