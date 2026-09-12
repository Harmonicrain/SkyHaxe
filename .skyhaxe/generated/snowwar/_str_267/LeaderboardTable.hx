package snowwar._str_267
;
	import com.sulake.habbo.communication.messages.parser.game.score.LeaderboardEntry;
	import com.sulake.core.communication.messages.IMessageComposer;
	import snowwar._str_477._SafeStr_3694;
	import snowwar.SnowWarEngine;

     class LeaderboardTable 
    {
        public static inline final _SafeStr_22045= 0;
        public static inline final _SafeStr_22046= 1;

        var _SafeStr_18579:SnowWarEngine;
        var _SafeStr_22047:Bool = false;
        var _SafeStr_12643:Int = 0;
        var _disposed:Bool = false;
        var _SafeStr_13384:Array<ASAny>;
        var _SafeStr_22048:Int = -1;
        var _SafeStr_21821:Int = 0;
        var _SafeStr_22049:Int = 8;
        var _SafeStr_22050:Int = 50;
        var _SafeStr_22051:Bool = true;
        var _SafeStr_22052:Int = 0;

        public function new(k:SnowWarEngine)
        {
            this._SafeStr_18579 = k;
            this._SafeStr_12643 = this._SafeStr_18579.sessionDataManager.userId;
            this._SafeStr_22049 = this._SafeStr_18579.config.getInteger("games.highscores.viewSize", 8);
            this._SafeStr_22050 = this._SafeStr_18579.config.getInteger("games.highscores.windowSize", 50);
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            this._SafeStr_22053();
            this._SafeStr_18579 = null;
            this._SafeStr_13384 = null;
            this._disposed = true;
        }

        public function _SafeStr_22053()
        {
            this._SafeStr_22048 = -1;
            this._SafeStr_13384 = null;
            this._SafeStr_21821 = -1;
            this._SafeStr_22051 = true;
        }

        public function addEntries(k:Array<ASAny>, _arg_2:Int)
        {
            this._SafeStr_21821 = _arg_2;
            if (this._SafeStr_13384 == null)
            {
                this._SafeStr_13384 = k;
                this.initializeList();
            }
            else
            {
                this._SafeStr_13384 = k;
                this._SafeStr_22054();
            }
            this._SafeStr_22051 = false;
        }

        function initializeList()
        {
            var k = 0;
            var _local_2 = 0;
            while (_local_2 < this._SafeStr_13384.length)
            {
                if (ASCompat.dynamicAs(this._SafeStr_13384[_local_2] , LeaderboardEntry).userId == this._SafeStr_12643)
                {
                    k = _local_2;
                    break;
                }
                _local_2++;
            }
            if (k >= this._SafeStr_22049)
            {
                this._SafeStr_22048 = Std.int(k - (this._SafeStr_22049 / 2));
            }
            else
            {
                this._SafeStr_22048 = 0;
            }
        }

        function _SafeStr_22054()
        {
            if (this._SafeStr_22048 < 0)
            {
                this._SafeStr_22048 = (this._SafeStr_22048 + this._SafeStr_22050);
            }
            else
            {
                this._SafeStr_22048 = (this._SafeStr_22048 - this._SafeStr_22050);
            }
        }

        public function _SafeStr_6727():Bool
        {
            return !(this._SafeStr_13384 == null);
        }

        public function scrollUp():Bool
        {
            var k = 0;
            var _local_2:IMessageComposer = null;
            if (this._SafeStr_22051)
            {
                return false;
            }
            this._SafeStr_22048 = (this._SafeStr_22048 - this._SafeStr_22049);
            if (this._SafeStr_22048 < 0)
            {
                if (this._SafeStr_13384[0].rank > 1)
                {
                    k = Std.int(Math.max(1, ASCompat.toNumber(ASCompat.toNumber(this._SafeStr_13384[0].rank) - this._SafeStr_22050)));
                    _local_2 = this.getMessageComposer(this._SafeStr_22052, k, _SafeStr_22046);
                    this._SafeStr_18579.communication.connection.send(_local_2);
                    this._SafeStr_22051 = true;
                    return false;
                }
                this._SafeStr_22048 = 0;
            }
            return true;
        }

        function getMessageComposer(k:Int, _arg_2:Int, _arg_3:Int):IMessageComposer
        {
            return new _SafeStr_3694(k, _arg_2, _arg_3, this._SafeStr_22049, this._SafeStr_22050);
        }

        public function scrollDown():Bool
        {
            var k = 0;
            var _local_2:IMessageComposer = null;
            if (this._SafeStr_22051)
            {
                return false;
            }
            this._SafeStr_22048 = (this._SafeStr_22048 + this._SafeStr_22049);
            if ((this._SafeStr_22048 + this._SafeStr_22049) >= this._SafeStr_13384.length)
            {
                if (this._SafeStr_13384[(this._SafeStr_13384.length - 1)].rank < this._SafeStr_21821)
                {
                    k = ASCompat.toInt(this._SafeStr_13384[(this._SafeStr_13384.length - 1)].rank + 1);
                    _local_2 = this.getMessageComposer(this._SafeStr_22052, k, _SafeStr_22045);
                    this._SafeStr_18579.communication.connection.send(_local_2);
                    this._SafeStr_22051 = true;
                    return false;
                }
            }
            return true;
        }

        public function _SafeStr_18662(k:Int)
        {
            this._SafeStr_22053();
            var _local_2= this.getMessageComposer(k, -1, _SafeStr_22045);
            this._SafeStr_18579.communication.connection.send(_local_2);
            this._SafeStr_22051 = true;
            this._SafeStr_22052 = k;
        }

        public function getVisibleEntries():Array<ASAny>
        {
            var k:Array<ASAny> = [];
            if (this._SafeStr_13384 == null)
            {
                return k;
            }
            var _local_2= Std.int(Math.min(this._SafeStr_13384.length, (this._SafeStr_22048 + this._SafeStr_22049)));
            var _local_3= this._SafeStr_22048;
            while (_local_3 < _local_2)
            {
                k.push(this._SafeStr_13384[_local_3]);
                _local_3++;
            }
            return k;
        }

        public function _SafeStr_18663():Bool
        {
            if (((this._SafeStr_22051 || (!(this._SafeStr_13384 != null))) || (this._SafeStr_13384.length == 0)))
            {
                return false;
            }
            if (((this._SafeStr_13384[0].rank == 1) && (this._SafeStr_22048 <= 0)))
            {
                return false;
            }
            return true;
        }

        public function _SafeStr_18664():Bool
        {
            if (((this._SafeStr_22051 || (!(this._SafeStr_13384 != null))) || (this._SafeStr_13384.length == 0)))
            {
                return false;
            }
            if (((this._SafeStr_13384[(this._SafeStr_13384.length - 1)].rank >= this._SafeStr_21821) && ((this._SafeStr_22048 + this._SafeStr_22049) >= this._SafeStr_13384.length)))
            {
                return false;
            }
            return true;
        }

        public var viewSize(get,never):Int;
public function  get_viewSize():Int
        {
            return this._SafeStr_22049;
        }
    }

