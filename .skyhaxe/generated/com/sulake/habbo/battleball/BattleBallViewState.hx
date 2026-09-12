package com.sulake.habbo.battleball
;
    /**
     * The few values more than one BattleBall window needs.
     *
     * Deliberately tiny. Everything a single window owns stays in that window; this holds only what is
     * genuinely shared, so it cannot quietly become another god object.
     *
     * The facade is the only writer: setTicketBalance() updates the balance, and the ticket cost
     * arrives with showLobby/showCreate/showGameInfo/showFinalScores. Renderers read both.
     */
     class BattleBallViewState
    {
        var _ticketCost:Int = 0;
        var _ticketBalance:Int = 0;

                public var ticketCost(get,set):Int;
public function  get_ticketCost():Int { return this._ticketCost; }
public function  set_ticketCost(value:Int):Int{ this._ticketCost = Std.int(Math.max(0, value)); return value;
}

        
        public var ticketBalance(get,set):Int;
public function  get_ticketBalance():Int { return this._ticketBalance; }

        /** Shockwave shows the balance as a fixed-width three-digit counter, e.g. 002. */
        public var balanceText(get,never):String;
public function  get_balanceText():String
        {
            var value= Std.string(this._ticketBalance);
            while (value.length < 3) value = "0" + value;
            return value;
        }
public function  set_ticketBalance(value:Int):Int{ this._ticketBalance = Std.int(Math.max(0, value)); return value;
}
public function new(){}
    }

