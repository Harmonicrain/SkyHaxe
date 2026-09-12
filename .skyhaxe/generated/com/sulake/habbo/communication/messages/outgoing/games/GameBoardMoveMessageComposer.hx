package com.sulake.habbo.communication.messages.outgoing.games
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class GameBoardMoveMessageComposer implements IMessageComposer
    {
        var _stationId:Int = 0;
        var _command:String;
        var _args:Array<ASAny>;

        public function new(stationId:Int, command:String, args:Array<ASAny>)
        {
            this._stationId = stationId;
            this._command = command;
            this._args = (args == null ? [] : args);
        }

        public function getMessageArray():Array<ASAny>
        {
var arg:ASObject  = null;            var encodedArgs:Array<ASAny> = [];
            final _iter_ = this._args; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
arg = _tmp_;
                encodedArgs.push(arg == null ? "" : ASCompat.toString(arg));
            }
            return ([this._stationId, this._command, encodedArgs.length] : Array<Dynamic>).concat(encodedArgs);
        }

        public function dispose()
        {
        }
    }

