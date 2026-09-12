package com.sulake.habbo.snowstorm
;

    /** Authoritative client state plus the deterministic presentation/checksum mirror. */
     final class SnowStormModel
    {
        public var instanceId:Int = -1;
        public var mapId:Int = -1;
        public var state:Int = 0;
        public var sequence:Int = -1;
        public var roundNumber:Int = 0;
        public var turnNumber:Int = 0;
        public var timeRemainingMs:Int = 0;
        public var timeStampedAt:Int = 0;
        public var roundSeconds:Int = 0;
        public var playerObjectId:Int = -1;
        public var spectator:Bool = false;
        public var ranked:Bool = false;
        public var teamCount:Int = 1;
        public var spectatorCount:Int = 0;
        public var objects:ASObject = {};
        public var teamScores:ASObject = {};
        public var finalResult:ASObject;
        public var map:ASObject;
        public var playbackEventHandler:ASFunction;

        var _playbackFrames:Array<ASAny> = [];
        var _nextPlaybackAt:Int = 0;

        public function applyLocation(data:ASObject):Bool
        {
            if (data == null || ASCompat.toInt(data.instanceId) <= 0 ||
                !SnowStormMapCatalog.isCompatible(ASCompat.toInt(data.mapId), ASCompat.toInt(data.mapRevision), ASCompat.toInt(data.mapChecksum)))
                return false;
            if (this.instanceId != ASCompat.toInt(data.instanceId)) this.resetSimulation();
            this.instanceId = ASCompat.toInt(data.instanceId);
            this.mapId = ASCompat.toInt(data.mapId);
            this.map = SnowStormMapCatalog.getMap(this.mapId);
            this.spectator = ASCompat.toBool(data.spectator);
            this.playerObjectId = ASCompat.toInt(data.playerObjectId);
            return true;
        }

        public function applyFullStatus(data:ASObject, recover:ASFunction):Bool
        {
var source:ASObject  = null, object:ASObject  = null, goalWorldX = 0, goalWorldY = 0;            if (!this.validPacket(data) || this.map == null) return false;
            if (this.sequence >= 0 && ASCompat.toInt(data.sequence) < this.sequence) return false;
            var candidate:ASObject = {};
            final _iter_:ASAny = data.objects; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
source = _tmp_;
object= this.copyObject(source);
                if (object.type == SnowStormProtocol.OBJECT_AVATAR)
                {
goalWorldX= SnowStormMapCatalog.toWorldX(this.map, ASCompat.toInt(object.nextGoalTileX));
goalWorldY= SnowStormMapCatalog.toWorldY(this.map, ASCompat.toInt(object.nextGoalTileY));
                    object.nextGoalActive = ASCompat.toInt(object.worldX) != goalWorldX || ASCompat.toInt(object.worldY) != goalWorldY;
                }
                candidate[Std.string(ASCompat.toInt(object.objectId))] = object;
            }
            if (SnowStormMath.checksum(ASCompat.toInt(data.turnNumber), candidate) != ASCompat.toInt(data.checksum))
            {
                if (recover != null) recover(2);
                return false;
            }
            this.objects = candidate;
            this.clearPlayback();
            this.sequence = ASCompat.toInt(data.sequence);
            this.state = ASCompat.toInt(data.state);
            this.roundNumber = ASCompat.toInt(data.roundNumber);
            this.turnNumber = ASCompat.toInt(data.turnNumber);
            this.timeRemainingMs = ASCompat.toInt(data.timeRemainingMs);
            this.timeStampedAt = flash.Lib.getTimer();
            this.playerObjectId = ASCompat.toInt(data.playerObjectId);
            this.ranked = ASCompat.toBool(data.ranked);
            this.teamCount = ASCompat.toInt(data.teamCount);
            this.teamScores = this.copyScores(data.teamScores);
            return true;
        }

        public function applyStatus(data:ASObject, recover:ASFunction):Bool
        {
var subturn:Array<ASAny>  = null, team:String  = null;            if (!this.validPacket(data)) return false;
            if (this.sequence >= 0 && ASCompat.toInt(data.sequence) <= this.sequence) return false;
            if (this.sequence < 0 || ASCompat.toInt(data.baseSequence) != this.sequence ||
                ASCompat.toInt(data.turnNumber) != this.turnNumber)
            {
                if (recover != null) recover(1);
                return false;
            }
            // Validate and simulate against the last authoritative queued frame, not the frame
            // currently being presented. Network jitter can deliver the next 300 ms turn before
            // ENTER_FRAME has shown every 60 ms subturn; draining those frames here made the view
            // jump straight to the newest position.
            var presented:ASObject = this.objects;
            var simulation:ASObject = this._playbackFrames.length == 0
                ? this.copyObjects(presented)
                : this.copyObjects(this._playbackFrames[this._playbackFrames.length - 1].objects);
            if (SnowStormMath.checksum(this.turnNumber, simulation) != ASCompat.toInt(data.checksum))
            {
                if (recover != null) recover(2);
                return false;
            }
            this.objects = simulation;
            var frames:Array<ASAny> = [];
            final _iter_:ASAny = data.subturns; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
subturn = _tmp_;
                this.applySubturn(subturn);
                frames.push({objects:this.copyObjects(this.objects), events:subturn});
            }
            this.objects = presented;
            // Preserve any unpresented frames and append the new authoritative turn. This keeps
            // packet delivery timing from collapsing multiple movement slices into one visual snap.
            var startPlayback= this._playbackFrames.length == 0;
            this._playbackFrames = this._playbackFrames.concat(frames);
            if (startPlayback)
            {
                this._nextPlaybackAt = flash.Lib.getTimer();
                this.advancePlayback(this._nextPlaybackAt);
            }
            final _iter_:ASAny = data.teamScores; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.___keys()) {team = _tmp_;
ASCompat.setDynamicProperty(this.teamScores, team, ASCompat.toInt(data.teamScores[team]));
};
            this.sequence = ASCompat.toInt(data.sequence);
            this.turnNumber = ASCompat.toInt(data.turnNumber) + 1;
            this.state = ASCompat.toInt(data.state);
            this.timeRemainingMs = ASCompat.toInt(data.timeRemainingMs);
            this.timeStampedAt = flash.Lib.getTimer();
            return true;
        }

        /** Presents zero or more due authoritative subturns. Returns true when the view changed. */
        public function advancePlayback(now:Int=-1):Bool
        {
var frame:ASObject  = null;            if (now < 0) now = flash.Lib.getTimer();
            var changed= false;
            while (this._playbackFrames.length > 0 && now >= this._nextPlaybackAt)
            {
frame= this._playbackFrames.shift();
                this.objects = frame.objects;
                if (this.playbackEventHandler != null)
                    this.playbackEventHandler(frame.events);
                this._nextPlaybackAt += SnowStormMath.SUBTURN_MS;
                changed = true;
            }
            return changed;
        }

        public function applyStart(data:ASObject):Bool
        {
            if (!this.validPacket(data) || ASCompat.toInt(data.sequence) < this.sequence) return false;
            this.sequence = ASCompat.toInt(data.sequence);
            this.roundNumber = ASCompat.toInt(data.roundNumber);
            this.state = SnowStormProtocol.STATE_COUNTDOWN;
            this.timeRemainingMs = ASCompat.toInt(data.countdownMs);
            this.timeStampedAt = flash.Lib.getTimer();
            this.roundSeconds = ASCompat.toInt(data.roundSeconds);
            this.ranked = ASCompat.toBool(data.ranked);
            return true;
        }

        public function applyReset(data:ASObject):Bool
        {
            if (!this.validPacket(data) || ASCompat.toInt(data.sequence) < this.sequence) return false;
            var keepInstance= this.instanceId;
            var keepMap= this.mapId;
            var keepSpectator= this.spectator;
            var keepPlayer= this.playerObjectId;
            var keepTeamCount= this.teamCount;
            var keepMapData:ASObject = this.map;
            this.resetSimulation();
            this.instanceId = keepInstance;
            this.mapId = keepMap;
            this.map = keepMapData;
            this.spectator = keepSpectator;
            this.playerObjectId = keepPlayer;
            this.teamCount = keepTeamCount;
            this.sequence = ASCompat.toInt(data.sequence);
            this.roundNumber = ASCompat.toInt(data.roundNumber);
            return true;
        }

        public function applyEnd(data:ASObject):Bool
        {
            if (!this.validPacket(data) || ASCompat.toInt(data.sequence) < this.sequence) return false;
            this.sequence = ASCompat.toInt(data.sequence);
            this.state = SnowStormProtocol.STATE_ENDING;
            this.finalResult = data;
            this.timeRemainingMs = ASCompat.toInt(data.nextGameCountdownMs);
            this.timeStampedAt = flash.Lib.getTimer();
            return true;
        }

        public function localPlayer():ASObject
        { return this.playerObjectId > 0 ? this.objects[Std.string(this.playerObjectId)] : null; }

        public var displayedTimeRemainingMs(get,never):Int;
public function  get_displayedTimeRemainingMs():Int
        { return Std.int(this.timeStampedAt <= 0 ? this.timeRemainingMs : Std.int(Math.max(0, this.timeRemainingMs - (flash.Lib.getTimer() - this.timeStampedAt)))); }

        public function reset()
        {
            this.instanceId = -1;
            this.mapId = -1;
            this.map = null;
            this.spectator = false;
            this.playerObjectId = -1;
            this.teamCount = 1;
            this.spectatorCount = 0;
            this.resetSimulation();
        }

        function resetSimulation()
        {
            this.clearPlayback();
            this.state = SnowStormProtocol.STATE_LOBBY;
            this.sequence = -1;
            this.roundNumber = 0;
            this.turnNumber = 0;
            this.timeRemainingMs = 0;
            this.timeStampedAt = 0;
            this.roundSeconds = 0;
            this.ranked = false;
            this.objects = {};
            this.teamScores = {};
            this.finalResult = null;
        }

        function validPacket(data:ASObject):Bool
        { return data != null && this.instanceId > 0 && ASCompat.toInt(data.instanceId) == this.instanceId; }

        function applySubturn(events:Array<ASAny>)
        {
var event:ASObject  = null;            var skipActivityTick:ASObject = {};
            if (checkNullIteratee(events)) for (_tmp_ in events) {event = _tmp_;
this.applyEvent(event, skipActivityTick);
};
            this.advanceObjects(skipActivityTick);
        }

        function applyEvent(event:ASObject, skipActivityTick:ASObject)
        {
var goalWorldX = 0, goalWorldY = 0;            if (event == null) return;
            var object:ASObject = null;
            var target:ASObject = null;
            switch (ASCompat.toInt(event.type))
            {
                case SnowStormProtocol.EVENT_SPAWN_OBJECT:
                    object = this.copyObject(event.object);
                    if (this.objects[object.objectId] == null) this.objects[object.objectId] = object;
                    
                case SnowStormProtocol.EVENT_REMOVE_OBJECT:
                    Reflect.deleteField(this.objects, Std.string(ASCompat.toInt(event.objectId)));
                    
                case SnowStormProtocol.EVENT_AVATAR_MOVE:
                    object = this.objects[Std.string(ASCompat.toInt(event.objectId))];
                    if (object != null && object.type == SnowStormProtocol.OBJECT_AVATAR)
                    {
                        object.worldX = ASCompat.toInt(event.worldX);
                        object.worldY = ASCompat.toInt(event.worldY);
                        object.moveTargetX = ASCompat.toInt(event.x);
                        object.moveTargetY = ASCompat.toInt(event.y);
                        object.nextGoalTileX = ASCompat.toInt(event.nextGoalTileX);
                        object.nextGoalTileY = ASCompat.toInt(event.nextGoalTileY);
goalWorldX= SnowStormMapCatalog.toWorldX(
                            this.map, ASCompat.toInt(object.nextGoalTileX));
goalWorldY= SnowStormMapCatalog.toWorldY(
                            this.map, ASCompat.toInt(object.nextGoalTileY));
                        object.nextGoalActive = ASCompat.toInt(object.worldX) != goalWorldX ||
                            ASCompat.toInt(object.worldY) != goalWorldY;
                        object.direction = ASCompat.toInt(event.direction);
                    }
                    
                case SnowStormProtocol.EVENT_AVATAR_THROW:
                    object = this.objects[Std.string(ASCompat.toInt(event.objectId))];
                    if (object != null && object.type == SnowStormProtocol.OBJECT_AVATAR)
                    {
                        object.direction = SnowStormMath.direction360To8(SnowStormMath.componentAngle(
                            SnowStormMath.directorDiv(ASCompat.toInt(event.targetWorldX) - ASCompat.toInt(object.worldX), 200),
                            SnowStormMath.directorDiv(ASCompat.toInt(event.targetWorldY) - ASCompat.toInt(object.worldY), 200)));
                        // The uniform renderer owns Shockwave's exact 100 ms tr1 / 300 ms tr2 wall-
                        // clock sequence. Keep the presentation token alive across that interval.
                        object.presentationAction = "tr1";
                        object.presentationTicks = 8;
                        object.presentationSerial = ASCompat.toInt(object.presentationSerial) + 1;
                        Reflect.deleteField(object, "presentationNextAction");
                        Reflect.deleteField(object, "presentationNextTicks");
                    }
                    
                case SnowStormProtocol.EVENT_LAUNCH_SNOWBALL:
                    object = this.copyObject(event.object);
                    if (object.type == SnowStormProtocol.OBJECT_SNOWBALL &&
                        this.objects[object.objectId] == null)
                        this.objects[object.objectId] = object;
                    
                case SnowStormProtocol.EVENT_HIT:
                    target = this.objects[Std.string(ASCompat.toInt(event.targetId))];
                    if (target != null && target.type == SnowStormProtocol.OBJECT_AVATAR)
                    {
                        target.health = ASCompat.toInt(event.health);
                    }
                    
                case SnowStormProtocol.EVENT_STUN:
                    target = this.objects[Std.string(ASCompat.toInt(event.targetId))];
                    if (target != null && target.type == SnowStormProtocol.OBJECT_AVATAR)
                    {
                        skipActivityTick[target.objectId] = true;
                        // The server owns Shockwave's one-time death-direction decision. Keeping it
                        // in authoritative state prevents a recovery snapshot from rotating a room
                        // object which is already lying still on the ground.
                        target.standingDirection = ASCompat.toInt(target.direction);
                        target.direction = ASCompat.toInt(event.direction);
                        target.fallPose = ASCompat.toInt(event.fallPose);
                        target.presentationAction = ASCompat.toInt(event.fallPose) == 2 ? "fb1" : "ff1";
                        target.presentationSerial = ASCompat.toInt(target.presentationSerial) + 1;
                        Reflect.deleteField(target, "presentationTicks");
                        Reflect.deleteField(target, "presentationNextAction");
                        Reflect.deleteField(target, "presentationNextTicks");
                    }
                    
                case SnowStormProtocol.EVENT_ACTIVITY_STATE:
                    object = this.objects[Std.string(ASCompat.toInt(event.objectId))];
                    if (object != null && object.type == SnowStormProtocol.OBJECT_AVATAR)
                    {
                        object.activity = ASCompat.toInt(event.activity);
                        object.activityTimer = ASCompat.toInt(event.timer);
                        // Activity transitions can mutate health (STUNNED -> INVINCIBLE restores
                        // four hearts). Applying the authoritative value before suppressing this
                        // frame's local timer tick keeps the shared simulation checksum aligned.
                        object.health = ASCompat.toInt(event.health);
                        if (object.activity == SnowStormProtocol.ACTIVITY_INVINCIBLE)
                            skipActivityTick[object.objectId] = true;
                        if (object.activity != SnowStormProtocol.ACTIVITY_STUNNED) object.fallPose = 0;
                        if (object.activity != SnowStormProtocol.ACTIVITY_STUNNED &&
                            object.presentationAction != null &&
                            (ASCompat.toString(object.presentationAction).indexOf("ff") == 0 ||
                             ASCompat.toString(object.presentationAction).indexOf("fb") == 0))
                        {
                            Reflect.deleteField(object, "presentationAction");
                            Reflect.deleteField(object, "presentationTicks");
                        }
                    }
                    
                case SnowStormProtocol.EVENT_SNOWBALL_COUNT:
                    object = this.objects[Std.string(ASCompat.toInt(event.objectId))];
                    if (object != null && object.type == SnowStormProtocol.OBJECT_AVATAR)
                        object.snowballs = ASCompat.toInt(event.count);
                    
                case SnowStormProtocol.EVENT_MACHINE_RESTOCK:
                    object = this.objects[Std.string(ASCompat.toInt(event.machineId))];
                    if (object != null && object.type == SnowStormProtocol.OBJECT_MACHINE)
                        object.snowballs = ASCompat.toInt(event.count);
                    
                case SnowStormProtocol.EVENT_MACHINE_TRANSFER:
                    object = this.objects[Std.string(ASCompat.toInt(event.machineId))];
                    if (object != null && object.type == SnowStormProtocol.OBJECT_MACHINE)
                        object.snowballs = ASCompat.toInt(event.machineCount);
                    target = this.objects[Std.string(ASCompat.toInt(event.playerId))];
                    if (target != null && target.type == SnowStormProtocol.OBJECT_AVATAR)
                        target.snowballs = ASCompat.toInt(event.playerCount);
                    
                case SnowStormProtocol.EVENT_PLAYER_SCORE:
                    object = this.objects[Std.string(ASCompat.toInt(event.objectId))];
                    if (object != null && object.type == SnowStormProtocol.OBJECT_AVATAR)
                        object.score = ASCompat.toInt(event.score);
                    
            }
        }

        function advanceObjects(skipActivityTick:ASObject)
        {
var key:String  = null;            var ids:Array<ASAny> = [];
            var key:String = null;
            final _iter_:ASObject = this.objects; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.___keys()) {key = _tmp_;
ids.push(ASCompat.toInt(key));
};
            ASCompat.ASArray.sortWithOptions(ids, ASCompat.ASArray.NUMERIC);
            var object:ASObject = null;
            var id = 0;
            if (checkNullIteratee(ids)) for (_tmp_ in ids)
            {
id  = ASCompat.toInt(_tmp_);
                object = this.objects[Std.string(id)];
                if (object == null) continue;
                if (object.type == SnowStormProtocol.OBJECT_AVATAR)
                {
                    if (!skipActivityTick[Std.string(id)]) this.tickActivity(object);
                    this.advanceAvatarMovement(object);
                    if (ASCompat.toInt(object.presentationTicks) > 0)
                    {
                        object.presentationTicks = ASCompat.toInt(object.presentationTicks) - 1;
                        if (ASCompat.toInt(object.presentationTicks) <= 0)
                        {
                            if (object.presentationNextAction != null)
                            {
                                object.presentationAction = object.presentationNextAction;
                                object.presentationTicks = ASCompat.toInt(object.presentationNextTicks);
                                Reflect.deleteField(object, "presentationNextAction");
                                Reflect.deleteField(object, "presentationNextTicks");
                            }
                            else
                            {
                                Reflect.deleteField(object, "presentationAction");
                                Reflect.deleteField(object, "presentationTicks");
                            }
                        }
                    }
                }
                else if (object.type == SnowStormProtocol.OBJECT_SNOWBALL)
                    this.advanceSnowball(object);
            }
        }

        function tickActivity(avatar:ASObject)
        {
            var timer= ASCompat.toInt(avatar.activityTimer);
            if (timer <= 0) return;
            if (timer == 1)
            {
                if (avatar.activity == SnowStormProtocol.ACTIVITY_CREATING)
                {
                    avatar.snowballs = Math.min(SnowStormProtocol.MAX_AMMO,
                        ASCompat.toInt(avatar.snowballs) + 1);
                    avatar.activity = SnowStormProtocol.ACTIVITY_NORMAL;
                }
                else if (avatar.activity == SnowStormProtocol.ACTIVITY_STUNNED)
                {
                    avatar.health = SnowStormProtocol.MAX_HEALTH;
                    avatar.activity = SnowStormProtocol.ACTIVITY_INVINCIBLE;
                    timer = SnowStormProtocol.INVINCIBLE_SUBTURNS;
                }
                else if (avatar.activity == SnowStormProtocol.ACTIVITY_INVINCIBLE)
                    avatar.activity = SnowStormProtocol.ACTIVITY_NORMAL;
            }
            avatar.activityTimer = timer - 1;
        }

        function advanceAvatarMovement(avatar:ASObject)
        {
            // STUNNED is the only activity which cannot walk. The server deliberately permits
            // movement during INVINCIBLE_AFTER_STUN (3); blocking it here desynchronised the client
            // mirror while flashing, causing checksum recovery and a full-status position snap.
            if (avatar.activity == SnowStormProtocol.ACTIVITY_STUNNED) return;
            if (!avatar.nextGoalActive) return;
            var goalWorldX= SnowStormMapCatalog.toWorldX(this.map, ASCompat.toInt(avatar.nextGoalTileX));
            var goalWorldY= SnowStormMapCatalog.toWorldY(this.map, ASCompat.toInt(avatar.nextGoalTileY));
            avatar.worldX = SnowStormMath.stepAxis(ASCompat.toInt(avatar.worldX), goalWorldX);
            avatar.worldY = SnowStormMath.stepAxis(ASCompat.toInt(avatar.worldY), goalWorldY);
            if (avatar.worldX == goalWorldX && avatar.worldY == goalWorldY)
                avatar.nextGoalActive = false;
        }

        function advanceSnowball(snowball:ASObject)
        {
            snowball.timeToLive = ASCompat.toInt(snowball.timeToLive) - 1;
            snowball.worldX = ASCompat.toInt(snowball.worldX) + SnowStormMath.directorDiv(
                SnowStormMath.velocityX(ASCompat.toInt(snowball.direction)) * SnowStormProtocol.PROJECTILE_VELOCITY,
                SnowStormProtocol.PROJECTILE_DIRECTION_SCALE);
            snowball.worldY = ASCompat.toInt(snowball.worldY) + SnowStormMath.directorDiv(
                SnowStormMath.velocityY(ASCompat.toInt(snowball.direction)) * SnowStormProtocol.PROJECTILE_VELOCITY,
                SnowStormProtocol.PROJECTILE_DIRECTION_SCALE);
            var temporary= snowball.trajectory == SnowStormProtocol.TRAJECTORY_QUICK &&
                snowball.timeToLive > SnowStormProtocol.PROJECTILE_QUICK_DESCENT_POINT
                ? SnowStormProtocol.PROJECTILE_QUICK_DESCENT_POINT - ASCompat.toInt(snowball.parabolaOffset)
                : ASCompat.toInt(snowball.timeToLive) - ASCompat.toInt(snowball.parabolaOffset);
            var multiplier= snowball.trajectory == SnowStormProtocol.TRAJECTORY_QUICK
                ? SnowStormProtocol.PROJECTILE_QUICK_MULTIPLIER
                : (snowball.trajectory == SnowStormProtocol.TRAJECTORY_SHORT_LOB
                    ? SnowStormProtocol.PROJECTILE_SHORT_LOB_MULTIPLIER
                    : SnowStormProtocol.PROJECTILE_LONG_LOB_MULTIPLIER);
            var baseHeight= snowball.trajectory == SnowStormProtocol.TRAJECTORY_QUICK
                ? SnowStormProtocol.PROJECTILE_QUICK_HEIGHT
                : SnowStormProtocol.PROJECTILE_LOB_HEIGHT;
            snowball.height = (ASCompat.toInt(snowball.parabolaOffset) * ASCompat.toInt(snowball.parabolaOffset) -
                temporary * temporary) * multiplier + baseHeight;
        }

        function copyObject(source:ASObject):ASObject
        {
var key:String  = null;            var result:ASObject = {};
            if (checkNullIteratee(source)) for (_tmp_ in source.___keys()) {key = _tmp_;
ASCompat.setDynamicProperty(result, key, ASCompat.getDynamicProperty(source, key));
};
            if (result.type == SnowStormProtocol.OBJECT_AVATAR &&
                result.nextGoalActive == /*undefined*/null) result.nextGoalActive = false;
            // A full snapshot can arrive while the avatar is down. Shockwave has already advanced
            // from fall frame 1 to its frozen frame 2 by then, so reconstruct that stable pose rather
            // than briefly standing up or guessing a face-up fall from activity alone.
            if (result.type == SnowStormProtocol.OBJECT_AVATAR &&
                ASCompat.toInt(result.activity) == SnowStormProtocol.ACTIVITY_STUNNED &&
                result.presentationAction == null && ASCompat.toInt(result.fallPose) > 0)
                result.presentationAction = ASCompat.toInt(result.fallPose) == 2 ? "fb2" : "ff2";
            return result;
        }

        function copyObjects(source:ASObject):ASObject
        {
var key:String  = null;            var result:ASObject = {};
            if (checkNullIteratee(source)) for (_tmp_ in source.___keys()) {key = _tmp_;
ASCompat.setDynamicProperty(result, key, this.copyObject(ASCompat.getDynamicProperty(source, key)));
};
            return result;
        }

        function clearPlayback()
        {
            this._playbackFrames = [];
            this._nextPlaybackAt = 0;
        }

        function copyScores(source:ASObject):ASObject
        {
var key:String  = null;            var result:ASObject = {};
            if (checkNullIteratee(source)) for (_tmp_ in source.___keys()) {key = _tmp_;
ASCompat.setDynamicProperty(result, key, ASCompat.toInt(ASCompat.getDynamicProperty(source, key)));
};
            return result;
        }
public function new(){}
    }

