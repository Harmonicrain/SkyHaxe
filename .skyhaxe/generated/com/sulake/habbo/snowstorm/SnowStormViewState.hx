package com.sulake.habbo.snowstorm
;
     final class SnowStormViewState
    {
        var _ticketCost:Int = 0;
        var _ticketBalance:Int = 0;

                public var ticketCost(get,set):Int;
public function  get_ticketCost():Int { return this._ticketCost; }
public function  set_ticketCost(value:Int):Int{ this._ticketCost = Std.int(Math.max(0, value)); return value;
}
                public var ticketBalance(get,set):Int;
public function  get_ticketBalance():Int { return this._ticketBalance; }
public function  set_ticketBalance(value:Int):Int{ this._ticketBalance = Std.int(Math.max(0, value)); return value;
}
        public var balanceText(get,never):String;
public function  get_balanceText():String
        {
            var value= Std.string(this._ticketBalance);
            while (value.length < 3) value = "0" + value;
            return value;
        }
public function new(){}
    }

