package com.sulake.habbo.roomevents
;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.AllVariablesDiffMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.AllVariablesHashMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.RequestAllVariablesHashMessageComposer;
    import com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents.RequestVariablesDiffMessageComposer;
    import flash.events.TimerEvent;
    import flash.utils.Timer;

    /**
     * Room-scoped July variable hash/diff cache.
     *
     * The capability gate is deliberately checked at the send boundary: a clean
     * client connected to a legacy or partially upgraded server emits no variable
     * synchronization packets.
     */
     class WiredVariablesSynchronizer implements IDisposable
    {
        public static inline final STATUS_IDLE= 0;
        public static inline final STATUS_AWAIT_HASH= 1;
        public static inline final STATUS_AWAIT_DIFFS= 2;

        static inline final REQUEST_THROTTLE_MS= 800;
        static inline final STALE_REQUEST_MS= 4000;
        static inline final REQUEST_TIMEOUT_MS= 10000;
        static inline final MAX_CACHED_VARIABLES= 4096;
        static final FURNI_INTERNAL_ORDER:Array<ASAny> = [
            "@id", "@class_id", "@height", "@state",
            "@position.x", "@position.y", "@rotation", "@altitude",
            "@type", "@dimensions.x", "@dimensions.y", "@owner_id",
            "@is_invisible", "@is_stackable", "@can_stand_on",
            "@can_sit_on", "@can_lay_on",
            "@projectile.animation.tiles_travelled",
            "@projectile.animation.user_collisions",
            "@projectile.animation.furni_collisions",
            "@projectile.animation.position.x",
            "@projectile.animation.position.y",
            "@projectile.animation.position.altitude",
            "@projectile.animation.is_travelling"
        ];
        static final USER_INTERNAL_ORDER:Array<ASAny> = [
            "@index", "@type", "@gender", "@achievement_score", "@is_hc",
            "@has_rights", "@is_group_admin", "@is_owner",
            "@position.x", "@position.y", "@direction", "@altitude",
            "@handitem", "@effect", "@dance", "@sign", "@is_muted",
            "@is_trading", "@is_idle", "@user_id", "@pet_id", "@bot_id",
            "@favourite_group_id", "@team.score", "@team.color"
        ];
        static final GLOBAL_INTERNAL_ORDER:Array<ASAny> = [
            "@furni_count", "@user_count", "@wired_timer",
            "@teams.red.score", "@teams.red.size",
            "@teams.green.score", "@teams.green.size",
            "@teams.blue.score", "@teams.blue.size",
            "@teams.yellow.score", "@teams.yellow.size",
            "@room_id", "@group_id", "@current_time",
            "@current_time.milliseconds_of_seconds",
            "@current_time.seconds_of_minute",
            "@current_time.minute_of_hour", "@current_time.hour_of_day",
            "@current_time.day_of_week", "@current_time.day_of_month",
            "@current_time.day_of_year", "@current_time.week_of_year",
            "@current_time.month_of_year", "@current_time.year"
        ];
        static final CONTEXT_INTERNAL_ORDER:Array<ASAny> = [
            "@selector_furni_count", "@selector_user_count",
            "@signal_furni_count", "@signal_user_count",
            "@event.signal.antenna_id",
            "@event.chat.type", "@event.chat.style",
            "@event.variable_update.box_id",
            "@event.variable_update.change_type",
            "@event.variable_update.old_value",
            "@event.variable_update.new_value",
            "@event.variable_update.difference",
            "@event.variable_update.change_origin",
            "@event.transaction_complete.multiplier",
            "@event.transaction_complete.deposit.furni_count",
            "@event.transaction_complete.deposit.coins_count",
            "@event.transaction_complete.withdrawal.furni_count",
            "@event.transaction_complete.withdrawal.coins_count",
            "@event.transaction_failed.reason",
            "@held_down", "@held_down.total_duration_ticks",
            "@held_down.origin_type", "@held_down.origin_id",
            "@held_down.origin_x", "@held_down.origin_y",
            "@held_down.origin_valid", "@held_down.release_type",
            "@held_down.release_id", "@held_down.release_x",
            "@held_down.release_y"
        ];

        var _roomEvents:HabboUserDefinedRoomEvents;
        var _messageEvents:Array<ASAny>;
        var _timeout:Timer;
        var _status:Int = STATUS_IDLE;
        var _lastActivityAt:Float = -1;
        var _requestRoomId:Int = 0;
        var _allVariablesHash:Int = 0;
        var _pendingAllVariablesHash:Int = 0;
        var _receivedDiffChunk:Bool = false;
        var _variablesById:ASDictionary<ASAny,ASAny>;
        var _variableHashesById:ASDictionary<ASAny,ASAny>;
        var _stagedVariablesById:ASDictionary<ASAny,ASAny>;
        var _stagedHashesById:ASDictionary<ASAny,ASAny>;
        var _listeners:Vector<ASFunction> = new Vector();
        var _disposed:Bool = false;

        public function new(k:HabboUserDefinedRoomEvents)
        {
            this._roomEvents = k;
            this._messageEvents = [];
            this._messageEvents.push(this._roomEvents.communication.addHabboConnectionMessageEvent(
                new AllVariablesHashMessageEvent(this.onAllVariablesHashEvent)));
            this._messageEvents.push(this._roomEvents.communication.addHabboConnectionMessageEvent(
                new AllVariablesDiffMessageEvent(this.onAllVariablesDiffEvent)));
            this._timeout = new Timer(REQUEST_TIMEOUT_MS, 1);
            this._timeout.addEventListener(TimerEvent.TIMER_COMPLETE, (this.onRequestTimeout : ASAny));
        }

        /**
         * Calls k with a sorted Vector.<WiredVariable>. Returns true when the
         * callback was completed synchronously from cache (or fail-closed).
         */
        public function getAllVariables(k:ASFunction, forceRefresh:Bool=true,
                                        knownAggregateHash:Int=0):Bool
        {
            if (this._disposed || k == null)
            {
                return true;
            }
            if (!this.canSynchronize())
            {
                k(new Vector<WiredVariable>());
                return true;
            }

            var now= flash.Lib.getTimer();
            if (this._status != STATUS_IDLE && this._lastActivityAt < now - STALE_REQUEST_MS)
            {
                this.abortPending(true);
            }
            if (this._status != STATUS_IDLE)
            {
                this.addListener(k);
                return false;
            }
            if (this._lastActivityAt > now - REQUEST_THROTTLE_MS)
            {
                k(this.sortedCachedVariables);
                return true;
            }
            if (!forceRefresh && this._variablesById != null)
            {
                k(this.sortedCachedVariables);
                return true;
            }

            this._requestRoomId = this._roomEvents.roomId;
            this._lastActivityAt = now;
            this._status = STATUS_AWAIT_HASH;
            this.addListener(k);
            this.startTimeout();
            if (knownAggregateHash != 0)
            {
                this.onAllVariablesHash(knownAggregateHash);
            }
            else
            {
                this._roomEvents.send(new RequestAllVariablesHashMessageComposer());
            }
            return false;
        }

        public function getCachedVariableById(k:String):WiredVariable
        {
            return this._variablesById == null ? null : ASCompat.dynamicAs(this._variablesById[k] , WiredVariable);
        }

        function onAllVariablesHashEvent(k:IMessageEvent)
        {
            this.onAllVariablesHash(Std.downcast(k , AllVariablesHashMessageEvent).getParser().allVariablesHash);
        }

        function onAllVariablesHash(k:Int)
        {
            if (!this.isCurrentRequest(STATUS_AWAIT_HASH))
            {
                return;
            }
            this._lastActivityAt = flash.Lib.getTimer();
            if (k == this._allVariablesHash && this._variablesById != null)
            {
                this.completePending();
                return;
            }

            this._pendingAllVariablesHash = k;
            this._receivedDiffChunk = false;
            this._stagedVariablesById = this.cloneDictionary(this._variablesById);
            this._stagedHashesById = this.cloneDictionary(this._variableHashesById);
            this._status = STATUS_AWAIT_DIFFS;
            this._roomEvents.send(new RequestVariablesDiffMessageComposer(this._variableHashesById));
        }

        function onAllVariablesDiffEvent(k:IMessageEvent)
        {
var removedId:String  = null, variableObject:ASObject  = null, variable:WiredVariable  = null;            if (!this.isCurrentRequest(STATUS_AWAIT_DIFFS))
            {
                return;
            }
            var parser=
                Std.downcast(k , AllVariablesDiffMessageEvent).getParser();
            // The catalog may change between the hash request and the following
            // diff request; AIR's diff request carries no expected aggregate
            // hash. Accept the first chunk's current hash, then require every
            // remaining chunk in that response stream to use the same snapshot.
            if (this._receivedDiffChunk &&
                parser.allVariablesHash != this._pendingAllVariablesHash)
            {
                this.abortPending(true);
                return;
            }
            this._pendingAllVariablesHash = parser.allVariablesHash;
            this._receivedDiffChunk = true;

            this._lastActivityAt = flash.Lib.getTimer();
            final _iter_ = parser.removedVariables; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
removedId = _tmp_;
                this._stagedVariablesById.remove(removedId);
                this._stagedHashesById.remove(removedId);
            }
            final _iter_ = parser.addedOrUpdated; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.keys())
            {
variableObject = _tmp_;
variable= ASCompat.dynamicAs(variableObject , WiredVariable);
                this._stagedVariablesById[variable.variableId] = variable;
                this._stagedHashesById[variable.variableId] = ASCompat.toInt(parser.addedOrUpdated[variableObject]);
            }
            if (this.dictionarySize(this._stagedVariablesById) > MAX_CACHED_VARIABLES)
            {
                this.abortPending(true);
                return;
            }

            if (parser.isLastChunk)
            {
                this._variablesById = this._stagedVariablesById;
                this._variableHashesById = this._stagedHashesById;
                this._allVariablesHash = this._pendingAllVariablesHash;
                this.completePending();
            }
        }

        function isCurrentRequest(k:Int):Bool
        {
            if (this._status != k || !this.canSynchronize() ||
                this._requestRoomId != this._roomEvents.roomId)
            {
                if (this._status != STATUS_IDLE)
                {
                    this.abortPending(false);
                }
                return false;
            }
            return true;
        }

        function canSynchronize():Bool
        {
            return this._roomEvents != null && this._roomEvents.roomId > 0 &&
                this._roomEvents.isWiredFeatureEnabled(
                    WiredCapabilityCodes.VARIABLES | WiredCapabilityCodes.VARIABLE_SYNC);
        }

        function addListener(k:ASFunction)
        {
            if (this._listeners.indexOf(k) == -1)
            {
                this._listeners.push(k);
            }
        }

        public function removeListener(k:ASFunction)
        {
            if (this._listeners == null)
            {
                return;
            }
            var index= this._listeners.indexOf(k);
            if (index != -1)
            {
                this._listeners.splice(index, 1);
            }
        }

        function completePending()
        {
            this.stopTimeout();
            this._status = STATUS_IDLE;
            this._requestRoomId = 0;
            this._pendingAllVariablesHash = 0;
            this._receivedDiffChunk = false;
            this._stagedVariablesById = null;
            this._stagedHashesById = null;
            this.releaseListeners(this.sortedCachedVariables);
        }

        function abortPending(useCache:Bool)
        {
            this.stopTimeout();
            this._status = STATUS_IDLE;
            this._requestRoomId = 0;
            this._pendingAllVariablesHash = 0;
            this._receivedDiffChunk = false;
            this._stagedVariablesById = null;
            this._stagedHashesById = null;
            this.releaseListeners(useCache ? this.sortedCachedVariables : new Vector<WiredVariable>());
        }

        function releaseListeners(k:Vector<WiredVariable>)
        {
var listener:ASFunction  = null;            var listeners= this._listeners;
            this._listeners = new Vector<ASFunction>();
            if (checkNullIteratee(listeners)) for (_tmp_ in listeners)
            {
listener = _tmp_;
                try
                {
                    listener(k.concat());
                }
catch (__as3Caught:Dynamic) { var error:ASError = ASError.caught(__as3Caught);                 {
                }
 }            }
        }

        function startTimeout()
        {
            this._timeout.reset();
            this._timeout.start();
        }

        function stopTimeout()
        {
            if (this._timeout != null)
            {
                this._timeout.reset();
            }
        }

        function onRequestTimeout(k:TimerEvent)
        {
            if (this._status != STATUS_IDLE)
            {
                this.abortPending(true);
            }
        }

        var sortedCachedVariables(get,never):Vector<WiredVariable>;
function  get_sortedCachedVariables():Vector<WiredVariable>
        {
var variable:WiredVariable  = null;            var result= new Vector<WiredVariable>();
            if (this._variablesById != null)
            {
                final _iter_ = this._variablesById; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
variable = _tmp_;
                    result.push(variable);
                }
            }
            ASCompat.ASVector.sort(result, this.compareVariables);
            return result;
        }

        function compareVariables(a:WiredVariable, b:WiredVariable):Int
        {
var aId = Math.NaN, bId = Math.NaN, aRank = 0, bRank = 0;            var aInternal= a.variableType == 1;
            var bInternal= b.variableType == 1;
            if (aInternal != bInternal)
            {
                return aInternal ? 1 : -1;
            }
            if (aInternal)
            {
aId= ASCompat.toNumber(a.variableId);
bId= ASCompat.toNumber(b.variableId);
                if (!Math.isNaN(aId) && !Math.isNaN(bId))
                {
                    if (aId == bId)
                    {
                        return 0;
                    }
                    return aId > bId ? -1 : 1;
                }
aRank= this.internalVariableRank(a);
bRank= this.internalVariableRank(b);
                if (aRank != bRank)
                {
                    return aRank < bRank ? -1 : 1;
                }
                return Reflect.compare(a.variableName, b.variableName);
            }
            return Reflect.compare(a.variableName, b.variableName);
        }

        /**
         * July's official internal IDs are numeric and are ordered above.
         * Our capture-safe emulation keeps opaque string IDs, so use the same
         * semantic registry order instead of passing NaN to the comparator.
         */
        function internalVariableRank(variable:WiredVariable):Int
        {
            var order:Array<ASAny> = null;
            switch (variable.variableTarget)
            {
                case 0:
                    order = FURNI_INTERNAL_ORDER;
                    
                case 1:
                    order = USER_INTERNAL_ORDER;
                    
                case -10:
                    order = GLOBAL_INTERNAL_ORDER;
                    
                case -20:
                    order = CONTEXT_INTERNAL_ORDER;
                    
                default:
                    return ASCompat.MAX_INT;
            }
            var rank= order.indexOf(variable.variableName);
            return rank < 0 ? ASCompat.MAX_INT : rank;
        }

        function cloneDictionary(k:ASDictionary<ASAny,ASAny>):ASDictionary<ASAny,ASAny>
        {
var key:ASObject  = null;            var result= new ASDictionary<ASAny,ASAny>();
            if (k != null)
            {
                if (checkNullIteratee(k)) for (_tmp_ in k.keys())
                {
key = _tmp_;
                    result[key] = k[key];
                }
            }
            return result;
        }

        function dictionarySize(k:ASDictionary<ASAny,ASAny>):Int
        {
var key:ASObject  = null;            var count= 0;
            if (checkNullIteratee(k)) for (_tmp_ in k.keys())
            {
key = _tmp_;
                count++;
                if (count > MAX_CACHED_VARIABLES)
                {
                    break;
                }
            }
            return count;
        }

        /** Stops room-scoped work, clears cache and releases every waiter. */
        public function clear()
        {
            this.stopTimeout();
            this._status = STATUS_IDLE;
            this._requestRoomId = 0;
            this._allVariablesHash = 0;
            this._pendingAllVariablesHash = 0;
            this._receivedDiffChunk = false;
            this._lastActivityAt = -1;
            this._variablesById = null;
            this._variableHashesById = null;
            this._stagedVariablesById = null;
            this._stagedHashesById = null;
            this.releaseListeners(new Vector<WiredVariable>());
        }

        public function dispose()
        {
var event:IMessageEvent  = null;            if (this._disposed)
            {
                return;
            }
            this.clear();
            this._disposed = true;
            if (this._timeout != null)
            {
                this._timeout.removeEventListener(TimerEvent.TIMER_COMPLETE, (this.onRequestTimeout : ASAny));
                this._timeout = null;
            }
            final _iter_ = this._messageEvents; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
event = _tmp_;
                this._roomEvents.communication.removeHabboConnectionMessageEvent(event);
            }
            this._messageEvents = null;
            this._listeners = null;
            this._roomEvents = null;
        }

        public var status(get,never):Int;
public function  get_status():Int { return this._status; }
        public var disposed(get,never):Bool;
public function  get_disposed():Bool { return this._disposed; }
    }

