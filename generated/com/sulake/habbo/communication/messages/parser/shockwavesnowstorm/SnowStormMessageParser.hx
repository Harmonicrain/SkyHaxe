package com.sulake.habbo.communication.messages.parser.shockwavesnowstorm
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.snowstorm.SnowStormProtocol;
    import com.sulake.habbo.utils.HabboWebTools;

     final class SnowStormMessageParser implements IMessageParser
    {
        var _header:Int = 0;
        var _data:ASObject;

        public var header(get,never):Int;
function  get_header():Int { return this._header; }
        public var data(get,never):ASObject;
function  get_data():ASObject { return this._data; }

        public function flush():Bool
        { this._header = 0; this._data = {}; return true; }

        public function parse(message:IMessageDataWrapper):Bool
        {
            if (message == null) return false;
            this._header = message.getID(); this._data = {};
            try
            {
                switch (this._header)
                {
                    case SnowStormProtocol.LOUNGE_INFO: this.readLounge(message); 
                    case SnowStormProtocol.INSTANCE_LIST: this._data.instances = this.readInstances(message); 
                    case SnowStormProtocol.GAME_INSTANCE: this._data.instance = this.readInstance(message); 
                    case SnowStormProtocol.INSTANCE_REMOVED:
                        this._data.rowKind = this.rangedByte(message, 0, 1);
                        this._data.id = message.readInteger(); 
                    case SnowStormProtocol.JOIN_PARAMETERS: this.readJoin(message); 
                    case SnowStormProtocol.OPERATION_FAILED:
                        this._data.operation = this.rangedByte(message, 0, 13);
                        this._data.instanceId = message.readInteger();
                        this._data.reason = this.rangedByte(message, 0, 14); 
                    case SnowStormProtocol.GAME_LOCATION:
                        this._data.instanceId = this.positive(message.readInteger());
                        this._data.mapId = this.rangedByte(message, 1, 7);
                        this._data.spectator = message.readBoolean();
                        this._data.playerObjectId = message.readInteger();
                        this._data.mapRevision = this.positive(message.readInteger());
                        this._data.mapChecksum = message.readInteger(); 
                    case SnowStormProtocol.GAME_RESET:
                        this._data.instanceId = this.positive(message.readInteger());
                        this._data.sequence = this.nonNegative(message.readInteger());
                        this._data.roundNumber = this.positive(message.readInteger()); 
                    case SnowStormProtocol.GAME_START: this.readStart(message); 
                    case SnowStormProtocol.FULL_GAME_STATUS: this.readFullStatus(message); 
                    case SnowStormProtocol.GAME_STATUS: this.readStatus(message); 
                    case SnowStormProtocol.GAME_END: this.readFinalResult(message, true); 
                    case SnowStormProtocol.PLAYER_REMOVED:
                        this._data.instanceId = this.positive(message.readInteger());
                        this._data.reason = this.rangedByte(message, 0, 14); 
                    case SnowStormProtocol.SPECTATOR_COUNT:
                        this._data.instanceId = this.positive(message.readInteger());
                        this._data.spectatorCount = this.countShort(message, SnowStormProtocol.MAX_SPECTATORS); 
                    case SnowStormProtocol.FINISHED_GAME: this.readFinalResult(message, false); 
                    case SnowStormProtocol.SKILL_LEVEL_CHANGED:
                        this._data.skillLevel = this.positive(message.readInteger());
                        this._data.rankedPoints = this.nonNegative(message.readInteger()); 
                    case SnowStormProtocol.IDLE_WARNING:
                        this._data.instanceId = this.positive(message.readInteger());
                        this._data.secondsRemaining = this.nonNegative(message.readInteger()); 
                    default: return false;
                }
                return message.bytesAvailable == 0;
            }
            catch (error:ASError)
            {
                HabboWebTools.airDebug("[SnowStorm Protocol] rejected packet " + this._header
                    + ": " + error.message);
                this.flush();
                return false;
            }
            return false;
        }

        function readLounge(message:IMessageDataWrapper)
        {
            this.version(message); this._data.ticketCost = this.nonNegative(message.readInteger());
            this._data.skillLevel = this.positive(message.readInteger());
            this._data.rankedPoints = this.nonNegative(message.readInteger());
            this._data.ticketBalance = this.nonNegative(message.readInteger());
            var count= this.countByte(message, 7); this._data.maps = [];
            for (index in 0...count)
                this._data.maps.push(this.rangedByte(message, 1, 7));
        }

        function readInstances(message:IMessageDataWrapper):Array<ASAny>
        {
            var count= this.countShort(message, SnowStormProtocol.MAX_INSTANCE_ROWS); var values:Array<ASAny> = [];
            for (index in 0...count) values.push(this.readInstance(message));
            return values;
        }

        function readInstance(message:IMessageDataWrapper):ASObject
        {
            var value:ASObject = {rowKind:this.rangedByte(message, 0, 1), id:this.positive(message.readInteger()),
                name:this.boundedString(message.readString(), 32), ownerUserId:this.positive(message.readInteger()),
                ownerName:this.boundedString(message.readString(), 64), mapId:this.rangedByte(message, 1, 7),
                state:this.rangedByte(message, 0, 4), teamCount:this.rangedByte(message, 1, 4),
                playerCount:this.countByte(message, SnowStormProtocol.MAX_PLAYERS),
                spectatorCount:this.countShort(message, SnowStormProtocol.MAX_SPECTATORS),
                lengthChoice:this.rangedByte(message, 1, 3), resultId:message.readInteger()};
            if ((value.rowKind == 0 && value.resultId != -1) || (value.rowKind == 1 && value.resultId <= 0))
                throw new ASError("Invalid SnowStorm row identity");
            var playerNames= this.countByte(message, SnowStormProtocol.MAX_PLAYERS);
            value.playerNames = [];
            for (index in 0...playerNames)
                value.playerNames.push(this.boundedString(message.readString(), 64));
            if (value.playerNames.length != value.playerCount)
                throw new ASError("Invalid SnowStorm row player names");
            return value;
        }

        function readJoin(message:IMessageDataWrapper)
        {
            this._data.instanceId = this.positive(message.readInteger());
            var teams= this.rangedByte(message, 1, 4); this._data.teamCount = teams;
            this._data.selectedTeam = this.rangedByte(message, 0, teams - 1);
            this._data.teams = []; var total= 0; var seen:ASObject = {};
            var capacity= teams == 1 ? 12 : (teams == 2 ? 6 : (teams == 3 ? 4 : 3));
            for (index in 0...teams)
            {
                var count= this.countByte(message, capacity); total += count;
                if (total > SnowStormProtocol.MAX_PLAYERS) throw new ASError("Too many SnowStorm players");
                var players:Array<ASAny> = [];
                for (playerIndex in 0...count)
                {
                    var userId= this.nonZero(message.readInteger());
                    if (seen[Std.string(userId)]) throw new ASError("Duplicate SnowStorm waiting player");
                    seen[Std.string(userId)] = true;
                    players.push({userId:userId, name:this.boundedString(message.readString(), 64),
                        teamId:index});
                }
                this._data.teams.push({teamId:index, players:players});
            }
        }

        function readStart(message:IMessageDataWrapper)
        {
            this._data.instanceId = this.positive(message.readInteger());
            this._data.sequence = this.nonNegative(message.readInteger());
            this._data.roundNumber = this.positive(message.readInteger());
            this._data.countdownMs = this.nonNegative(message.readShort());
            this._data.roundSeconds = this.positive(message.readShort());
            this._data.ranked = message.readBoolean();
        }

        function readFullStatus(message:IMessageDataWrapper)
        {
            this.version(message);
            this._data.instanceId = this.positive(message.readInteger());
            this._data.sequence = this.nonNegative(message.readInteger());
            this._data.state = this.rangedByte(message, 0, 4);
            this._data.roundNumber = this.positive(message.readInteger());
            this._data.turnNumber = this.nonNegative(message.readInteger());
            this._data.timeRemainingMs = this.nonNegative(message.readInteger());
            this._data.playerObjectId = message.readInteger();
            this._data.ranked = message.readBoolean();
            this._data.teamCount = this.rangedByte(message, 1, 4);
            this._data.teamScores = this.readTeamScores(message, this._data.teamCount, true);
            var seen:ASObject = {}; var count= this.countShort(message, SnowStormProtocol.MAX_OBJECTS);
            this._data.objects = [];
            for (index in 0...count)
            {
                var object:ASObject = this.readObject(message);
                if (seen[object.objectId]) throw new ASError("Duplicate SnowStorm object");
                seen[object.objectId] = true; this._data.objects.push(object);
            }
            this._data.checksum = message.readInteger();
        }

        function readStatus(message:IMessageDataWrapper)
        {
            this.version(message);
            this._data.instanceId = this.positive(message.readInteger());
            this._data.baseSequence = this.nonNegative(message.readInteger());
            this._data.sequence = this.nonNegative(message.readInteger());
            this._data.turnNumber = this.nonNegative(message.readInteger());
            this._data.timeRemainingMs = this.nonNegative(message.readInteger());
            this._data.state = this.rangedByte(message, 1, 2);
            this._data.checksum = message.readInteger();
            var subturns= this.countByte(message, SnowStormProtocol.SUBTURNS_PER_TURN);
            if (subturns != SnowStormProtocol.SUBTURNS_PER_TURN) throw new ASError("Invalid SnowStorm turn");
            this._data.subturns = []; var total= 0;
            for (index in 0...subturns)
            {
                var count= this.countShort(message, SnowStormProtocol.MAX_EVENTS_PER_SUBTURN);
                total += count;
                if (total > SnowStormProtocol.MAX_EVENTS_PER_TURN) throw new ASError("Too many SnowStorm events");
                var events:Array<ASAny> = [];
                for (eventIndex in 0...count)
                    events.push(this.readEvent(message));
                this._data.subturns.push(events);
            }
            this._data.teamScores = this.readTeamScores(message, SnowStormProtocol.MAX_TEAMS);
        }

        function readObject(message:IMessageDataWrapper):ASObject
        {
            var type= this.rangedByte(message, SnowStormProtocol.OBJECT_AVATAR,
                SnowStormProtocol.OBJECT_MACHINE);
            var objectId= this.positive(message.readInteger());
            if (type == SnowStormProtocol.OBJECT_AVATAR)
            {
                var userId= this.nonZero(message.readInteger());
                var name= this.boundedString(message.readString(), 64);
                var figure= this.boundedString(message.readString(), 512);
                var sex= this.boundedString(message.readString(), 8);
                var teamId= this.rangedByte(message, 0, 3);
                var bot= message.readBoolean();
                if (bot != (userId < 0)) throw new ASError("Invalid SnowStorm bot identity");
                return {type:type, objectId:objectId, userId:userId,
                    name:name, figure:figure, sex:sex, teamId:teamId,
                    bot:bot, worldX:message.readInteger(), worldY:message.readInteger(),
                    direction:this.rangedByte(message, 0, 7),
                    health:this.rangedByte(message, 0, SnowStormProtocol.MAX_HEALTH),
                    snowballs:this.rangedByte(message, 0, SnowStormProtocol.MAX_AMMO),
                    activity:this.rangedByte(message, SnowStormProtocol.ACTIVITY_NORMAL,
                        SnowStormProtocol.ACTIVITY_INVINCIBLE),
                    activityTimer:this.nonNegative(message.readShort()), nextGoalTileX:message.readInteger(),
                    nextGoalTileY:message.readInteger(), moveTargetX:message.readInteger(),
                    moveTargetY:message.readInteger(), score:this.nonNegative(message.readInteger()),
                    standingDirection:this.rangedByte(message, 0, 7), fallPose:this.rangedByte(message, 0, 2)};
            }
            if (type == SnowStormProtocol.OBJECT_SNOWBALL)
                return {type:type, objectId:objectId, throwerObjectId:this.positive(message.readInteger()),
                    worldX:message.readInteger(), worldY:message.readInteger(), height:message.readInteger(),
                    direction:this.rangedShort(message, 0, 359),
                    trajectory:this.rangedByte(message, SnowStormProtocol.TRAJECTORY_QUICK,
                        SnowStormProtocol.TRAJECTORY_LONG_LOB),
                    timeToLive:this.rangedShort(message, -32768, 32767),
                    parabolaOffset:this.nonNegative(message.readShort())};
            return {type:type, objectId:objectId, worldX:message.readInteger(), worldY:message.readInteger(),
                snowballs:this.rangedByte(message, 0, SnowStormProtocol.MAX_AMMO),
                refillTimer:this.rangedShort(message, -1, 32767)};
        }

        function readEvent(message:IMessageDataWrapper):ASObject
        {
            var type= this.rangedByte(message, SnowStormProtocol.EVENT_SPAWN_OBJECT,
                SnowStormProtocol.EVENT_SNOWBALL_MISS);
            var value:ASObject = {type:type};
            if (type == SnowStormProtocol.EVENT_SPAWN_OBJECT)
            {
                value.object = this.readObject(message);
            }
            else if (type == SnowStormProtocol.EVENT_REMOVE_OBJECT)
            {
                value.objectId = this.positive(message.readInteger());
            }
            else if (type == SnowStormProtocol.EVENT_AVATAR_MOVE)
            {
                value.objectId = this.positive(message.readInteger());
                value.worldX = message.readInteger();
                value.worldY = message.readInteger();
                value.x = message.readInteger();
                value.y = message.readInteger();
                value.nextGoalTileX = message.readInteger();
                value.nextGoalTileY = message.readInteger();
                value.direction = this.rangedByte(message, 0, 7);
            }
            else if (type == SnowStormProtocol.EVENT_AVATAR_THROW)
            {
                value.objectId = this.positive(message.readInteger());
                value.trajectory = this.rangedByte(message,
                    SnowStormProtocol.TRAJECTORY_QUICK, SnowStormProtocol.TRAJECTORY_LONG_LOB);
                value.targetWorldX = message.readInteger();
                value.targetWorldY = message.readInteger();
            }
            else if (type == SnowStormProtocol.EVENT_LAUNCH_SNOWBALL)
            {
                value.object = this.readObject(message);
            }
            else if (type == SnowStormProtocol.EVENT_HIT)
            {
                value.throwerId = this.positive(message.readInteger());
                value.targetId = this.positive(message.readInteger());
                value.impactWorldX = message.readInteger();
                value.impactWorldY = message.readInteger();
                value.impactWorldZ = message.readInteger();
                value.direction = this.rangedByte(message, 0, 7);
                value.health = this.rangedByte(message, 0, SnowStormProtocol.MAX_HEALTH);
            }
            else if (type == SnowStormProtocol.EVENT_STUN)
            {
                value.throwerId = this.positive(message.readInteger());
                value.targetId = this.positive(message.readInteger());
                value.direction = this.rangedByte(message, 0, 7);
                value.fallPose = this.rangedByte(message, 1, 2);
            }
            else if (type == SnowStormProtocol.EVENT_ACTIVITY_STATE)
            {
                value.objectId = this.positive(message.readInteger());
                value.activity = this.rangedByte(message,
                    SnowStormProtocol.ACTIVITY_NORMAL, SnowStormProtocol.ACTIVITY_INVINCIBLE);
                value.timer = this.nonNegative(message.readShort());
                value.health = this.rangedByte(message, 0, SnowStormProtocol.MAX_HEALTH);
            }
            else if (type == SnowStormProtocol.EVENT_SNOWBALL_COUNT)
            {
                value.objectId = this.positive(message.readInteger());
                value.count = this.rangedByte(message, 0, SnowStormProtocol.MAX_AMMO);
            }
            else if (type == SnowStormProtocol.EVENT_MACHINE_RESTOCK)
            {
                value.machineId = this.positive(message.readInteger());
                value.count = this.rangedByte(message, 0, SnowStormProtocol.MAX_AMMO);
            }
            else if (type == SnowStormProtocol.EVENT_MACHINE_TRANSFER)
            {
                value.machineId = this.positive(message.readInteger());
                value.playerId = this.positive(message.readInteger());
                value.machineCount = this.rangedByte(message, 0, SnowStormProtocol.MAX_AMMO);
                value.playerCount = this.rangedByte(message, 0, SnowStormProtocol.MAX_AMMO);
            }
            else if (type == SnowStormProtocol.EVENT_PLAYER_SCORE)
            {
                value.objectId = this.positive(message.readInteger());
                value.score = this.nonNegative(message.readInteger());
            }
            else
            {
                value.objectId = this.positive(message.readInteger());
            }
            if (type == SnowStormProtocol.EVENT_LAUNCH_SNOWBALL &&
                value.object.type != SnowStormProtocol.OBJECT_SNOWBALL)
                throw new ASError("SnowStorm launch must contain a snowball");
            return value;
        }

        function readFinalResult(message:IMessageDataWrapper, live:Bool)
        {
            this._data.instanceId = this.positive(message.readInteger());
            this._data.resultId = this.positive(message.readInteger());
            if (live) this._data.sequence = this.nonNegative(message.readInteger());
            this._data.roundNumber = this.positive(message.readInteger());
            this._data.endReason = this.rangedByte(message, 0, 4);
            this._data.winningTeam = this.rangedByte(message, 0, 255);
            this._data.ranked = message.readBoolean();
            var teams= this.rangedByte(message, 1, 4); this._data.teams = [];
            for (index in 0...teams)
            {
                this._data.teams.push({
                    teamId:this.rangedByte(message, 0, 3),
                    score:this.nonNegative(message.readInteger()),
                    placement:this.rangedByte(message, 1, 4)
                });
            }
            var count= this.countShort(message, SnowStormProtocol.MAX_PLAYERS); this._data.players = [];
            for (index in 0...count)
            {
                this._data.players.push({
                    userId:this.nonZero(message.readInteger()),
                    name:this.boundedString(message.readString(), 64),
                    teamId:this.rangedByte(message, 0, 3),
                    score:this.nonNegative(message.readInteger()),
                    placement:this.rangedByte(message, 1, 12),
                    winner:message.readBoolean()
                });
            }
            if (live) this._data.nextGameCountdownMs = this.nonNegative(message.readInteger());
        }

        function readTeamScores(message:IMessageDataWrapper, maximum:Int, exact:Bool = false):ASObject
        {
            var count= this.countByte(message, maximum); var values:ASObject = {};
            if (exact && count != maximum) throw new ASError("Incomplete SnowStorm team scores");
            for (index in 0...count)
            {
                var team= this.rangedByte(message, 0, 3);
                if (values[Std.string(team)] != /*undefined*/null) throw new ASError("Duplicate team score");
                values[Std.string(team)] = this.nonNegative(message.readInteger());
            }
            return values;
        }

        function version(message:IMessageDataWrapper)
        {
            this._data.protocolVersion = message.readInteger();
            if (this._data.protocolVersion != SnowStormProtocol.VERSION)
                throw new ASError("Unsupported SnowStorm protocol");
        }

        function countByte(message:IMessageDataWrapper, maximum:Int):Int
        {
            return this.range(message.readByte() & 0xFF, 0, maximum);
        }

        function countShort(message:IMessageDataWrapper, maximum:Int):Int
        {
            return this.range(message.readShort(), 0, maximum);
        }

        function rangedByte(message:IMessageDataWrapper, minimum:Int, maximum:Int):Int
        {
            return this.range(message.readByte() & 0xFF, minimum, maximum);
        }

        function rangedShort(message:IMessageDataWrapper, minimum:Int, maximum:Int):Int
        {
            return this.range(message.readShort(), minimum, maximum);
        }

        function positive(value:Int):Int
        {
            return this.range(value, 1, ASCompat.MAX_INT);
        }

        function nonZero(value:Int):Int
        {
            if (value == 0 || value < -(SnowStormProtocol.MAX_PLAYERS - 1))
                throw new ASError("Invalid SnowStorm identifier");
            return value;
        }

        function nonNegative(value:Int):Int
        {
            return this.range(value, 0, ASCompat.MAX_INT);
        }

        function range(value:Int, minimum:Int, maximum:Int):Int
        {
            if (value < minimum || value > maximum)
                throw new ASError("Invalid SnowStorm value");
            return value;
        }

        function boundedString(value:String, maximum:Int):String
        {
            if (value == null || value.length > maximum)
                throw new ASError("Invalid SnowStorm string");
            return value;
        }

	public function new() {}
    }

