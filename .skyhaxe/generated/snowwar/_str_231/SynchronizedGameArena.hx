package snowwar._str_231
;
	import com.sulake.core.runtime.IDisposable;
	import com.sulake.core.utils.Map;
	import snowwar.SnowWarEngine;
	import snowwar.SnowWarGameStage;

     class SynchronizedGameArena implements IDisposable 
    {
        var _snowWarEngine:SnowWarEngine;
        var _events:Array<ASAny>;
        var turn:Int = 0;
        var _subturn:Int = 0;
        var _SafeStr_19001:Int = 1;
        var _synchronizedGameStage:SynchronizedGameStage;
        var _extension:_SafeStr_4033;
        var _checksums:Map;
        var _disposed:Bool = false;
        var _newTurn:Bool = false;
        var _SafeStr_18581:Int = 0;
        var _SafeStr_19006:Array<ASAny>;
		
        public function dispose()
        {
            this._disposed = true;
            this._snowWarEngine = null;
            this._events = null;
            this._synchronizedGameStage = null;
            if (this._extension != null)
            {
                this._extension.dispose();
                this._extension = null;
            }
            this._checksums = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function initialize(k:SnowWarEngine, _arg_2:Int)
        {
            this._snowWarEngine = k;
            this._synchronizedGameStage = new SnowWarGameStage();
            this._checksums = new Map();
            this._events = [];
            this._SafeStr_18581 = _arg_2;
            this.turn = 0;
            this._subturn = 0;
            this._events[this.turn] = this.generateEventsList();
            this._checksums = new Map();
            this._SafeStr_19010();
        }

        public var snowWarEngine(get,never):SnowWarEngine;
public function  get_snowWarEngine():SnowWarEngine
        {
            return this._snowWarEngine;
        }

        public function handleTurn()
        {
            this.gameTurn();
        }

        public function gameTurn()
        {
            var events:Array<ASAny> = null;
            var event:_SafeStr_4019 = null;
            if (HabboGamesCom.logEnabled)
            {
                HabboGamesCom.log([((((("Turn " + Std.string(this.turn)) + " subturn ") + Std.string(this._subturn + 1)) + "/") + Std.string(this.maxSubTurns()))]);
            }
            var stage= this.synchronizedGameStage();
            var turnEvents:Array<ASAny> = this._events[this.turn];
            if (turnEvents != null)
            {
                events = turnEvents[this._subturn];
                while (events.length > 0)
                {
                    event = ASCompat.dynamicAs(events.shift() , _SafeStr_4019);
                    if (HabboGamesCom.logEnabled)
                    {
                        HabboGamesCom.log([((((((("GameInstance::gameTurn: applying event " + event) + " turn ") + Std.string(this.turn)) + " subturn ") + Std.string(this._subturn + 1)) + "/") + Std.string(this.maxSubTurns()))]);
                    }
                    event.apply(stage);
                }
            }
            if (!this._newTurn)
            {
                stage.subturn();
            }
            if (this._subturn >= (this.maxSubTurns() - 1))
            {
                if ((this.turn % this._SafeStr_19001) == 0)
                {
                    this._checksums.setProperty(this.turn, this.synchronizedGameStage()._SafeStr_18712(this.turn));
                }
                this.turn++;
                this._newTurn = false;
                if (HabboGamesCom.logEnabled)
                {
                    HabboGamesCom.log([("Turn:" + Std.string(this.turn))]);
                }
            }
            this._subturn++;
            if (this._subturn >= this.maxSubTurns())
            {
                this._subturn = 0;
            }
        }

        public function addGameEvent(turn:Int, subturn:Int, event:_SafeStr_4019)
        {
            var eventsList:Array<ASAny> = this._events[turn];
            if (eventsList == null)
            {
                eventsList = this.generateEventsList();
                this._events[turn] = eventsList;
            }
            eventsList[subturn].push(event);
            if (HabboGamesCom.logEnabled)
            {
                HabboGamesCom.log([((((("Add game event: " + event) + " (subturn/turn): ") + Std.string(subturn)) + "/") + Std.string(turn))]);
            }
        }

        public function _SafeStr_19008()
        {
            var _local_3:Array<ASAny> = null;
            var _local_4 = 0;
            var _local_5:Array<ASAny> = null;
            var _local_6:_SafeStr_4019 = null;
            var k= "";
            var _local_2 = 0;
            while (_local_2 < this._events.length)
            {
                _local_3 = this._events[_local_2];
                if (_local_3 == null)
                {
                }
                else
                {
                    _local_4 = 0;
                    while (_local_4 < this.maxSubTurns())
                    {
                        _local_5 = _local_3[_local_4];
                        if (_local_5.length == 0)
                        {
                        }
                        else
                        {
                            k = (k + (((Std.string(_local_2) + " (") + Std.string(_local_4)) + ") : "));
                            if (checkNullIteratee(_local_5)) for (_tmp_ in _local_5)
                            {
_local_6  = _tmp_;
                                k = (k + _local_6);
                            }
                            k = (k + "\n");
                        }
                        _local_4++;
                    }
                }
                _local_2++;
            }
            HabboGamesCom.log([k]);
        }

        public function maxSubTurns():Int
        {
            return this.getExtension().maxSubTurns();
        }

        public function getTurn():Int //_SafeStr_13240
        {
            return this.turn;
        }

        public var subturn(get,never):Int;
public function  get_subturn():Int
        {
            return this._subturn;
        }

        public function synchronizedGameStage():SynchronizedGameStage //synchronizedGameStage
        {
            return this._synchronizedGameStage;
        }

        public function getExtension():_SafeStr_4033
        {
            return this._extension;
        }

        public function registerExtension(k:_SafeStr_4033)
        {
            this._extension = k;
            k.synchronizedGameArena = this;
        }

        public function _SafeStr_13254(k:Int):Int
        {
            return this._checksums.getValue(k); // this._SafeStr_19004[k];
        }

        public function newTurn(turn:Int, checkSum:Int)
        {
            this.turn = turn;
            this._subturn = 0;
            this._checksums.setProperty(this.turn, checkSum);
            this._events = [];
            this._events[this.turn] = this.generateEventsList();
            this._newTurn = true;
        }

        function generateEventsList():Array<ASAny>
        {
            var events:Array<ASAny> = [];
            var turn = 0;
            while (turn < this.maxSubTurns())
            {
                events[turn] = ([] : Array<Dynamic>);
                turn++;
            }
            return events;
        }

        public var _SafeStr_13274(get,never):Int;
public function  get__SafeStr_13274():Int
        {
            return this._SafeStr_18581;
        }

        function _SafeStr_19010()
        {
            this._SafeStr_19006 = [];
            var k = 0;
            while (k < this._SafeStr_18581)
            {
                this._SafeStr_19006[k] = 0;
                k++;
            }
        }

        public function _SafeStr_18855(k:Int, _arg_2:Int)
        {
            if (((k > 0) && (k <= this._SafeStr_18581)))
            {
                this._SafeStr_19006[(k - 1)] = (this._SafeStr_19006[(k - 1)] + _arg_2);
            }
        }

        public function _SafeStr_19011():Array<ASAny>
        {
            return this._SafeStr_19006;
        }
public function new(){}
    }

