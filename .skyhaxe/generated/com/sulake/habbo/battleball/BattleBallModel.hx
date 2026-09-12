package com.sulake.habbo.battleball
;

     final class BattleBallModel
    {
        public var instanceId:Int = -1;
        public var mapId:Int = 1;
        public var state:Int = 0;
        public var sequence:Int = -1;
        public var timeRemainingMs:Int = 0;
        public var roundDurationMs:Int = 0;
        /** getTimer() value when timeRemainingMs was last set from the server. */
        public var timeStampedAt:Int = 0;
        public var width:Int = 0;
        public var height:Int = 0;
        public var spectator:Bool = false;
        public var spectatorCount:Int = 0;
        public var ownerUserId:Int = 0;
        public var objects:ASObject = {};
        public var tiles:ASObject = {};
        public var scores:ASObject = {};

        public function applyLocation(data:ASObject)
        {
            if (this.instanceId != data.instanceId)
            {
                this.sequence = -1;
                this.state = 0;
                this.timeRemainingMs = 0;
                this.timeStampedAt = 0;
                this.roundDurationMs = 0;
                this.objects = {};
                this.tiles = {};
                this.scores = {};
                this.spectatorCount = 0;
            }
            this.instanceId = ASCompat.toInt(data.instanceId);
            this.mapId = ASCompat.toInt(data.mapId);
            this.spectator = data.spectator;
        }

        public function applyStatus(data:ASObject, requestFull:ASFunction):Bool
        {
var object:ASObject  = null, removedId = 0, spawned:ASObject  = null, update:ASObject  = null, team:String  = null;            if (data.protocolVersion != BattleBallProtocol.STATUS_VERSION || data.instanceId != this.instanceId) return false;
            // Full snapshots travel independently from the live status stream. A delayed full snapshot must
            // never roll a client back after it has already applied newer movement/player state.
            if (ASCompat.toBool(data.full) && this.sequence >= 0 && data.sequence < this.sequence)
            {
                return false;
            }
            if (!data.full && this.sequence >= 0 && data.sequence <= this.sequence)
            {
                return false;
            }
            // The server tracks one baseSequence per game, not per client, so any client that ever takes a
            // different path (late join, full snapshot, missed tick) sits permanently off that baseline.
            // Demanding equality strands it rejecting every delta forever. A base at or behind us covers
            // state we already hold, so only a base ahead of us is a genuine gap worth a full snapshot.
            if (!data.full && (this.sequence < 0 || data.baseSequence > this.sequence))
            {
                requestFull(this.instanceId);
                return false;
            }
            if (!data.full && (!this.canApplyDeltaTiles(data.priorityTiles) || !this.canApplyDeltaTiles(data.fillTiles)
                || !this.canApplyObjectChanges(data)))
            {
                requestFull(this.instanceId);
                return false;
            }
            if (data.full)
            {
                this.objects = {};
                this.tiles = {};
                this.width = ASCompat.toInt(data.width);
                this.height = ASCompat.toInt(data.height);
            }
            else if (data.boardReset) this.resetDynamicBoard();
            this.sequence = ASCompat.toInt(data.sequence);
            this.state = ASCompat.toInt(data.state);
            this.timeRemainingMs = ASCompat.toInt(data.timeRemainingMs);
            this.timeStampedAt = flash.Lib.getTimer();
            final _iter_:ASAny = data.objects; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_) {object = _tmp_;
this.objects[object.objectId] = object;
};
            if (!data.full)
            {
                final _iter_:ASAny = data.removals; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_) {removedId = ASCompat.toInt(_tmp_);
Reflect.deleteField(this.objects, Std.string(removedId));
};
                final _iter_:ASAny = data.spawns; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_) {spawned = _tmp_;
this.objects[spawned.objectId] = spawned;
};
                final _iter_:ASAny = data.updates; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_) {update = _tmp_;
this.applyObjectUpdate(update);
};
            }
            this.applyTiles(data.priorityTiles);
            this.applyTiles(data.fillTiles);
            if (data.full) this.scores = data.scores;
            else {final _iter_:ASAny = data.scores; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.___keys()) {team = _tmp_;
ASCompat.setDynamicProperty(this.scores, team, data.scores[team]);
}};
            return true;
        }

        /** GAME_START is broadcast independently of status snapshots and is authoritative for timing. */
        public function applyGameStart(data:ASObject):Bool
        {
            if (data == null || data.instanceId != this.instanceId) return false;
            this.state = 1;
            this.timeRemainingMs = Std.int(Math.max(0, ASCompat.toInt(data.countdownMs)));
            this.roundDurationMs = Std.int(Math.max(0, ASCompat.toInt(data.roundMs)));
            this.timeStampedAt = flash.Lib.getTimer();
            return true;
        }

        /** GAME_END arrives before the matching status delta and owns the inter-round clock. */
        public function applyGameEnd(data:ASObject):Bool
        {
            if (data == null || data.instanceId != this.instanceId || data.sequence < this.sequence) return false;
            this.state = 3;
            this.timeRemainingMs = Std.int(Math.max(0, ASCompat.toInt(data.endingMs)));
            this.timeStampedAt = flash.Lib.getTimer();
            return true;
        }

        /** Prevents a missed transition delta from leaving the final countdown numeral on screen forever. */
        public function advanceClock():Bool
        {
            if (this.state != 1 || this.timeStampedAt == 0 || this.roundDurationMs <= 0) return false;
            var elapsed= flash.Lib.getTimer() - this.timeStampedAt;
            if (elapsed < this.timeRemainingMs) return false;
            this.timeStampedAt += this.timeRemainingMs;
            this.timeRemainingMs = this.roundDurationMs;
            this.state = 2;
            return true;
        }

        /**
         * The server only emits a delta when the game state actually changes, so standing still means no
         * packets at all. Count down locally from the last authoritative value instead of freezing.
         */
        public var displayedTimeRemainingMs(get,never):Int;
public function  get_displayedTimeRemainingMs():Int
        {
            if (this.timeStampedAt == 0) return this.timeRemainingMs;
            return Std.int(Math.max(0, this.timeRemainingMs - (flash.Lib.getTimer() - this.timeStampedAt)));
        }

        public function localPlayer(userId:Int):ASObject
        {
var object:ASObject  = null;            final _iter_:ASObject = this.objects; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_) {object = _tmp_;
if (object.type == 0 && object.userId == userId) return object;
};
            return null;
        }

        public function reset()
        {
            this.instanceId = -1; this.sequence = -1; this.state = 0; this.timeRemainingMs = 0;
            this.timeStampedAt = 0; this.roundDurationMs = 0; this.ownerUserId = 0;
            this.spectator = false; this.spectatorCount = 0;
            this.objects = {}; this.tiles = {}; this.scores = {};
        }

        function applyTiles(values:Array<ASAny>)
        {
var tile:ASObject  = null, key:String  = null, existing:ASObject  = null;            if (values == null) return;
            if (checkNullIteratee(values)) for (_tmp_ in values)
            {
tile = _tmp_;
key= tile.x + ":" + tile.y;
                if (ASCompat.hasOwnProperty(tile, "floorHeight")) ASCompat.setDynamicProperty(this.tiles, key, tile);
                else
                {
existing= ASCompat.getDynamicProperty(this.tiles, key);
                    existing.colour = tile.colour;
                    existing.state = tile.state;
                }
            }
        }

        function canApplyDeltaTiles(values:Array<ASAny>):Bool
        {
var tile:ASObject  = null;            if (values == null) return true;
            if (checkNullIteratee(values)) for (_tmp_ in values)
            {
tile = _tmp_;
                if (tile.x < 0 || tile.y < 0 || tile.x >= this.width || tile.y >= this.height ||
ASCompat.getDynamicProperty(                    this.tiles, tile.x + ":" + tile.y)== null) return false;
            }
            return true;
        }

        function canApplyObjectChanges(data:ASObject):Bool
        {
var update:ASObject  = null, existing:ASObject  = null;            if (data == null) return false;
            final _iter_:ASAny = data.updates; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
update = _tmp_;
existing= this.objects[update.objectId];
                if (existing == null || existing.type != update.type) return false;
            }
            return true;
        }

        function applyObjectUpdate(update:ASObject)
        {
var field:String  = null;            var existing:ASObject = this.objects[update.objectId];
            if (checkNullIteratee(update)) for (_tmp_ in update.___keys()) {field = _tmp_;
if (field != "type" && field != "objectId") ASCompat.setDynamicProperty(existing, field, ASCompat.getDynamicProperty(update, field));
};
        }

        function resetDynamicBoard()
        {
var tile:ASObject  = null, key:String  = null;            final _iter_:ASObject = this.tiles; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
tile = _tmp_;
                if (tile.colour != -2) { tile.colour = -1; tile.state = 0; }
            }
            final _iter_:ASObject = this.objects; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.___keys()) {key = _tmp_;
if (ASCompat.getDynamicProperty(this.objects, key).type != 0) Reflect.deleteField(this.objects, key);
};
            this.scores = {};
        }
public function new(){}
    }

